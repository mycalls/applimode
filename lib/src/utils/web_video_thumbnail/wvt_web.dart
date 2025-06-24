import 'dart:async';
import 'dart:js_interop';
import 'dart:math' as math;

// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// external
import 'package:image_picker/image_picker.dart';
import 'package:web/web.dart' as web;

// utils
import 'package:applimode_app/src/utils/web_video_thumbnail/wvt_stub.dart';

WvtStub getInstance() => WvtWeb();

// An error code value to error name Map.
// See: https://developer.mozilla.org/en-US/docs/Web/API/MediaError/code
const Map<int, String> _kErrorValueToErrorName = <int, String>{
  1: 'MEDIA_ERR_ABORTED',
  2: 'MEDIA_ERR_NETWORK',
  3: 'MEDIA_ERR_DECODE',
  4: 'MEDIA_ERR_SRC_NOT_SUPPORTED',
};

// An error code value to description Map.
// See: https://developer.mozilla.org/en-US/docs/Web/API/MediaError/code
const Map<int, String> _kErrorValueToErrorDescription = <int, String>{
  1: 'The user canceled the fetching of the video.',
  2: 'A network error occurred while fetching the video, despite having previously been available.',
  3: 'An error occurred while trying to decode the video, despite having previously been determined to be usable.',
  4: 'The video has been found to be unsuitable (missing or in a format not supported by your browser).',
};

// The default error message, when the error is an empty string
// See: https://developer.mozilla.org/en-US/docs/Web/API/MediaError/message
const String _kDefaultErrorMessage =
    'No further diagnostic information can be determined or provided.';

/// A web implementation of the VideoThumbnailPlatform of the VideoThumbnail plugin.
class WvtWeb implements WvtStub {
  /// Constructs a VideoThumbnailWeb
  WvtWeb();

  @override
  Future<Uint8List> getThumbnailData({
    required String video,
    required int maxHeight,
    required int maxWidth,
    required int quality,
    Map<String, String>? headers,
  }) async {
    final blob = await _createThumbnail(
      videoSrc: video,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      quality: quality,
    );
    final path = web.URL.createObjectURL(blob);
    final file = XFile(path, mimeType: blob.type);
    final bytes = await file.readAsBytes();
    web.URL.revokeObjectURL(path);

    return bytes;
  }

  Future<web.Blob> _createThumbnail({
    required String videoSrc,
    required int maxHeight,
    required int maxWidth,
    required int quality,
  }) async {
    final completer = Completer<web.Blob>();

    final video = web.document.createElement('video') as web.HTMLVideoElement;
    final timeSec = math.max(0 / 1000, 0);

    video.onLoadedMetadata.listen((event) {
      video.currentTime = timeSec;
      video.muted = true;
      video.setAttribute('playsinline', '');
    });

    video.onSeeked.listen((web.Event e) async {
      if (kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        // await Future.delayed(const Duration(milliseconds: 100));
        video.play();
        video.onTimeUpdate.listen((event) async {
          if (video.currentTime > 0.5) {
            video.pause();
            if (!completer.isCompleted) {
              final canvas =
                  web.document.createElement('canvas') as web.HTMLCanvasElement;
              final ctx =
                  canvas.getContext('2d')! as web.CanvasRenderingContext2D;

              if (maxWidth == 0 && maxHeight == 0) {
                canvas
                  ..width = video.videoWidth
                  ..height = video.videoHeight;
                ctx.drawImage(video, 0, 0);
              } else {
                final aspectRatio = video.videoWidth / video.videoHeight;
                if (maxWidth == 0) {
                  maxWidth = (maxHeight * aspectRatio).round();
                } else if (maxHeight == 0) {
                  maxHeight = (maxWidth / aspectRatio).round();
                }

                final inputAspectRatio = maxWidth / maxHeight;
                if (aspectRatio > inputAspectRatio) {
                  maxHeight = (maxWidth / aspectRatio).round();
                } else {
                  maxWidth = (maxHeight * aspectRatio).round();
                }

                canvas
                  ..width = maxWidth
                  ..height = maxHeight;
                ctx.drawImage(
                    video, 0, 0, maxWidth.toDouble(), maxHeight.toDouble());
              }

              try {
                canvas.toBlob(
                  (web.Blob blob) {
                    completer.complete(blob);
                  }.toJS,
                  'image/jpeg',
                  (quality / 100).toJS,
                );
              } catch (e, s) {
                completer.completeError(
                  PlatformException(
                    code: 'CANVAS_EXPORT_ERROR',
                    details: e,
                    stacktrace: s.toString(),
                  ),
                  s,
                );
              }
            }
          }
        });
      } else {
        await Future.delayed(const Duration(milliseconds: 100));
        if (!completer.isCompleted) {
          final canvas =
              web.document.createElement('canvas') as web.HTMLCanvasElement;
          final ctx = canvas.getContext('2d')! as web.CanvasRenderingContext2D;

          if (maxWidth == 0 && maxHeight == 0) {
            canvas
              ..width = video.videoWidth
              ..height = video.videoHeight;
            ctx.drawImage(video, 0, 0);
          } else {
            final aspectRatio = video.videoWidth / video.videoHeight;
            if (maxWidth == 0) {
              maxWidth = (maxHeight * aspectRatio).round();
            } else if (maxHeight == 0) {
              maxHeight = (maxWidth / aspectRatio).round();
            }

            final inputAspectRatio = maxWidth / maxHeight;
            if (aspectRatio > inputAspectRatio) {
              maxHeight = (maxWidth / aspectRatio).round();
            } else {
              maxWidth = (maxHeight * aspectRatio).round();
            }

            canvas
              ..width = maxWidth
              ..height = maxHeight;
            ctx.drawImage(
                video, 0, 0, maxWidth.toDouble(), maxHeight.toDouble());
          }

          try {
            canvas.toBlob(
              (web.Blob blob) {
                completer.complete(blob);
              }.toJS,
              'image/jpeg',
              (quality / 100).toJS,
            );
          } catch (e, s) {
            completer.completeError(
              PlatformException(
                code: 'CANVAS_EXPORT_ERROR',
                details: e,
                stacktrace: s.toString(),
              ),
              s,
            );
          }
        }
      }
    });

    video.onError.listen((web.Event e) {
      // The Event itself (_) doesn't contain info about the actual error.
      // We need to look at the HTMLMediaElement.error.
      // See: https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/error
      if (!completer.isCompleted) {
        final error = video.error!;
        completer.completeError(
          PlatformException(
            code: _kErrorValueToErrorName[error.code]!,
            message:
                error.message != '' ? error.message : _kDefaultErrorMessage,
            details: _kErrorValueToErrorDescription[error.code],
          ),
        );
      }
    });

    video
      ..crossOrigin = 'Anonymous'
      ..src = videoSrc;

    return completer.future;
  }
}

/*
import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:math' as math;

import 'package:applimode_app/src/utils/web_video_thumbnail/wvt_stub.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

WvtStub getInstance() => WvtWeb();

// An error code value to error name Map.
// See: https://developer.mozilla.org/en-US/docs/Web/API/MediaError/code
const Map<int, String> _kErrorValueToErrorName = <int, String>{
  1: 'MEDIA_ERR_ABORTED',
  2: 'MEDIA_ERR_NETWORK',
  3: 'MEDIA_ERR_DECODE',
  4: 'MEDIA_ERR_SRC_NOT_SUPPORTED',
};

// An error code value to description Map.
// See: https://developer.mozilla.org/en-US/docs/Web/API/MediaError/code
const Map<int, String> _kErrorValueToErrorDescription = <int, String>{
  1: 'The user canceled the fetching of the video.',
  2: 'A network error occurred while fetching the video, despite having previously been available.',
  3: 'An error occurred while trying to decode the video, despite having previously been determined to be usable.',
  4: 'The video has been found to be unsuitable (missing or in a format not supported by your browser).',
};

// The default error message, when the error is an empty string
// See: https://developer.mozilla.org/en-US/docs/Web/API/MediaError/message
const String _kDefaultErrorMessage =
    'No further diagnostic information can be determined or provided.';

/// A web implementation of the VideoThumbnailPlatform of the VideoThumbnail plugin.
class WvtWeb implements WvtStub {
  /// Constructs a VideoThumbnailWeb
  WvtWeb();

  @override
  Future<Uint8List> getThumbnailData({
    required String video,
    required int maxHeight,
    required int maxWidth,
    required int quality,
    Map<String, String>? headers,
  }) async {
    final blob = await _createThumbnail(
        videoSrc: video,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        quality: quality,
        headers: headers);
    final path = Url.createObjectUrlFromBlob(blob);
    final file = XFile(path, mimeType: blob.type);
    final bytes = await file.readAsBytes();
    Url.revokeObjectUrl(path);

    return bytes;
  }

  Future<Blob> _createThumbnail({
    required String videoSrc,
    required int maxHeight,
    required int maxWidth,
    required int quality,
    Map<String, String>? headers,
  }) async {
    final completer = Completer<Blob>();

    final video = document.createElement('video') as VideoElement;
    final timeSec = math.max(0 / 1000, 0);
    final fetchVideo = headers != null && headers.isNotEmpty;

    video.onLoadedMetadata.listen((event) {
      video.currentTime = timeSec;
      video.muted = true;
      video.setAttribute('playsinline', '');

      if (fetchVideo) {
        Url.revokeObjectUrl(video.src);
      }
    });

    video.onSeeked.listen((Event e) async {
      if (kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        // await Future.delayed(const Duration(milliseconds: 100));
        video.play();
        video.onTimeUpdate.listen((event) async {
          if (video.currentTime > 0.5) {
            video.pause();
            if (!completer.isCompleted) {
              final canvas = document.createElement('canvas') as CanvasElement;
              final ctx = canvas.getContext('2d')! as CanvasRenderingContext2D;

              if (maxWidth == 0 && maxHeight == 0) {
                canvas
                  ..width = video.videoWidth
                  ..height = video.videoHeight;
                ctx.drawImage(video, 0, 0);
              } else {
                final aspectRatio = video.videoWidth / video.videoHeight;
                if (maxWidth == 0) {
                  maxWidth = (maxHeight * aspectRatio).round();
                } else if (maxHeight == 0) {
                  maxHeight = (maxWidth / aspectRatio).round();
                }

                final inputAspectRatio = maxWidth / maxHeight;
                if (aspectRatio > inputAspectRatio) {
                  maxHeight = (maxWidth / aspectRatio).round();
                } else {
                  maxWidth = (maxHeight * aspectRatio).round();
                }

                canvas
                  ..width = maxWidth
                  ..height = maxHeight;
                ctx.drawImageScaled(video, 0, 0, maxWidth, maxHeight);
              }

              try {
                final blob = canvas.toBlob(
                  'image/jpeg',
                  quality / 100,
                );

                completer.complete(blob);
              } catch (e, s) {
                completer.completeError(
                  PlatformException(
                    code: 'CANVAS_EXPORT_ERROR',
                    details: e,
                    stacktrace: s.toString(),
                  ),
                  s,
                );
              }
            }
          }
        });
      } else {
        await Future.delayed(const Duration(milliseconds: 100));
        if (!completer.isCompleted) {
          final canvas = document.createElement('canvas') as CanvasElement;
          final ctx = canvas.getContext('2d')! as CanvasRenderingContext2D;

          if (maxWidth == 0 && maxHeight == 0) {
            canvas
              ..width = video.videoWidth
              ..height = video.videoHeight;
            ctx.drawImage(video, 0, 0);
          } else {
            final aspectRatio = video.videoWidth / video.videoHeight;
            if (maxWidth == 0) {
              maxWidth = (maxHeight * aspectRatio).round();
            } else if (maxHeight == 0) {
              maxHeight = (maxWidth / aspectRatio).round();
            }

            final inputAspectRatio = maxWidth / maxHeight;
            if (aspectRatio > inputAspectRatio) {
              maxHeight = (maxWidth / aspectRatio).round();
            } else {
              maxWidth = (maxHeight * aspectRatio).round();
            }

            canvas
              ..width = maxWidth
              ..height = maxHeight;
            ctx.drawImageScaled(video, 0, 0, maxWidth, maxHeight);
          }

          try {
            final blob = canvas.toBlob(
              'image/jpeg',
              quality / 100,
            );

            completer.complete(blob);
          } catch (e, s) {
            completer.completeError(
              PlatformException(
                code: 'CANVAS_EXPORT_ERROR',
                details: e,
                stacktrace: s.toString(),
              ),
              s,
            );
          }
        }
      }
    });

    video.onError.listen((Event e) {
      // The Event itself (_) doesn't contain info about the actual error.
      // We need to look at the HTMLMediaElement.error.
      // See: https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/error
      if (!completer.isCompleted) {
        final error = video.error!;
        completer.completeError(
          PlatformException(
            code: _kErrorValueToErrorName[error.code]!,
            message:
                error.message != '' ? error.message : _kDefaultErrorMessage,
            details: _kErrorValueToErrorDescription[error.code],
          ),
        );
      }
    });

    if (fetchVideo) {
      try {
        final blob = await _fetchVideoByHeaders(
          videoSrc: videoSrc,
          headers: headers,
        );

        video.src = Url.createObjectUrlFromBlob(blob);
      } catch (e, s) {
        completer.completeError(e, s);
      }
    } else {
      video
        ..crossOrigin = 'Anonymous'
        ..src = videoSrc;
    }

    return completer.future;
  }

  /// Fetching video by [headers].
  ///
  /// To avoid reading the video's bytes into memory, set the
  /// [HttpRequest.responseType] to 'blob'. This allows the blob to be stored in
  /// the browser's disk or memory cache.
  Future<Blob> _fetchVideoByHeaders({
    required String videoSrc,
    Map<String, String>? headers,
  }) async {
    final completer = Completer<Blob>();

    final xhr = HttpRequest()
      ..open('GET', videoSrc, async: true)
      ..responseType = 'blob';
    if (headers != null) {
      headers.forEach(xhr.setRequestHeader);
    }

    xhr.onLoad.first.then((ProgressEvent value) {
      completer.complete(xhr.response as Blob);
    });

    xhr.onError.first.then((ProgressEvent value) {
      completer.completeError(
        PlatformException(
          code: 'VIDEO_FETCH_ERROR',
          message: 'Status: ${xhr.statusText}',
        ),
      );
    });

    xhr.send();

    return completer.future;
  }
}
*/

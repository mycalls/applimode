import 'dart:async';

import 'package:applimode_app/src/common_widgets/gradient_color_box.dart';
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class BasicVideoPlayer extends StatefulWidget {
  const BasicVideoPlayer({
    super.key,
    required this.videoUrl,
    this.videoController,
  });
  final String videoUrl;
  final VideoPlayerController? videoController;

  @override
  State<BasicVideoPlayer> createState() => _BasicVideoPlayerState();
}

class _BasicVideoPlayerState extends State<BasicVideoPlayer> {
  VideoPlayerController? _controller;
  bool isOverlay = true;
  Timer? t;

  bool _isCancelled = false;

  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.videoController == null) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
        httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : const {},
      );
    } else {
      _controller = widget.videoController!;
    }

    if (_controller != null) {
      if (widget.videoController == null) {
        // _controller.setLooping(true);
        _controller?.initialize();
      }
      // t = Timer(overlayDuration, () {});
      if (_controller!.value.isPlaying) {
        overlayTofalse();
      }
      _controller?.addListener(_setStateListener);
    }
  }

  @override
  void dispose() {
    _isCancelled = true;
    if (widget.videoController == null) {
      _controller?.dispose();
    }
    t?.cancel();
    _controller?.removeListener(_setStateListener);
    WakelockPlus.disable();
    super.dispose();
  }

  void _safeSetState([VoidCallback? callback]) {
    if (_isCancelled) return;
    if (mounted) {
      safeBuildCall(() => setState(() {
            callback?.call();
          }));
    }
  }

  void _setStateListener() {
    if (_controller != null) {
      try {
        _safeSetState(() {
          if (_controller!.value.isPlaying) {
            WakelockPlus.enable();
          }
          if (!_controller!.value.isPlaying) {
            WakelockPlus.disable();
          }
        });
      } catch (e) {
        debugPrint('BasicVideoPlayer-_setStateListener: ${e.toString()}');
      }
    }
  }

  void overlayToTrue() {
    try {
      t?.cancel();
      _safeSetState(() => isOverlay = true);
    } catch (e) {
      debugPrint('BasicVideoPlayer-overlayToTrue-error: ${e.toString()}');
    }
  }

  void overlayTofalse() {
    try {
      t?.cancel();
      _safeSetState(() => isOverlay = false);
    } catch (e) {
      debugPrint('BasicVideoPlayer-overlayToFalse-error: ${e.toString()}');
    }
  }

  void pauseWithOverlay() {
    try {
      t?.cancel();
      isOverlay = true;
      _controller?.pause();
    } catch (e) {
      debugPrint('BasicVideoPlayer-pauseWithOverlay-error: ${e.toString()}');
    }
  }

  void lazyOverlayToFalse() {
    try {
      t?.cancel();
      t = Timer(overlayDuration, () {
        _safeSetState(() => isOverlay = false);
      });
    } catch (e) {
      debugPrint('BasicVideoPlayer-lazyOverlayToFalse-error: ${e.toString()}');
    }
  }

  double getWidthForFullSizeMedia(double aspectRatio) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final ratio = width / height;
    return ratio > aspectRatio ? height * aspectRatio : width;
  }

  @override
  Widget build(BuildContext context) {
    // if VideoController is null
    if (_controller == null) {
      return Center(
          child: Text(
        context.loc.videoNotFound,
        style: TextStyle(color: Colors.white),
      ));
    }

    return !_controller!.value.isInitialized
        ? AspectRatio(
            aspectRatio: 16 / 9,
            child: GradientColorBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CupertinoActivityIndicator(
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.loc.loadingVideo,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          )
        : AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: _controller!.value.hasError
                ? const SizedBox.shrink()
                : Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(_controller!),
                      if (isOverlay)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black26,
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          if (_controller!.value.isPlaying && !isOverlay) {
                            overlayToTrue();
                            lazyOverlayToFalse();
                          } else if (_controller!.value.isPlaying &&
                              isOverlay) {
                            overlayTofalse();
                          } else if (!_controller!.value.isPlaying &&
                              !isOverlay) {
                            overlayToTrue();
                          } else {}
                        },
                      ),
                      if (!_controller!.value.isPlaying && isOverlay)
                        Center(
                          child: IconButton(
                            onPressed: () {
                              lazyOverlayToFalse();
                              _controller!.play();
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 80,
                              semanticLabel: 'Play',
                            ),
                          ),
                        ),
                      if (_controller!.value.isPlaying && isOverlay)
                        Center(
                          child: IconButton(
                            onPressed: () {
                              pauseWithOverlay();
                            },
                            icon: const Icon(
                              Icons.pause,
                              color: Colors.white,
                              size: 80,
                              semanticLabel: 'Stop',
                            ),
                          ),
                        ),
                      if (isOverlay) ...[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 12),
                              IconButton(
                                onPressed: () {
                                  if (_controller!.value.isPlaying) {
                                    pauseWithOverlay();
                                  } else {
                                    lazyOverlayToFalse();
                                    _controller!.play();
                                  }
                                },
                                icon: Icon(
                                  _controller!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                                color: Colors.white,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_controller!.value.volume == 0.0) {
                                    if (_controller!.value.isPlaying) {
                                      lazyOverlayToFalse();
                                    }
                                    _controller!.setVolume(1.0);
                                  } else {
                                    if (_controller!.value.isPlaying) {
                                      lazyOverlayToFalse();
                                    }
                                    _controller!.setVolume(0.0);
                                  }
                                },
                                icon: Icon(
                                  _controller!.value.volume == 0.0
                                      ? Icons.volume_off
                                      : Icons.volume_up,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                Format.durationToString(
                                    _controller!.value.position),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                ' / ${Format.durationToString(_controller!.value.duration)}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!_controller!.value.isPlaying)
                                PopupMenuButton<double>(
                                  initialValue:
                                      _controller!.value.playbackSpeed,
                                  tooltip: 'Playback speed',
                                  onSelected: (double speed) {
                                    _controller!.setPlaybackSpeed(speed);
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return <PopupMenuItem<double>>[
                                      for (final double speed
                                          in _examplePlaybackRates)
                                        PopupMenuItem<double>(
                                          value: speed,
                                          child: Text('${speed}x'),
                                        )
                                    ];
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      '${_controller!.value.playbackSpeed}x',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              // if (!kIsWeb)
                              IconButton(
                                onPressed: () {
                                  if (kIsWeb) {
                                    WebBackStub().back();
                                  } else {
                                    if (context.canPop()) {
                                      context.pop(widget.videoController);
                                    }
                                  }

                                  /*
                                        if (kIsWeb) {
                                          pauseWithOverlay();
                                          launchUrl(Uri.parse(widget.videoUrl));
                                        } else {
                                          t.cancel();
                                          overlayTofalses();
                                          await context.push(
                                            ScreenPaths.video(widget.videoUrl),
                                            extra: _controller,
                                          );
                                          if (!_controller!.value.isPlaying) {
                                            overlayToTrue();
                                          }
                                        }
                                        */
                                  /*
                                        if (kIsWeb) {
                                          final startPosition =
                                              _controller.value.position;
                                          final volume =
                                              _controller!.value.volume;
                                          _controller!.initialize().then((_) {
                                            _controller!
                                              ..seekTo(startPosition)
                                              ..setVolume(volume)
                                              ..play();
                                          });
                                        }
                                        */
                                },
                                icon: const Icon(
                                  Icons.fullscreen,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                        Positioned(
                          width: widget.videoController == null
                              ? MediaQuery.sizeOf(context).width
                              : getWidthForFullSizeMedia(
                                  _controller!.value.aspectRatio),
                          bottom: 48,
                          child: VideoProgressIndicator(
                            _controller!,
                            padding: const EdgeInsets.only(top: 32),
                            allowScrubbing: true,
                          ),
                        ),
                      ]
                    ],
                  ),
          );
  }
}

import 'dart:io';

import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/src/features/video_player/base_video_player.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/full_video_screen_button.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_gesture_detector.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_left_duration.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_player_center_icon.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_progress_bar.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_volume_button.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class PostVideoPlayer extends BaseVideoPlayer {
  const PostVideoPlayer({
    super.key,
    required super.videoUrl,
    super.videoImageUrl,
    super.disposeController = true,
    this.isIosLocal = false,
    this.isFullScreen = false,
    this.videoController,
    this.position,
  });

  final bool isIosLocal;
  final bool isFullScreen;
  final VideoPlayerController? videoController;
  final Duration? position;

  @override
  ConsumerState<PostVideoPlayer> createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends BaseVideoPlayerState<PostVideoPlayer> {
  bool get isFullScreen => widget.isFullScreen;

  @override
  void initState() {
    super.initState();
    if (widget.videoController == null) {
      if (widget.isIosLocal) {
        controller = VideoPlayerController.file(File(widget.videoUrl));
      } else {
        controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
          httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : const {},
        );
      }
    } else {
      controller = widget.videoController;
    }

    if (!widget.isFullScreen &&
            (widget.videoImageUrl == null || widget.videoImageUrl!.isEmpty) ||
        (widget.isFullScreen && widget.videoController == null)) {
      initializeVideo(
        autoPlay: widget.isFullScreen ? true : false,
        position: widget.position,
      );
    }
    controller?.addListener(setStateListener);
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || isError) {
      return isFullScreen
          ? buildVideoNotFoundContainer()
          : AspectRatio(
              aspectRatio: 16 / 9,
              child: buildVideoNotFoundContainer(),
            );
    }

    if (!controller!.value.isInitialized) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (widget.videoImageUrl != null && !isFullScreen)
            PlatformNetworkImage(
              imageUrl: widget.videoImageUrl!,
              headers: useRTwoSecureGet ? rTwoSecureHeader : null,
              fit: BoxFit.cover,
              errorWidget: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black26,
                ),
              ),
            ),
          if (!isLoading && !isFullScreen)
            IconButton(
              onPressed: initializeVideo,
              icon: const Icon(Icons.play_arrow),
              iconSize: 80,
              color: Colors.white70,
            ),
          if (isLoading)
            const CupertinoActivityIndicator(
              color: Colors.white,
            ),
        ],
      );
    } else {
      return AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(controller!),
            /*
            if (!_controller.value.isPlaying)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                ),
              ),
              */
            if (isLoading ||
                controller!.value.isBuffering && !controller!.value.isCompleted)
              const Align(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              ),
            if (!controller!.value.isPlaying) ...[
              const VideoPlayerCenterIcon(),
              VideoLeftDuration(controller: controller!),
            ],
            VideoPlayerGestureDetector(
              controller: controller!,
            ),
            VideoVolumeButton(
              controller: controller!,
            ),
            FullVideoScreenButton(
              videoUrl: widget.videoUrl,
              isFullScreen: isFullScreen,
              controller: controller,
            ),
            VideoProgressBar(controller: controller!),
          ],
        ),
      );
    }
  }
}

/*
// video player frame size is same as video size.
class PostVideoPlayer extends ConsumerStatefulWidget {
  const PostVideoPlayer({
    super.key,
    required this.videoUrl,
    this.videoImageUrl,
    this.isIosLocal = false,
    this.isFullScreen = false,
    this.videoController,
    this.position,
  });

  final String videoUrl;
  final String? videoImageUrl;
  final bool isIosLocal;
  final bool isFullScreen;
  final VideoPlayerController? videoController;
  final Duration? position;

  @override
  ConsumerState<PostVideoPlayer> createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends ConsumerState<PostVideoPlayer> {
  VideoPlayerController? _controller;
  bool isLoading = false;
  bool isError = false;

  bool _isCancelled = false;

  bool get isFullScreen => widget.isFullScreen;

  @override
  void initState() {
    super.initState();
    if (widget.videoController == null) {
      if (widget.isIosLocal) {
        _controller = VideoPlayerController.file(File(widget.videoUrl));
      } else {
        _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
          httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : const {},
        );
      }
    } else {
      _controller = widget.videoController;
    }

    if (widget.videoImageUrl == null ||
        widget.videoImageUrl!.isEmpty ||
        (widget.isFullScreen && widget.videoController == null)) {
      _initializeVideo(
        autoPlay: widget.isFullScreen ? true : false,
        position: widget.position,
      );
    }
    _controller?.addListener(_setStateListener);
  }

  @override
  void dispose() {
    _isCancelled = true;
    _controller?.dispose();
    WakelockPlus.disable();
    _controller?.removeListener(_setStateListener);
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
        debugPrint('PostVideoPlayer-_setStateListener: ${e.toString()}');
      }
    }
  }

  Future<void> _initializeVideo({
    bool autoPlay = true,
    bool isMute = false,
    Duration? position,
  }) async {
    if (_controller != null) {
      try {
        // _safeSetState(() => isLoading = true);
        isLoading = true;
        _controller?.initialize().then((value) {
          isLoading = false;
          if (isMute) _controller?.setVolume(0.0);
          if (position != null) _controller?.seekTo(position);
          if (autoPlay) _controller?.play();
        }, onError: (e) {
          isError = true;
          debugPrint('PostVideoPlayer-_initializeVideo-error: ${e.toString()}');
        });
      } catch (e) {
        debugPrint('PostVideoPlayer-_initializeVideo-error: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || isError) {
      return isFullScreen
          ? VideoNotFoundContainer()
          : AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoNotFoundContainer(),
            );
    }

    if (!_controller!.value.isInitialized) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (widget.videoImageUrl != null && !isFullScreen)
            PlatformNetworkImage(
              imageUrl: widget.videoImageUrl!,
              headers: useRTwoSecureGet ? rTwoSecureHeader : null,
              fit: BoxFit.cover,
              errorWidget: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black26,
                ),
              ),
            ),
          if (!isLoading && !isFullScreen)
            IconButton(
              onPressed: _initializeVideo,
              icon: const Icon(Icons.play_arrow),
              iconSize: 80,
              color: Colors.white70,
            ),
          if (isLoading)
            const CupertinoActivityIndicator(
              color: Colors.white,
            ),
        ],
      );
    } else {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller!),
            /*
            if (!_controller.value.isPlaying)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                ),
              ),
              */
            if (isLoading ||
                _controller!.value.isBuffering &&
                    !_controller!.value.isCompleted)
              const Align(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              ),
            if (!_controller!.value.isPlaying) const VideoPlayerCenterIcon(),
            VideoPlayerGestureDetector(
              controller: _controller!,
            ),
            VideoVolumeButton(
              controller: _controller!,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () async {
                    if (isFullScreen) {
                      if (kIsWeb) {
                        WebBackStub().back();
                      } else {
                        if (context.canPop()) {
                          context.pop(widget.videoController);
                        }
                      }
                    } else {
                      if (kIsWeb) {
                        _controller!.pause();
                        await context.push(
                          ScreenPaths.fullVideo(widget.videoUrl),
                          extra: {
                            'controller': null,
                            'position': _controller?.value.position,
                          },
                        );
                      } else {
                        await context.push(
                          ScreenPaths.fullVideo(widget.videoUrl),
                          extra: _controller,
                        );
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (!_controller!.value.isPlaying)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: Text(
                    Format.durationToString(_controller!.value.duration -
                        _controller!.value.position),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            VideoProgressBar(controller: _controller!),
          ],
        ),
      );
    }
  }
}

class VideoNotFoundContainer extends StatelessWidget {
  const VideoNotFoundContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          context.loc.videoNotFound,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
*/

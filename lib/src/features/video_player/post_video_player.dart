import 'dart:io';

import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_gesture_detector.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_player_center_icon.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_progress_bar.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_volume_button.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// video player frame size is same as video size.
class PostVideoPlayer extends StatefulWidget {
  const PostVideoPlayer({
    super.key,
    required this.videoUrl,
    this.videoImageUrl,
    this.isIosLocal = false,
  });

  final String videoUrl;
  final String? videoImageUrl;
  final bool isIosLocal;

  @override
  State<PostVideoPlayer> createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  VideoPlayerController? _controller;
  bool isLoading = false;
  double? thumbnailAspectRatio;

  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    if (widget.isIosLocal) {
      _controller = VideoPlayerController.file(File(widget.videoUrl));
    } else {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
        httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : const {},
      );
    }
    if (_controller != null) {
      // _controller.setLooping(true);
      if (widget.videoImageUrl == null || widget.videoImageUrl!.isEmpty) {
        isLoading = true;
        _controller?.initialize().then((value) {
          isLoading = false;
        },
            onError: (e) =>
                debugPrint('PostVideoPlayer-initState-error: ${e.toString()}'));
      }
      _controller?.addListener(_setStateListener);
    }
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
        debugPrint('MainVideoPlayer-_setStateListener: ${e.toString()}');
      }
    }
  }

  Future<void> _initializeVideo() async {
    if (_controller != null) {
      try {
        // _safeSetState(() => isLoading = true);
        isLoading = true;
        _controller?.initialize().then((value) {
          isLoading = false;
        },
            onError: (e) => debugPrint(
                'PostVideoPlayer-_initializeVideo-error: ${e.toString()}'));
        _controller?.play();
      } catch (e) {
        debugPrint('PostVideoPlayer-_initializeVideo-error: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: Center(
            child: Text(
              context.loc.videoNotFound,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    if (!_controller!.value.isInitialized && widget.videoImageUrl != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
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
          /*
          CachedNetworkImage(
            imageUrl: widget.videoImageUrl!,
            httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : null,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black26,
                ),
              );
            },
          ),
          */
          /*
          Positioned.fill(
            child: Container(
              color: Colors.black26,
            ),
          ),
          */
          if (!isLoading)
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
    } else if (!_controller!.value.isInitialized &&
        widget.videoImageUrl == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black26,
          child: const Center(
            child: Icon(
              Icons.play_arrow,
              size: 80,
              color: Colors.white70,
            ),
          ),
        ),
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
                    if (kIsWeb) {
                      _controller!.pause();
                      await context.push(
                        ScreenPaths.fullVideo(widget.videoUrl),
                        // extra: _controller,
                      );
                    } else {
                      await context.push(
                        ScreenPaths.fullVideo(widget.videoUrl),
                        extra: _controller,
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
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

// video player for aspect ratio
/*
class PostVideoPlayer extends StatefulWidget {
  const PostVideoPlayer({
    super.key,
    required this.videoUrl,
    this.videoImageUrl,
    this.isIosLocal = false,
  });

  final String videoUrl;
  final String? videoImageUrl;
  final bool isIosLocal;

  @override
  State<PostVideoPlayer> createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  late VideoPlayerController _controller;
  bool isLoading = false;
  double? thumbnailAspectRatio;

  @override
  void initState() {
    super.initState();

    if (widget.isIosLocal) {
      _controller = VideoPlayerController.file(File(widget.videoUrl));
    } else {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
        httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : const {},
      );
    }
    _controller.addListener(_setState);
    // _controller.setLooping(true);
    if (widget.videoImageUrl == null || widget.videoImageUrl!.isEmpty) {
      isLoading = true;
      setState(() {});
      _controller.initialize().then((value) {
        isLoading = false;
        setState(() {});
      }, onError: (e) => debugPrint('videoInit: ${e.toString()}'));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    WakelockPlus.disable();
    _controller.removeListener(_setState);
    super.dispose();
  }

  void _setState() {
    setState(() {
      if (_controller.value.isPlaying) {
        WakelockPlus.enable();
      }
      if (!_controller.value.isPlaying) {
        WakelockPlus.disable();
      }
    });
  }

  Future<void> _initializeVideo() async {
    isLoading = true;
    setState(() {});
    _controller.initialize().then((value) {
      isLoading = false;
      setState(() {});
    }, onError: (e) => debugPrint('videoInit: ${e.toString()}'));
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized && widget.videoImageUrl != null) {
      return AspectRatio(
        aspectRatio: postVideoAspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PlatformNetworkImage(
              imageUrl: widget.videoImageUrl!,
              headers: useRTwoSecureGet ? rTwoSecureHeader : null,
              fit: BoxFit.cover,
              errorWidget: Container(
                color: Colors.black26,
              ),
            ),
            /*
            Positioned.fill(
              child: Container(
                color: Colors.black26,
              ),
            ),
            */
            if (!isLoading)
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
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: postVideoAspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: Container(color: Colors.black)),
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            /*
            if (!_controller.value.isPlaying)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                ),
              ),
              */
            if (isLoading ||
                _controller.value.isBuffering && !_controller.value.isCompleted)
              const Align(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              ),
            if (!_controller.value.isPlaying) const VideoPlayerCenterIcon(),
            VideoPlayerGestureDetector(
              controller: _controller,
            ),
            VideoVolumeButton(
              controller: _controller,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () async {
                    if (kIsWeb) {
                      _controller.pause();
                      await context.push(
                        ScreenPaths.video(widget.videoUrl),
                        // extra: _controller,
                      );
                    } else {
                      await context.push(
                        ScreenPaths.video(widget.videoUrl),
                        extra: _controller,
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            VideoProgressBar(controller: _controller),
          ],
        ),
      );
    }
  }
}
*/

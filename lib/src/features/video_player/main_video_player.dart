import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/src/features/video_player/base_video_player.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_gesture_detector.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_left_duration.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_player_center_icon.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_progress_bar.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_volume_button.dart';
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:applimode_app/src/utils/posts_item_mute_state.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/posts_item_playing_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class MainVideoPlayer extends BaseVideoPlayer {
  const MainVideoPlayer({
    super.key,
    required super.videoUrl,
    super.videoImageUrl,
    this.aspectRatio,
    this.isPage = false,
    this.isRound = false,
  });

  final double? aspectRatio;
  final bool isPage;
  final bool isRound;

  @override
  ConsumerState<MainVideoPlayer> createState() => _MainVideoPlayerState();
}

class _MainVideoPlayerState extends BaseVideoPlayerState<MainVideoPlayer> {
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : const {},
    );
    final isMute = ref.read(postsItemMuteStateProvider);
    if (widget.videoImageUrl == null || widget.videoImageUrl!.isEmpty) {
      initializeVideo(autoPlay: false, isMute: isMute);
    }
    controller?.addListener(setStateListener);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(postsItemPlayingStateProvider, (_, next) {
      if (next == false) {
        controller?.pause();
      }
    });

    // VideoPlayerController is null
    if (controller == null || isError) {
      return buildVideoNotFoundContainer();
    }

    return AspectRatio(
      aspectRatio: widget.aspectRatio ?? 1.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.videoImageUrl != null) ...[
            Positioned.fill(
              child: PlatformNetworkImage(
                imageUrl: widget.videoImageUrl!,
                headers: useRTwoSecureGet ? rTwoSecureHeader : null,
                fit: BoxFit.cover,
                errorWidget: Container(
                  color: Colors.black,
                ),
              ),
            ),
            if (!controller!.value.isInitialized) ...[
              if (isLoading)
                const CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              if (!isLoading)
                Padding(
                  padding: widget.isRound
                      ? const EdgeInsets.only(bottom: 64)
                      : EdgeInsets.zero,
                  child: IconButton(
                    onPressed: () {
                      initializeVideo(
                          isMute: ref.read(postsItemMuteStateProvider));
                    },
                    icon: const Icon(Icons.play_arrow),
                    iconSize: widget.isRound ? 64 : 80,
                    color: Colors.white70,
                  ),
                ),
            ]
          ],
          if (controller!.value.isInitialized &&
              !controller!.value.hasError) ...[
            AspectRatio(
              aspectRatio: widget.aspectRatio ?? 1.0,
              child: FittedBox(
                clipBehavior: Clip.hardEdge,
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller!.value.size.width,
                  height: controller!.value.size.height,
                  child: VideoPlayer(controller!),
                ),
              ),
            ),
            if (isLoading ||
                controller!.value.isBuffering && !controller!.value.isCompleted)
              const Align(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator(color: Colors.white),
              ),
            if (!controller!.value.isPlaying) ...[
              VideoPlayerCenterIcon(
                isRound: widget.isRound,
              ),
              VideoLeftDuration(controller: controller!),
            ],
            VideoPlayerGestureDetector(
              controller: controller!,
            ),
            SafeArea(
              top: widget.isPage ? true : false,
              bottom: widget.isPage ? true : false,
              left: widget.isPage ? true : false,
              right: widget.isPage ? true : false,
              child: VideoVolumeButton(
                controller: controller!,
              ),
            ),
            SafeArea(
              top: widget.isPage ? true : false,
              bottom: widget.isPage ? true : false,
              left: widget.isPage ? true : false,
              right: widget.isPage ? true : false,
              child: VideoProgressBar(
                controller: controller!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/*
class MainVideoPlayer extends ConsumerStatefulWidget {
  const MainVideoPlayer({
    super.key,
    required this.videoUrl,
    this.videoImageUrl,
    this.aspectRatio,
    this.isPage = false,
    this.isRound = false,
  });

  final String videoUrl;
  final String? videoImageUrl;
  final double? aspectRatio;
  final bool isPage;
  final bool isRound;

  @override
  ConsumerState<MainVideoPlayer> createState() => _MainVideoPlayerState();
}

class _MainVideoPlayerState extends ConsumerState<MainVideoPlayer> {
  VideoPlayerController? _controller;
  bool isLoading = false;
  bool isError = false;

  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : const {},
    );
    final isMute = ref.read(postsItemMuteStateProvider);
    if (widget.videoImageUrl == null || widget.videoImageUrl!.isEmpty) {
      _initializeVideo(autoPlay: false, isMute: isMute);
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
        debugPrint('MainVideoPlayer-_setStateListener: ${e.toString()}');
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
    ref.listen(postsItemPlayingStateProvider, (_, next) {
      if (next == false) {
        _controller?.pause();
      }
    });

    // VideoPlayerController is null
    if (_controller == null || isError) {
      return VideoNotFoundContainer();
    }

    return AspectRatio(
      aspectRatio: widget.aspectRatio ?? 1.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.videoImageUrl != null) ...[
            Positioned.fill(
              child: PlatformNetworkImage(
                imageUrl: widget.videoImageUrl!,
                headers: useRTwoSecureGet ? rTwoSecureHeader : null,
                fit: BoxFit.cover,
                errorWidget: Container(
                  color: Colors.black,
                ),
              ),
            ),
            if (!isLoading && !_controller!.value.isInitialized)
              Padding(
                padding: widget.isRound
                    ? const EdgeInsets.only(bottom: 64)
                    : EdgeInsets.zero,
                child: IconButton(
                  onPressed: () {
                    _initializeVideo(
                        isMute: ref.read(postsItemMuteStateProvider));
                  },
                  icon: const Icon(Icons.play_arrow),
                  iconSize: widget.isRound ? 64 : 80,
                  color: Colors.white70,
                ),
              ),
            if (isLoading && !_controller!.value.isInitialized)
              const CupertinoActivityIndicator(
                color: Colors.white,
              ),
          ],
          // Positioned.fill(child: Container(color: Colors.black)),
          if (_controller!.value.hasError)
            Positioned.fill(
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
            ),
          if (_controller!.value.isInitialized &&
              !_controller!.value.hasError) ...[
            AspectRatio(
              aspectRatio: widget.aspectRatio ?? 1.0,
              child: FittedBox(
                clipBehavior: Clip.hardEdge,
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              ),
            ),
            if (isLoading ||
                _controller!.value.isBuffering &&
                    !_controller!.value.isCompleted)
              const Align(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator(color: Colors.white),
              ),
            if (!_controller!.value.isPlaying)
              VideoPlayerCenterIcon(
                isRound: widget.isRound,
              ),
            VideoPlayerGestureDetector(
              controller: _controller!,
            ),
            SafeArea(
              top: widget.isPage ? true : false,
              bottom: widget.isPage ? true : false,
              left: widget.isPage ? true : false,
              right: widget.isPage ? true : false,
              child: VideoVolumeButton(
                padding: const EdgeInsets.only(top: 8, left: 8),
                controller: _controller!,
              ),
            ),
            SafeArea(
              top: widget.isPage ? true : false,
              bottom: widget.isPage ? true : false,
              left: widget.isPage ? true : false,
              right: widget.isPage ? true : false,
              child: VideoProgressBar(
                controller: _controller!,
              ),
            ),
          ],
        ],
      ),
    );
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

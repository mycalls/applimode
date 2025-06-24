// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';

// video player frame size is same as video size.
abstract class BaseVideoPlayer extends ConsumerStatefulWidget {
  const BaseVideoPlayer({
    super.key,
    required this.videoUrl,
    this.videoImageUrl,
    this.disposeController = true,
  });

  final String videoUrl;
  final String? videoImageUrl;
  final bool disposeController;
}

// ignore: unused_element
abstract class BaseVideoPlayerState<T extends BaseVideoPlayer>
    extends ConsumerState<T> {
  VideoPlayerController? controller;
  bool isLoading = false;
  bool isError = false;
  bool isCancelled = false;

  @override
  void dispose() {
    isCancelled = true;
    if (widget.disposeController) controller?.dispose();
    WakelockPlus.disable();
    controller?.removeListener(setStateListener);
    super.dispose();
  }

  void safeSetState([VoidCallback? callback]) {
    if (isCancelled || !mounted) return;
    safeBuildCall(() => setState(() {
          callback?.call();
        }));
  }

  void setStateListener() {
    if (controller != null && controller!.value.isInitialized && mounted) {
      try {
        safeSetState(() {
          if (controller!.value.isPlaying) {
            WakelockPlus.enable();
          }
          if (!controller!.value.isPlaying) {
            WakelockPlus.disable();
          }
        });
      } catch (e) {
        debugPrint('BaseVideoPlayer-_setStateListener: ${e.toString()}');
      }
    }
  }

  Future<void> initializeVideo({
    bool autoPlay = true,
    bool isMute = false,
    Duration? position,
  }) async {
    if (controller == null ||
        isLoading ||
        (controller?.value.isInitialized ?? false)) {
      return;
    }
    safeSetState(() {
      isLoading = true;
      isError = false;
    });
    try {
      await controller!.initialize();
      safeSetState(() {
        isLoading = false;
      });
      if (mounted && controller!.value.isInitialized) {
        if (isMute) controller?.setVolume(0.0);
        if (position != null) controller?.seekTo(position);
        if (autoPlay) controller?.play();
      }
    } catch (e) {
      safeSetState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('BaseVideoPlayer-_initializeVideo-error: ${e.toString()}');
    }
  }

  Widget buildVideoNotFoundContainer() {
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

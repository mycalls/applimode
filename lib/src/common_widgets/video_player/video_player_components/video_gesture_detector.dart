// flutter
import 'package:flutter/material.dart';

// external
import 'package:video_player/video_player.dart';

class VideoPlayerGestureDetector extends StatelessWidget {
  const VideoPlayerGestureDetector({
    super.key,
    required this.controller,
  });

  final VideoPlayerController controller;

  void _handlePlayAndPause() {
    if (!controller.value.isInitialized ||
        controller.value.duration <= Duration.zero) {
      return;
    }
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void _handleDoubleTap({bool isRight = false}) {
    if (!controller.value.isInitialized ||
        controller.value.duration <= Duration.zero) {
      return;
    }
    const seekDuration = Duration(seconds: 5);
    final currentPosition = controller.value.position;
    final videoDuration = controller.value.duration;

    Duration targetPosition = isRight
        ? currentPosition + seekDuration
        : currentPosition - seekDuration;

    // --- Corrected Clamping Logic for Duration ---
    if (targetPosition < Duration.zero) {
      targetPosition = Duration.zero; // Limit to beginning
    } else if (targetPosition > videoDuration) {
      targetPosition = videoDuration; // Limit to end
    }
    // -------------------------------------------

    controller.seekTo(targetPosition);
  }

  @override
  Widget build(BuildContext context) {
    // Return an empty container if controller is not ready (prevents errors)
    if (!controller.value.isInitialized) {
      return const SizedBox.shrink(); // Or another placeholder
    }

    return Row(
      children: [
        Expanded(
            child: GestureDetector(
          onTap: _handlePlayAndPause,
          onDoubleTap: () => _handleDoubleTap(isRight: false),
        )),
        Expanded(
            child: GestureDetector(
          onTap: _handlePlayAndPause,
          onDoubleTap: () => _handleDoubleTap(isRight: true),
        ))
      ],
    );

    /*
    return GestureDetector(
      onTap: () {
        if (controller.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
      },
    );
    */
  }
}

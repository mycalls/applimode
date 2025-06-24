// flutter
import 'package:flutter/material.dart';

// external
import 'package:video_player/video_player.dart';

class VideoProgressBar extends StatelessWidget {
  const VideoProgressBar({
    super.key,
    required this.controller,
    this.alignment,
    this.allowScrubbing,
    this.padding,
  });

  final VideoPlayerController controller;
  final Alignment? alignment;
  final bool? allowScrubbing;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.bottomCenter,
      child: VideoProgressIndicator(
        controller,
        allowScrubbing: allowScrubbing ?? true,
        padding: padding ?? const EdgeInsets.only(top: 24),
      ),
    );
  }
}

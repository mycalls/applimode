import 'package:applimode_app/src/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoLeftDuration extends StatelessWidget {
  const VideoLeftDuration({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 8),
        child: Text(
          Format.durationToString(
              controller.value.duration - controller.value.position),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

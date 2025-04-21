import 'package:applimode_app/src/features/video_player/post_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullVideoScreen extends StatelessWidget {
  const FullVideoScreen({
    super.key,
    required this.videoUrl,
    this.videoController,
    this.position,
  });

  final String videoUrl;
  final VideoPlayerController? videoController;
  final Duration? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: PostVideoPlayer(
          videoUrl: videoUrl,
          videoController: videoController,
          isFullScreen: true,
          position: position,
          disposeController: videoController != null ? false : true,
        ),
      ),
    );
  }
}

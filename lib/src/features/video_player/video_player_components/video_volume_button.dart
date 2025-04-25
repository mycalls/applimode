import 'package:applimode_app/src/utils/posts_item_mute_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoVolumeButton extends ConsumerWidget {
  const VideoVolumeButton({
    super.key,
    required this.controller,
    this.alignment,
    this.color,
    this.size,
    this.padding,
    this.isAutoPlay = false,
  });

  final VideoPlayerController controller;
  final Alignment? alignment;
  final Color? color;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final bool isAutoPlay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: alignment ?? Alignment.topRight,
      child: Padding(
        padding: padding ?? const EdgeInsets.only(top: 8, right: 8),
        child: IconButton(
          onPressed: () {
            if (controller.value.volume == 0.0) {
              controller.setVolume(1.0);
              ref.read(postsItemMuteStateProvider.notifier).setFalse();
              if (isAutoPlay) {
                controller.play();
              }
            } else {
              controller.setVolume(0.0);
              ref.read(postsItemMuteStateProvider.notifier).setTrue();
              if (isAutoPlay) {
                controller.play();
              }
            }
          },
          icon: Icon(
            controller.value.volume == 0.0
                ? Icons.volume_off_rounded
                : Icons.volume_up_rounded,
            color: color ?? Colors.white,
            size: size,
          ),
        ),
      ),
    );
  }
}

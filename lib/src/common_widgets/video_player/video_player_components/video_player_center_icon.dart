// flutter
import 'package:flutter/material.dart';

class VideoPlayerCenterIcon extends StatelessWidget {
  const VideoPlayerCenterIcon({
    super.key,
    this.iconData,
    this.size,
    this.color,
    this.semanticLabel,
    this.isRound = false,
  });

  final IconData? iconData;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final bool isRound;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: isRound ? const EdgeInsets.only(bottom: 64) : EdgeInsets.zero,
        child: Icon(
          iconData ?? Icons.play_arrow,
          size: isRound ? 64 : size ?? 80,
          color: color ?? Colors.white70,
          semanticLabel: semanticLabel,
        ),
      ),
    );
  }
}

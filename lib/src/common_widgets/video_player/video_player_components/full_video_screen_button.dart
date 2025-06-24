// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

class FullVideoScreenButton extends StatelessWidget {
  const FullVideoScreenButton({
    super.key,
    required this.videoUrl,
    this.isFullScreen = false,
    this.controller,
    this.alignment,
    this.color,
    this.size,
    this.padding,
  });

  final String videoUrl;
  final bool isFullScreen;
  final VideoPlayerController? controller;
  final Alignment? alignment;
  final Color? color;
  final double? size;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.topLeft,
      child: Padding(
        padding: padding ?? const EdgeInsets.only(top: 8, left: 8),
        child: IconButton(
          onPressed: () async {
            if (isFullScreen) {
              if (kIsWeb) {
                WebBackStub().back();
              } else {
                if (context.canPop()) {
                  context.pop();
                }
              }
            } else {
              if (kIsWeb) {
                controller!.pause();
                await context.push(
                  ScreenPaths.fullVideo(videoUrl),
                  extra: {
                    'controller': null,
                    'position': controller?.value.position,
                  },
                );
              } else {
                await context.push(
                  ScreenPaths.fullVideo(videoUrl),
                  extra: {
                    'controller': controller,
                    'position': null,
                  },
                );
              }
            }
          },
          icon: Icon(
            Icons.fullscreen,
            color: color ?? Colors.white,
            size: size,
          ),
        ),
      ),
    );
  }
}

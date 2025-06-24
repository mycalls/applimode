// flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// external
import 'package:url_launcher/url_launcher.dart';

// utils
import 'package:applimode_app/src/utils/string_converter.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';

class YoutubeLinkShot extends StatelessWidget {
  const YoutubeLinkShot(this.youtubeId, {super.key});

  final String youtubeId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final uri =
            Uri.tryParse(StringConverter.buildYtFullEmbedUrl(youtubeId));
        if (uri != null) {
          launchUrl(uri);
        }
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: PlatformNetworkImage(
                imageUrl: StringConverter.buildYtSDThumbnail(youtubeId),
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, sync) {
                  if (frame == null) {
                    return const CupertinoActivityIndicator();
                  }
                  return child;
                },
                progressIndicatorBuilder: (p0, p1, p2) =>
                    const CupertinoActivityIndicator(),
                errorWidget: PlatformNetworkImage(
                  imageUrl: StringConverter.buildYtProxySDThumbnail(youtubeId),
                  fit: BoxFit.cover,
                  frameBuilder: (context, child, frame, sync) {
                    if (frame == null) {
                      return const CupertinoActivityIndicator();
                    }
                    return child;
                  },
                  progressIndicatorBuilder: (p0, p1, p2) =>
                      const CupertinoActivityIndicator(),
                  errorWidget: Container(color: Colors.black),
                ),
              ),
            ),
            const YoutubePlayIcon(),
          ],
        ),
      ),
    );
  }
}

class YoutubePlayIcon extends StatelessWidget {
  const YoutubePlayIcon({super.key, this.width, this.height, this.iconSize});

  final double? width;
  final double? height;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 64,
      height: height ?? 48,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: iconSize ?? 32,
      ),
    );
  }
}

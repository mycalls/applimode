import 'dart:io';

// flutter
import 'package:flutter/material.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/image_widgets/error_image.dart';

class FilePaddingImage extends StatelessWidget {
  const FilePaddingImage({
    super.key,
    required this.file,
    this.hPadding = 0.0,
    this.vPadding = 0.0,
    this.width,
    this.height,
    this.errorHeight = 120.0,
  });

  final File file;
  final double hPadding;
  final double vPadding;
  final double? width;
  final double? height;
  final double errorHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      child: Image.file(
        file,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => ErrorImage(
          hPadding: hPadding,
          vPadding: vPadding,
          height: errorHeight,
        ),
      ),
    );
  }
}

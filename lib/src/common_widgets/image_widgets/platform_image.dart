import 'dart:io';

// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:image_picker/image_picker.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/image_widgets/cached_padding_image.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/file_padding_image.dart';

class FlatformImage extends StatelessWidget {
  const FlatformImage({
    super.key,
    required this.xFile,
    this.hPadding = 12,
    this.vPadding = 12,
    this.width,
    this.height,
    this.errorHeight = 80,
  });

  final XFile xFile;
  final double hPadding;
  final double vPadding;
  final double? width;
  final double? height;
  final double errorHeight;

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? CachedPaddingImage(
            imageUrl: xFile.path,
            hPadding: hPadding,
            vPadding: vPadding,
            width: width,
            height: height,
            errorHeight: errorHeight,
          )
        : FilePaddingImage(
            file: File(xFile.path),
            hPadding: hPadding,
            vPadding: vPadding,
            width: width,
            height: height,
            errorHeight: errorHeight,
          );
  }
}

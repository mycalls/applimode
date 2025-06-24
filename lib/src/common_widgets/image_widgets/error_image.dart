import 'dart:math';

// flutter
import 'package:flutter/material.dart';

// core
import 'package:applimode_app/src/core/constants/color_palettes.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

class ErrorImage extends StatelessWidget {
  const ErrorImage({
    super.key,
    this.height = 120,
    this.hPadding = 0,
    this.vPadding = 0,
  });

  final double height;
  final double hPadding;
  final double vPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      color: pastelColorPalettes[Random().nextInt(pastelColorPalettes.length)],
      child: Center(
        child: Text(
          context.loc.fileError,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

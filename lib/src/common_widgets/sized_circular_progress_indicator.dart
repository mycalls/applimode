// flutter
import 'package:flutter/material.dart';

class SizedCircularProgressIndicator extends StatelessWidget {
  const SizedCircularProgressIndicator({
    super.key,
    this.size = 32.0,
    this.strokeWidth = 2.0,
    this.backgroundColor,
  });

  final double size;
  final double strokeWidth;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator.adaptive(
        strokeWidth: strokeWidth,
        backgroundColor: backgroundColor,
      ),
    );
  }
}

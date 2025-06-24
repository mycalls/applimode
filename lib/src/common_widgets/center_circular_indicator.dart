// flutter
import 'package:flutter/material.dart';

class CenterCircularIndicator extends StatelessWidget {
  const CenterCircularIndicator({
    super.key,
    this.size = 40.0,
    this.strokeWidth = 4.0,
    this.backgroundColor,
  });

  final double size;
  final double strokeWidth;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 28),
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            color: backgroundColor ?? primary,
          ),
        ),
      ),
    );
  }
}

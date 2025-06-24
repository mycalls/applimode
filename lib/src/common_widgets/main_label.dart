// flutter
import 'package:flutter/material.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

class MainLabel extends StatelessWidget {
  const MainLabel({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.containerColor,
    this.labelColor,
    this.horizontalPadidng,
    this.verticalPadding,
    this.textStyle,
  });

  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final Color? containerColor;
  final Color? labelColor;
  final double? horizontalPadidng;
  final double? verticalPadding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadidng ?? 24,
          vertical: verticalPadding ?? 8,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(64)),
          color: containerColor ?? theme.colorScheme.primaryContainer,
        ),
        child: Text(
          context.loc.mainLabel,
          style: textStyle ?? theme.textTheme.titleSmall,
        ),
      ),
    );
  }
}

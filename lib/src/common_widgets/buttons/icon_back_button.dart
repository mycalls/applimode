// flutter
import 'package:flutter/material.dart';

// external
import 'package:go_router/go_router.dart';

class IconBackButton extends StatelessWidget {
  const IconBackButton({
    super.key,
    this.isChevron = false,
    this.iconSize = 24.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.color,
  });

  final bool isChevron;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isChevron ? Icons.chevron_left : Icons.close),
      iconSize: iconSize,
      padding: padding,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}

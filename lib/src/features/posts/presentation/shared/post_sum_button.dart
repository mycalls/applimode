// flutter
import 'package:flutter/material.dart';

class PostSumButton extends StatelessWidget {
  const PostSumButton({
    super.key,
    this.iconColor,
    this.iconSize,
    this.useIconButton = true,
  });

  final Color? iconColor;
  final double? iconSize;
  final bool useIconButton;

  @override
  Widget build(BuildContext context) {
    return useIconButton
        ? IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.swap_vert_rounded,
              color: iconColor ?? Theme.of(context).colorScheme.secondary,
              size: iconSize,
            ),
          )
        : InkWell(
            onTap: () {},
            child: Icon(
              Icons.swap_vert_rounded,
              color: iconColor ?? Theme.of(context).colorScheme.secondary,
              size: iconSize,
            ),
          );
  }
}

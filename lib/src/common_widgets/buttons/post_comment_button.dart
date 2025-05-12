import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostCommentButton extends StatelessWidget {
  const PostCommentButton({
    super.key,
    required this.postId,
    this.iconColor,
    this.iconSize,
    this.useIconButton = true,
    this.postWriter,
  });

  final String postId;
  final Color? iconColor;
  final double? iconSize;
  final bool useIconButton;
  final AppUser? postWriter;

  @override
  Widget build(BuildContext context) {
    return useIconButton
        ? IconButton(
            onPressed: () => context.push(ScreenPaths.comments(postId)),
            icon: Icon(
              Icons.chat_bubble_outline_rounded,
              color: iconColor ?? Theme.of(context).colorScheme.secondary,
              size: iconSize,
            ),
          )
        : InkWell(
            onTap: () => context.push(ScreenPaths.comments(postId)),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                color: iconColor ?? Theme.of(context).colorScheme.secondary,
                size: iconSize,
              ),
            ),
          );
  }
}

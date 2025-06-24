// flutter
import 'package:flutter/material.dart';

// external
import 'package:go_router/go_router.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/format.dart';

// features
import 'package:applimode_app/src/features/comments/domain/post_comment.dart';

class PostCommentReplyButton extends StatelessWidget {
  const PostCommentReplyButton({
    super.key,
    required this.comment,
  });

  final PostComment comment;

  @override
  Widget build(BuildContext context) {
    final mainColor = Theme.of(context).colorScheme.secondary;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        InkWell(
          onTap: () => context.push(
            ScreenPaths.replies(
              comment.postId,
              comment.parentCommentId,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 4),
            child: Icon(
              Icons.mode_comment_outlined,
              color: mainColor,
              size: 18,
            ),
          ),
        ),
        InkWell(
          onTap: () => context.push(
            ScreenPaths.replies(
              comment.postId,
              comment.parentCommentId,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 16),
            child: Text(
              Format.formatNumber(context, comment.replyCount),
              style: textTheme.bodyMedium?.copyWith(color: mainColor),
            ),
          ),
        )
      ],
    );
  }
}

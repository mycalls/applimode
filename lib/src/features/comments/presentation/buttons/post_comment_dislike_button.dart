// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/format.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/async_value_widget.dart';

// features
import 'package:applimode_app/src/features/comments/domain/post_comment.dart';
import 'package:applimode_app/src/features/comments/application/user_post_comment_dislike_data_provider.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comment_controller.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';

class PostCommentDislikeButton extends ConsumerWidget {
  const PostCommentDislikeButton({
    super.key,
    required this.comment,
    required this.dislikeCount,
  });

  final PostComment comment;
  final int dislikeCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainColor = Theme.of(context).colorScheme.secondary;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Consumer(
          builder: (context, ref, child) {
            final postCommentController =
                ref.watch(postCommentControllerProvider.notifier);
            final postCommentState = ref.watch(postCommentControllerProvider);

            final user = ref.watch(authStateChangesProvider).value;
            final userCommentDislikes = user != null
                ? ref.watch(userPostCommentDislikeDataProvider(
                    commentId: comment.id, uid: user.uid))
                : AsyncValue.data(null);

            return AsyncValueWidget(
              value: userCommentDislikes,
              data: (commentDislikes) {
                final isDisable = user == null ||
                    commentDislikes == null ||
                    postCommentState.isLoading;
                final isIconEmpty =
                    commentDislikes == null || commentDislikes.isEmpty;

                return InkWell(
                  onTap: isDisable
                      ? null
                      : commentDislikes.isEmpty
                          ? () async {
                              await postCommentController
                                  .increasePostCommentDislike(
                                postId: comment.postId,
                                commentId: comment.id,
                                commentWriterId: comment.uid,
                                postWriterId: comment.postWriterId,
                                parentCommentId: comment.parentCommentId,
                              );
                            }
                          : () async {
                              await postCommentController
                                  .decreasePostCommentDislike(
                                id: commentDislikes.first.id,
                                commentId: comment.id,
                                commentWriterId: comment.uid,
                              );
                            },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 8, left: 2, right: 4),
                    child: Icon(
                      isIconEmpty
                          ? Icons.thumb_down_outlined
                          : Icons.thumb_down,
                      color: mainColor,
                      size: 18,
                    ),
                  ),
                );
              },
            );
          },
        ),
        InkWell(
          onTap: () {
            context.push(ScreenPaths.commentDislikes(comment.id));
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 16),
            child: Text(
              Format.formatNumber(context, dislikeCount),
              style: textTheme.bodyMedium?.copyWith(color: mainColor),
            ),
          ),
        ),
      ],
    );
  }
}

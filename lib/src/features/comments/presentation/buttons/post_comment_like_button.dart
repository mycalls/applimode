import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/comments/application/user_post_comment_like_data_provider.dart';
import 'package:applimode_app/src/features/comments/domain/post_comment.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comment_controller.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostCommentLikeButton extends ConsumerWidget {
  const PostCommentLikeButton({
    super.key,
    required this.comment,
    required this.likeCount,
    this.isHeart = false,
    this.commentWriter,
  });

  final PostComment comment;
  final int likeCount;
  final bool isHeart;
  final AppUser? commentWriter;

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
            final userCommentLikes = user != null
                ? ref.watch(userPostCommentLikeDataProvider(
                    commentId: comment.id, uid: user.uid))
                : AsyncValue.data(null);

            return AsyncValueWidget(
              value: userCommentLikes,
              data: (commentLikes) {
                final isDisable = user == null ||
                    commentLikes == null ||
                    postCommentState.isLoading;
                final isIconEmpty =
                    commentLikes == null || commentLikes.isEmpty;

                return InkWell(
                  onTap: isDisable
                      ? null
                      : commentLikes.isEmpty
                          ? () async {
                              await postCommentController
                                  .increasePostCommentLike(
                                postId: comment.postId,
                                commentId: comment.id,
                                commentWriterId: comment.uid,
                                commentWriter: commentWriter,
                                postWriterId: comment.postWriterId,
                                parentCommentId: comment.parentCommentId,
                                commentLikeNotiString:
                                    context.loc.commentLikeNoti,
                              );
                            }
                          : () async {
                              await postCommentController
                                  .decreasePostCommentLike(
                                id: commentLikes.first.id,
                                commentId: comment.id,
                                commentWriterId: comment.uid,
                              );
                            },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 8, left: 2, right: 4),
                    child: Icon(
                      isIconEmpty
                          ? isHeart
                              ? Icons.favorite_outline_rounded
                              : Icons.thumb_up_outlined
                          : isHeart
                              ? Icons.favorite_rounded
                              : Icons.thumb_up,
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
            context.push(ScreenPaths.commentLikes(comment.id));
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 16),
            child: Text(
              Format.formatNumber(context, likeCount),
              style: textTheme.bodyMedium?.copyWith(color: mainColor),
            ),
          ),
        ),
      ],
    );
  }
}

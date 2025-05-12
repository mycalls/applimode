import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/comments/domain/post_comment.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comment_controller.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCommentDeleteButton extends ConsumerWidget {
  const PostCommentDeleteButton({
    super.key,
    required this.comment,
    required this.writerId,
    this.parentCommentId,
  });

  final PostComment comment;
  final String writerId;
  final String? parentCommentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final appUser = user != null
        ? ref.watch(appUserDataProvider(user.uid))
        : const AsyncData(null);

    final postCommentState = ref.watch(postCommentControllerProvider);

    return appUser.when(
      data: (appUser) {
        if (appUser == null ||
            (user != null && user.uid != writerId && !appUser.isAdmin)) {
          return const SizedBox.shrink();
        }
        return InkWell(
          onTap: postCommentState.isLoading
              ? null
              : () async {
                  await ref
                      .read(postCommentControllerProvider.notifier)
                      .deleteComment(
                        id: comment.id,
                        parentCommentId: comment.parentCommentId,
                        postId: comment.postId,
                        isReply: parentCommentId != null,
                        commentWriterId: comment.uid,
                        isAdmin: appUser.isAdmin,
                        imageUrl: comment.imageUrl,
                      );
                },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 4),
            child: Icon(
              Icons.delete_outline_rounded,
              color: Theme.of(context).colorScheme.secondary,
              size: 20,
            ),
          ),
        );
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}

class PostCommentDelteTextButton extends ConsumerWidget {
  const PostCommentDelteTextButton({
    super.key,
    required this.comment,
    required this.writerId,
    this.parentCommentId,
  });

  final PostComment comment;
  final String writerId;
  final String? parentCommentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final appUser = user != null
        ? ref.watch(appUserDataProvider(user.uid))
        : const AsyncData(null);

    final postCommentState = ref.watch(postCommentControllerProvider);

    return AsyncValueWidget(
      value: appUser,
      data: (appUser) {
        if (appUser == null ||
            (user != null && user.uid != writerId && !appUser.isAdmin)) {
          return const SizedBox.shrink();
        }
        return InkWell(
            onTap: postCommentState.isLoading
                ? null
                : () async {
                    await ref
                        .read(postCommentControllerProvider.notifier)
                        .deleteComment(
                          id: comment.id,
                          parentCommentId: comment.parentCommentId,
                          postId: comment.postId,
                          isReply: parentCommentId != null,
                          commentWriterId: comment.uid,
                          isAdmin: appUser.isAdmin,
                          imageUrl: comment.imageUrl,
                        );
                  },
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                context.loc.deleteComment,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ));
      },
    );
  }
}

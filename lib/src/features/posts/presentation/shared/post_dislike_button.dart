// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/async_value_widget.dart';

// features
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/application/providers/user_post_dislike_data_provider.dart';
import 'package:applimode_app/src/features/posts/presentation/post_screen/post_likes_controller.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';

class PostDislikeButton extends ConsumerWidget {
  const PostDislikeButton({
    super.key,
    required this.post,
    this.iconColor,
    this.iconSize,
    this.useIconButton = true,
  });

  final Post post;
  final Color? iconColor;
  final double? iconSize;
  final bool useIconButton;

  Widget _buildIcon(BuildContext context, bool isIconEmpty) {
    return Icon(
      isIconEmpty ? Icons.thumb_down_alt_outlined : Icons.thumb_down,
      color: iconColor ?? Theme.of(context).colorScheme.secondary,
      size: iconSize,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postLikesController = ref.watch(postLikesControllerProvider.notifier);
    final postLikesState = ref.watch(postLikesControllerProvider);

    final user = ref.watch(authStateChangesProvider).value;
    final userPostDislikes = user != null
        ? ref.watch(userPostDislikeDataProvider(postId: post.id, uid: user.uid))
        : AsyncValue.data(null);

    return AsyncValueWidget(
      value: userPostDislikes,
      data: (postDislikes) {
        final isDisable =
            user == null || postDislikes == null || postLikesState.isLoading;
        final isIconEmpty = postDislikes == null || postDislikes.isEmpty;

        return useIconButton
            ? IconButton(
                onPressed: isDisable
                    ? null
                    : postDislikes.isEmpty
                        ? () => postLikesController.increasePostDislikeCount(
                              postId: post.id,
                              postWriterId: post.uid,
                            )
                        : () => postLikesController.decreasePostDislikeCount(
                              id: postDislikes.first.id,
                              postId: post.id,
                              postWriterId: post.uid,
                            ),
                icon: _buildIcon(context, isIconEmpty),
              )
            : InkWell(
                onTap: isDisable
                    ? null
                    : postDislikes.isEmpty
                        ? () => postLikesController.increasePostDislikeCount(
                              postId: post.id,
                              postWriterId: post.uid,
                            )
                        : () => postLikesController.decreasePostDislikeCount(
                              id: postDislikes.first.id,
                              postId: post.id,
                              postWriterId: post.uid,
                            ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: _buildIcon(context, isIconEmpty),
                ),
              );
      },
    );
  }
}

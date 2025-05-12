import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/post/presentation/post_likes_controller.dart';
import 'package:applimode_app/src/features/posts/application/user_post_like_data_provider.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

class PostLikeButton extends ConsumerWidget {
  const PostLikeButton({
    super.key,
    required this.post,
    this.isHeart = false,
    this.iconColor,
    this.iconSize,
    this.useIconButton = true,
    this.postWriter,
  });

  final Post post;
  final bool isHeart;
  final Color? iconColor;
  final double? iconSize;
  final bool useIconButton;
  final AppUser? postWriter;

  Widget _buildIcon(BuildContext context, bool isIconEmpty) {
    return Icon(
      isIconEmpty
          ? isHeart
              ? Icons.favorite_outline_rounded
              : Icons.thumb_up_alt_outlined
          : isHeart
              ? Icons.favorite_rounded
              : Icons.thumb_up,
      color: iconColor ?? Theme.of(context).colorScheme.secondary,
      size: iconSize,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postLikesController = ref.watch(postLikesControllerProvider.notifier);
    final postLikesState = ref.watch(postLikesControllerProvider);

    final user = ref.watch(authStateChangesProvider).value;
    final userPostLikes = user != null
        ? ref.watch(userPostLikeDataProvider(postId: post.id, uid: user.uid))
        : AsyncValue.data(null);

    return AsyncValueWidget(
      value: userPostLikes,
      data: (postLikes) {
        final isDisable =
            user == null || postLikes == null || postLikesState.isLoading;
        final isIconEmpty = postLikes == null || postLikes.isEmpty;

        return useIconButton
            ? IconButton(
                onPressed: isDisable
                    ? null
                    : postLikes.isEmpty
                        ? () => postLikesController.increasePostLikeCount(
                              postId: post.id,
                              postWriterId: post.uid,
                              postWriter: postWriter,
                              postLikeNotiString: context.loc.postLikeNoti,
                            )
                        : () => postLikesController.decreasePostLikeCount(
                              id: postLikes.first.id,
                              postId: post.id,
                              postWriterId: post.uid,
                            ),
                icon: _buildIcon(context, isIconEmpty),
              )
            : InkWell(
                onTap: isDisable
                    ? null
                    : postLikes.isEmpty
                        ? () => postLikesController.increasePostLikeCount(
                              postId: post.id,
                              postWriterId: post.uid,
                              postWriter: postWriter,
                              postLikeNotiString: context.loc.postLikeNoti,
                            )
                        : () => postLikesController.decreasePostLikeCount(
                              id: postLikes.first.id,
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

// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/exceptions/app_exception.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/adaptive_back.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/format.dart';

// features
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/post_screen/post_likes_controller.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/post_comment_button.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/post_dislike_button.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/post_like_button.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/post_sum_button.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';

class PostScreenBottomBar extends ConsumerWidget {
  const PostScreenBottomBar({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final mainColor = colorScheme.secondary;
    final countTextStyle = textTheme.bodyMedium?.copyWith(color: mainColor);
    final isIosWeb = kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    final adminSettings = ref.watch(adminSettingsProvider);
    final writer = ref.watch(appUserDataProvider(post.uid)).value;

    ref.listen(postLikesControllerProvider, (_, state) {
      if (state.error is NeedLogInException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.needLogin);
      } else if (state.error is PageNotFoundException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.pageNotFound);
        adaptiveBack(context);
      } else {
        state.showAlertDialogOnError(context, content: state.error.toString());
      }
    });

    return InkWell(
      onTap: () {
        if (adminSettings.showCommentCount) {
          context.push(
            ScreenPaths.comments(post.id),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
          bottom: isIosWeb ? iosWebBottomSafeArea : 8,
        ),
        color: colorScheme.onInverseSurface,
        // height: 96,
        child: SafeArea(
          child: Row(
            children: [
              if (adminSettings.showLikeCount) ...[
                PostLikeButton(
                  post: post,
                  isHeart: adminSettings.isThumbUpToHeart,
                  postWriter: writer,
                  iconSize: postScreenBottomBarIconSize,
                ),
                InkWell(
                  onTap: () => context.push(ScreenPaths.postLikes(post.id)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 16),
                    child: Text(
                      Format.formatNumber(context, post.likeCount),
                      style: countTextStyle,
                    ),
                  ),
                ),
              ],
              if (adminSettings.showDislikeCount) ...[
                PostDislikeButton(
                  post: post,
                  iconSize: postScreenBottomBarIconSize,
                ),
                InkWell(
                  onTap: () => context.push(ScreenPaths.postDislikes(post.id)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 16),
                    child: Text(
                      Format.formatNumber(context, post.dislikeCount),
                      style: countTextStyle,
                    ),
                  ),
                ),
              ],
              if (adminSettings.showSumCount) ...[
                const PostSumButton(
                  iconSize: postScreenBottomBarIconSize,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2, right: 16),
                  child: Text(
                    Format.formatNumber(context, post.sumCount),
                    style: countTextStyle,
                  ),
                ),
              ],
              if (adminSettings.showCommentCount) ...[
                PostCommentButton(
                  postId: post.id,
                  postWriter: writer,
                  iconSize: postScreenBottomBarIconSize,
                ),
                InkWell(
                  onTap: () => context.push(
                    ScreenPaths.comments(post.id),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 16),
                    child: Text(
                      Format.formatNumber(context, post.postCommentCount),
                      style: countTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Text(
                      context.loc.leaveComment,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelLarge?.copyWith(color: mainColor),
                    ),
                  ),
                ),
                Icon(
                  Icons.unfold_more_outlined,
                  color: mainColor,
                  size: postScreenBottomBarIconSize,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

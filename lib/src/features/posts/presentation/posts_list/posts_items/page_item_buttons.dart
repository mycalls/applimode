// lib/src/features/posts/presentation/posts_list/posts_items/page_item_buttons.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/exceptions/app_exception.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/common_widgets/buttons/post_comment_button.dart';
import 'package:applimode_app/src/common_widgets/buttons/post_dislike_button.dart';
import 'package:applimode_app/src/common_widgets/buttons/post_like_button.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/post/presentation/post_likes_controller.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';

// English: A widget that displays a column of action buttons (like, dislike, comment)
// and their counts, typically used in a page-style layout for a post.
// Korean: 게시물에 대한 페이지 스타일 레이아웃에서 일반적으로 사용되는 액션 버튼(좋아요, 싫어요, 댓글)과
// 해당 개수를 세로로 표시하는 위젯입니다.
class PageItemButtons extends ConsumerWidget {
  const PageItemButtons({
    super.key,
    required this.post,
  });

  // English: The post data for which the buttons are displayed.
  // Korean: 버튼이 표시될 게시물 데이터입니다.
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // English: Listen to the state of the postLikesControllerProvider to handle errors
    // that might occur during like/dislike operations (e.g., user not logged in).
    // Korean: 좋아요/싫어요 작업 중 발생할 수 있는 오류(예: 사용자가 로그인하지 않음)를 처리하기 위해
    // postLikesControllerProvider의 상태를 수신합니다.
    ref.listen(postLikesControllerProvider, (_, state) {
      if (state.error is NeedLogInException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.needLogin);
      } else if (state.error is PageNotFoundException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.pageNotFound);
      } else {
        state.showAlertDialogOnError(context, content: state.error.toString());
      }
    });

    // English: Fetch admin settings to determine which buttons/counts to display.
    // Korean: 어떤 버튼/개수를 표시할지 결정하기 위해 관리자 설정을 가져옵니다.
    final adminSettings = ref.watch(adminSettingsProvider);
    return Column(
      children: [
        // English: Display the like button and count if enabled in admin settings.
        // Korean: 관리자 설정에서 활성화된 경우 좋아요 버튼과 개수를 표시합니다.
        if (adminSettings.showLikeCount) ...[
          PostLikeButton(
            post: post,
            isHeart: adminSettings.isThumbUpToHeart,
            iconColor: const Color(basicPostsItemButtonColor),
            iconSize: basicPostsItemButtonSize,
            useIconButton: false,
          ),
          const SizedBox(height: 4),
          InkWell(
            // English: Navigate to the screen showing users who liked the post.
            // Korean: 게시물을 좋아한 사용자 목록 화면으로 이동합니다.
            onTap: () => context.push(ScreenPaths.postLikes(post.id)),
            child: Text(
              Format.formatNumber(context, post.likeCount),
              style: const TextStyle(
                fontSize: basicPostsItemButtonFontSize,
                color: Color(basicPostsItemButtonColor),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        // English: Display the dislike button and count if enabled and in portrait mode.
        // Korean: 관리자 설정에서 활성화되어 있고 세로 모드인 경우 싫어요 버튼과 개수를 표시합니다.
        // (Dislike button might be hidden in landscape to save space or due to design choice)
        if (adminSettings.showDislikeCount &&
            MediaQuery.orientationOf(context) == Orientation.portrait) ...[
          PostDislikeButton(
            post: post,
            iconColor: const Color(basicPostsItemButtonColor),
            iconSize: basicPostsItemButtonSize,
            useIconButton: false,
          ),
          const SizedBox(height: 4),
          InkWell(
            // English: Navigate to the screen showing users who disliked the post.
            // Korean: 게시물을 싫어한 사용자 목록 화면으로 이동합니다.
            onTap: () => context.push(ScreenPaths.postDislikes(post.id)),
            child: Text(
              Format.formatNumber(context, post.dislikeCount),
              style: const TextStyle(
                fontSize: basicPostsItemButtonFontSize,
                color: Color(basicPostsItemButtonColor),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        // English: Display the comment button and count if enabled in admin settings.
        // Korean: 관리자 설정에서 활성화된 경우 댓글 버튼과 개수를 표시합니다.
        if (adminSettings.showCommentCount) ...[
          PostCommentButton(
            postId: post.id,
            iconColor: const Color(basicPostsItemButtonColor),
            iconSize: basicPostsItemButtonSize,
            useIconButton: false,
          ),
          const SizedBox(height: 4),
          InkWell(
            // English: Navigate to the comments screen for the post.
            // Korean: 게시물의 댓글 화면으로 이동합니다.
            onTap: () => context.push(
              ScreenPaths.comments(post.id),
            ),
            child: Text(
              Format.formatNumber(context, post.postCommentCount),
              style: const TextStyle(
                fontSize: basicPostsItemButtonFontSize,
                color: Color(basicPostsItemButtonColor),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

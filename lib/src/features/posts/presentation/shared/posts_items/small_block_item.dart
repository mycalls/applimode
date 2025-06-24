// lib/src/features/posts/presentation/posts_list/posts_items/small_block_item.dart

// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// core
import 'package:applimode_app/custom_settings.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/title_text_widget.dart';

// features
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';

// English: A widget to display a compact placeholder for a blocked post,
// suitable for list views. It shows a "Blocked Post" message and allows
// admins to tap to view the actual post.
// Korean: 목록 뷰에 적합한, 차단된 게시물에 대한 간결한 플레이스홀더를 표시하는 위젯입니다.
// "차단된 게시물" 메시지를 보여주고 관리자가 탭하여 실제 게시물을 볼 수 있도록 합니다.
class SmallBlockItem extends ConsumerWidget {
  const SmallBlockItem({
    super.key,
    this.postId,
    this.post,
  });

  // English: The ID of the blocked post. Used for navigation if the current user is an admin.
  // Korean: 차단된 게시물의 ID입니다. 현재 사용자가 관리자인 경우 내비게이션에 사용됩니다.
  final String? postId;
  // English: The Post object. Passed as an extra to the post screen if the current user is an admin.
  // Korean: Post 객체입니다. 현재 사용자가 관리자인 경우 게시물 화면으로 extra로 전달됩니다.
  final Post? post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // English: Get the current authenticated user.
    // Korean: 현재 인증된 사용자를 가져옵니다.
    final user = ref.watch(authStateChangesProvider).value;
    // English: Get the app-specific user data, which includes admin status.
    // Korean: 관리자 상태를 포함하는 앱별 사용자 데이터를 가져옵니다.
    final appUser =
        user != null ? ref.watch(appUserDataProvider(user.uid)).value : null;
    final titleTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: smallPostsItemTitleSize,
        );

    // English: Calculate horizontal padding based on screen width.
    // This ensures content is centered or appropriately padded on different screen sizes.
    // Korean: 화면 너비에 따라 수평 패딩을 계산합니다.
    // 이를 통해 다양한 화면 크기에서 콘텐츠가 중앙에 정렬되거나 적절하게 패딩됩니다.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth > pcWidthBreakpoint
        ? ((screenWidth - pcWidthBreakpoint) / 2) + defaultHorizontalPadding
        : defaultHorizontalPadding;

    return InkWell(
      // English: Enable tap functionality only if the user is an admin and post data is available.
      // Korean: 사용자가 관리자이고 게시물 데이터를 사용할 수 있는 경우에만 탭 기능을 활성화합니다.
      onTap:
          (appUser != null && appUser.isAdmin && postId != null && post != null)
              ? () => context.push(
                    ScreenPaths.post(postId!),
                    extra: post,
                  )
              : null,
      child: Column(
        children: [
          SizedBox(
            // English: Fixed height for the small list item, consistent with SmallPostsItem.
            // Korean: SmallPostsItem과 일관되게 작은 목록 항목의 고정 높이입니다.
            height: listSmallItemHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      // English: Display the "Blocked Post" message.
                      // Korean: "차단된 게시물" 메시지를 표시합니다.
                      child: TitleTextWidget(
                        title: context.loc.blockedPost,
                        textStyle: titleTextStyle,
                        maxLines: smallPostsItemTitleMaxLines,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            // English: A thin divider at the bottom of the item, visually separating it from the next item in a list.
            // Korean: 목록에서 다음 항목과 시각적으로 구분하는 항목 하단의 얇은 구분선입니다.
            height: 0,
            thickness: 0,
            indent: horizontalPadding,
            endIndent: horizontalPadding,
          ),
        ],
      ),
    );
  }
}

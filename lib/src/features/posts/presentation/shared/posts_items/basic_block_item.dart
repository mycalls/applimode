// lib/src/features/posts/presentation/posts_list/posts_items/basic_block_item.dart

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
import 'package:applimode_app/src/common_widgets/gradient_color_box.dart';
import 'package:applimode_app/src/common_widgets/title_text_widget.dart';

// features
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';

// English: A widget to display a placeholder for a blocked post in a basic item layout.
// It shows a "Blocked Post" message and allows admins to tap to view the actual post.
// Korean: 기본 아이템 레이아웃에서 차단된 게시물에 대한 플레이스홀더를 표시하는 위젯입니다.
// "차단된 게시물" 메시지를 보여주고 관리자가 탭하여 실제 게시물을 볼 수 있도록 합니다.
class BasicBlockItem extends ConsumerWidget {
  const BasicBlockItem({
    super.key,
    this.aspectRatio,
    this.isPage = false,
    this.index,
    this.postId,
    this.post,
  });

  // English: The aspect ratio for the item. Defaults to 1.0 (square).
  // Korean: 아이템의 종횡비입니다. 기본값은 1.0 (정사각형)입니다.
  final double? aspectRatio;
  // English: Flag to indicate if the item is displayed in a page-like view. Affects bottom padding.
  // Korean: 아이템이 페이지 형식 뷰에 표시되는지 여부를 나타내는 플래그입니다. 하단 패딩에 영향을 줍니다.
  final bool isPage;
  // English: Optional index, can be used by GradientColorBox for varied styling.
  // Korean: 선택적 인덱스로, GradientColorBox에서 다양한 스타일링을 위해 사용될 수 있습니다.
  final int? index;
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
    final postTitleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontSize: basicPostsItemTitleFontsize,
        );
    final screenWidth = MediaQuery.sizeOf(context).width;

    return InkWell(
      // English: Allow navigation only if the user is an admin and post details are available.
      // Korean: 사용자가 관리자이고 게시물 세부 정보를 사용할 수 있는 경우에만 내비게이션을 허용합니다.
      onTap:
          (appUser != null && appUser.isAdmin && postId != null && post != null)
              // English: Navigate to the post screen, passing the post object.
              // Korean: 게시물 객체를 전달하여 게시물 화면으로 이동합니다.
              ? () => context.push(
                    ScreenPaths.post(postId!),
                    extra: post,
                  )
              : null,
      child: Column(
        children: [
          AspectRatio(
            // English: Use the provided aspectRatio or default to 1.0.
            // Korean: 제공된 aspectRatio를 사용하거나 기본값 1.0을 사용합니다.
            aspectRatio: aspectRatio ?? 1.0,
            child: GradientColorBox(
              // English: Pass the index to GradientColorBox for potential color variations.
              // Korean: 잠재적인 색상 변화를 위해 GradientColorBox에 인덱스를 전달합니다.
              index: index,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: SafeArea(
                  // English: Ensure title text is not obscured by system UI elements like notches.
                  // Korean: 제목 텍스트가 노치와 같은 시스템 UI 요소에 의해 가려지지 않도록 합니다.
                  top: false,
                  bottom: false,
                  // English: Display "Blocked Post" message.
                  // Korean: "차단된 게시물" 메시지를 표시합니다.
                  child: TitleTextWidget(
                    title: context.loc.blockedPost,
                    textStyle: postTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          // English: Add bottom padding if not in page view and on smaller screens.
          // Korean: 페이지 뷰가 아니고 작은 화면인 경우 하단 패딩을 추가합니다.
          if (!isPage && screenWidth <= pcWidthBreakpoint)
            const SizedBox(height: cardBottomPadding),
        ],
      ),
    );
  }
}

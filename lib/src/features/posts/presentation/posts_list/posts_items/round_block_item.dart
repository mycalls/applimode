// lib/src/features/posts/presentation/posts_list/posts_items/round_block_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/common_widgets/gradient_color_box.dart';
import 'package:applimode_app/src/common_widgets/title_text_widget.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';

// English: A widget to display a placeholder for a blocked post with rounded corners,
// suitable for card-style layouts. It shows a "Blocked Post" message and allows
// admins to tap to view the actual post.
// Korean: 둥근 모서리를 가진 차단된 게시물에 대한 플레이스홀더를 표시하는 위젯으로,
// 카드 스타일 레이아웃에 적합합니다. "차단된 게시물" 메시지를 보여주고 관리자가
// 탭하여 실제 게시물을 볼 수 있도록 합니다.
class RoundBlockItem extends ConsumerWidget {
  const RoundBlockItem({
    super.key,
    this.aspectRatio,
    this.index,
    this.postId,
    this.post,
    this.needTopMargin = false,
    this.needBottomMargin = true,
  });

  // English: The aspect ratio for the item. Defaults to 16/9.
  // Korean: 아이템의 종횡비입니다. 기본값은 16/9입니다.
  final double? aspectRatio;
  // English: Optional index, can be used by GradientColorBox for varied styling.
  // Korean: 선택적 인덱스로, GradientColorBox에서 다양한 스타일링을 위해 사용될 수 있습니다.
  final int? index;
  // English: The ID of the blocked post. Used for navigation if the current user is an admin.
  // Korean: 차단된 게시물의 ID입니다. 현재 사용자가 관리자인 경우 내비게이션에 사용됩니다.
  final String? postId;
  // English: The Post object. Passed as an extra to the post screen if the current user is an admin.
  // Korean: Post 객체입니다. 현재 사용자가 관리자인 경우 게시물 화면으로 extra로 전달됩니다.
  final Post? post;
  // English: Flag to determine if top margin (padding) should be applied to the card.
  // Korean: 카드 상단에 여백(패딩)을 적용할지 여부를 결정하는 플래그입니다.
  final bool needTopMargin;
  // English: Flag to determine if bottom margin (padding) should be applied to the card.
  // Korean: 카드 하단에 여백(패딩)을 적용할지 여부를 결정하는 플래그입니다.
  final bool needBottomMargin;

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
          fontSize: roundPostsItemTitleFontsize,
        );

    // English: Calculate horizontal margin to center the card on wider screens or apply standard padding.
    // Korean: 넓은 화면에서 카드를 중앙에 배치하거나 표준 패딩을 적용하기 위해 수평 여백을 계산합니다.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalMargin = screenWidth > pcWidthBreakpoint
        ? ((screenWidth - pcWidthBreakpoint) / 2) + roundCardPadding
        : roundCardPadding;

    return InkWell(
      // English: Allow navigation only if the user is an admin and post details are available.
      // Korean: 사용자가 관리자이고 게시물 세부 정보를 사용할 수 있는 경우에만 내비게이션을 허용합니다.
      onTap:
          (appUser != null && appUser.isAdmin && postId != null && post != null)
              ? () => context.push(
                    ScreenPaths.post(postId!),
                    extra: post,
                  )
              : null,
      // English: Container for applying margins, rounded corners, and clipping.
      // Korean: 여백, 둥근 모서리 및 클리핑을 적용하기 위한 컨테이너입니다.
      child: Container(
        margin: EdgeInsets.only(
          left: horizontalMargin,
          right: horizontalMargin,
          top: needTopMargin ? roundCardPadding : 0,
          bottom: needBottomMargin ? roundCardPadding : 0,
        ),
        // English: Defines the rounded rectangle shape.
        // Korean: 둥근 사각형 모양을 정의합니다.
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(24),
          ),
        ),
        // English: Ensures content is clipped to the rounded corners.
        // Korean: 콘텐츠가 둥근 모서리에 맞게 잘리도록 합니다.
        clipBehavior: Clip.hardEdge,
        child: AspectRatio(
          // English: Use the provided aspectRatio or default to 16/9.
          // Korean: 제공된 aspectRatio를 사용하거나 기본값 16/9를 사용합니다.
          aspectRatio: aspectRatio ?? 16 / 9,
          child: GradientColorBox(
            // English: Pass the index to GradientColorBox for potential color variations.
            // Korean: 잠재적인 색상 변화를 위해 GradientColorBox에 인덱스를 전달합니다.
            index: index,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              // English: Display "Blocked Post" message, centered.
              // Korean: "차단된 게시물" 메시지를 중앙에 표시합니다.
              child: TitleTextWidget(
                title: context.loc.blockedPost,
                textStyle: postTitleStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

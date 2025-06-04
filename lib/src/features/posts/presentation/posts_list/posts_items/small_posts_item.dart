// lib/src/features/posts/presentation/posts_list/posts_items/small_posts_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/common_widgets/responsive_widget.dart';
import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/cached_border_image.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_block_item.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_posts_item_contents.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';

// English: A widget to display a small, compact version of a post item.
// Typically used in lists, search results, or ranking pages.
// Korean: 게시물 항목의 작고 간결한 버전을 표시하는 위젯입니다.
// 일반적으로 목록, 검색 결과 또는 랭킹 페이지에 사용됩니다.
class SmallPostsItem extends ConsumerWidget {
  const SmallPostsItem({
    super.key,
    required this.post,
    this.index,
    // English: Flags to indicate if the item is part of a ranking page and the type of ranking.
    // Korean: 항목이 랭킹 페이지의 일부인지 그리고 랭킹 유형을 나타내는 플래그입니다.
    this.isRankingPage = false,
    this.isLikeRanking = false,
    this.isDislikeRanking = false,
    this.isSumRanking = false,
  });

  // English: The post data to display.
  // Korean: 표시할 게시물 데이터입니다.
  final Post post;
  // English: Optional index of the item, can be used for styling or unique identification.
  // Korean: 항목의 선택적 인덱스로, 스타일링이나 고유 식별에 사용될 수 있습니다.
  final int? index;
  // English: True if this item is displayed on a ranking page.
  // Korean: 이 항목이 랭킹 페이지에 표시되면 true입니다.
  final bool isRankingPage;
  // English: True if this item is part of a like-based ranking.
  // Korean: 이 항목이 좋아요 기반 랭킹의 일부이면 true입니다.
  final bool isLikeRanking;
  // English: True if this item is part of a dislike-based ranking.
  // Korean: 이 항목이 싫어요 기반 랭킹의 일부이면 true입니다.
  final bool isDislikeRanking;
  // English: True if this item is part of a sum-based (likes - dislikes) ranking.
  // Korean: 이 항목이 합계(좋아요 - 싫어요) 기반 랭킹의 일부이면 true입니다.
  final bool isSumRanking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // English: If the post is marked as deleted, display a SmallBlockItem.
    // Korean: 게시물이 삭제된 것으로 표시되면 SmallBlockItem을 표시합니다.
    if (post.id == deleted) {
      return const ResponsiveCenter(
        maxContentWidth: pcWidthBreakpoint,
        padding: EdgeInsets.zero,
        // English: Show a placeholder for deleted items.
        // Korean: 삭제된 항목에 대한 플레이스홀더를 표시합니다.
        child: SmallBlockItem(),
      );
    }

    // English: Fetch writer data asynchronously.
    // Korean: 작성자 데이터를 비동기적으로 가져옵니다.
    final writerAsync = ref.watch(appUserDataProvider(post.uid));
    // English: Determine the media URL, preferring mainImageUrl, then mainVideoImageUrl.
    // Korean: 기본 이미지 URL을 우선으로 하고, 그 다음 비디오 이미지 URL을 사용하여 미디어 URL을 결정합니다.
    final mainMediaUrl = post.mainImageUrl ?? post.mainVideoImageUrl;

    final screenWidth = MediaQuery.sizeOf(context).width;
    // English: Calculate horizontal padding based on screen width to center content on larger screens.
    // Korean: 넓은 화면에서 콘텐츠를 중앙에 배치하기 위해 화면 너비에 따라 수평 패딩을 계산합니다.
    final horizontalPadding = screenWidth > pcWidthBreakpoint
        ? ((screenWidth - pcWidthBreakpoint) / 2) + defaultHorizontalPadding
        : defaultHorizontalPadding;

    return AsyncValueWidget(
      value: writerAsync,
      data: (writer) {
        // English: This log can be useful for debugging build cycles.
        // Korean: 이 로그는 빌드 주기를 디버깅하는 데 유용할 수 있습니다.
        // debugPrint('SmallPostsItem build $index');
        /*
        if (writer == null) {
          return const SmallBlockItem();
        }
        */
        final isBlock = (writer != null && writer.isBlock) || post.isBlock;
        // English: If the writer or post is blocked, display a SmallBlockItem.
        // Korean: 작성자 또는 게시물이 차단된 경우 SmallBlockItem을 표시합니다.
        if (isBlock) {
          return SmallBlockItem(
            postId: post.id,
            post: post,
          );
        }
        // English: Main tappable area for the post item.
        // Korean: 게시물 항목의 기본 탭 가능 영역입니다.
        return InkWell(
          onTap: () {
            // English: Navigate to the full post screen when tapped.
            // Korean: 탭하면 전체 게시물 화면으로 이동합니다.
            context.push(
              // English: Uses the screen path defined in AppRouter.
              // Korean: AppRouter에 정의된 화면 경로를 사용합니다.
              ScreenPaths.post(post.id),
              extra: post,
            );
          },
          child: Column(
            children: [
              SizedBox(
                // English: Fixed height for the small list item.
                // Korean: 작은 목록 항목의 고정 높이입니다.
                height: listSmallItemHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Center(
                    child: Row(
                      children: [
                        // English: Display an image if a media URL is available.
                        // Korean: 미디어 URL을 사용할 수 있는 경우 이미지를 표시합니다.
                        if (mainMediaUrl != null &&
                            mainMediaUrl.isNotEmpty) ...[
                          CachedBorderImage(
                            imgUrl: mainMediaUrl,
                            // English: Pass index, potentially for Hero animations or unique identification.
                            // Korean: Hero 애니메이션이나 고유 식별을 위해 인덱스를 전달합니다.
                            index: index,
                          ),
                          // English: Spacing between the image and the content.
                          // Korean: 이미지와 콘텐츠 사이의 간격입니다.
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: SmallPostsItemContents(
                            post: post,
                            isRankingPage: isRankingPage,
                            isLikeRanking: isLikeRanking,
                            isDislikeRanking: isDislikeRanking,
                            isSumRanking: isSumRanking,
                            index: index,
                            // English: SmallPostsItemContents handles the display of text, title, writer, etc.
                            // Korean: SmallPostsItemContents는 텍스트, 제목, 작성자 등의 표시를 처리합니다.
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                // English: A thin divider at the bottom of the item.
                // Korean: 항목 하단의 얇은 구분선입니다.
                height: 0,
                thickness: 0,
                indent: horizontalPadding,
                endIndent: horizontalPadding,
              ),
              // 너무 진할 경우 사용
              // English: Commented out alternative divider style. Korean: 주석 처리된 대체 구분선 스타일입니다.
              /*
          Divider(
            height: 0,
            thickness: 0,
            indent: 24,
            endIndent: 24,
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          )
          */
            ],
          ),
        );
      },
      // English: Loading widget to maintain item height and prevent layout shifts.
      // Korean: 항목 높이를 유지하고 레이아웃 이동을 방지하는 로딩 위젯입니다.
      loadingWidget: const SizedBox(height: listSmallItemHeight),
    );
  }
}

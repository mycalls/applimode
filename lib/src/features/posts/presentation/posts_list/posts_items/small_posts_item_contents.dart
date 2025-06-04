// lib/src/features/posts/presentation/posts_list/posts_items/small_posts_item_contents.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/common_widgets/title_text_widget.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/post_sub_info_one_line.dart';

// English: A widget that displays the main textual content for a SmallPostsItem,
// including the title and a line of sub-information. It adapts for ranking displays.
// Korean: SmallPostsItem의 주요 텍스트 내용(제목 및 하위 정보 한 줄)을 표시하는 위젯입니다.
// 랭킹 표시에 맞게 조정됩니다.
class SmallPostsItemContents extends ConsumerWidget {
  const SmallPostsItemContents({
    super.key,
    required this.post,
    // English: Flags to indicate if the item is part of a ranking page and the type of ranking.
    // Korean: 항목이 랭킹 페이지의 일부인지 그리고 랭킹 유형을 나타내는 플래그입니다.
    this.isRankingPage = false,
    this.isLikeRanking = false,
    this.isDislikeRanking = false,
    this.isSumRanking = false,
    this.index,
  });

  // English: The post data to display.
  // Korean: 표시할 게시물 데이터입니다.
  final Post post;
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
  // English: Optional index of the item, used here to determine if a ranking icon (medal) should be shown.
  // Korean: 항목의 선택적 인덱스로, 여기서는 랭킹 아이콘(메달)을 표시할지 여부를 결정하는 데 사용됩니다.
  final int? index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // English: Style for the post title.
    // Korean: 게시물 제목의 스타일입니다.
    final titleTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: smallPostsItemTitleSize,
        );

    // English: Determine if a ranking icon (medal) should be displayed for top 3 ranks.
    // Korean: 상위 3개 순위에 대해 랭킹 아이콘(메달)을 표시할지 여부를 결정합니다.
    final bool showRankingIcon =
        isRankingPage && index != null && [0, 1, 2].contains(index);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // English: Display title. If it's a top-ranked item, prepend a medal icon.
        // Korean: 제목을 표시합니다. 상위 랭크 아이템인 경우 메달 아이콘을 앞에 추가합니다.
        showRankingIcon
            ? Row(
                children: [
                  Icon(
                    Icons.military_tech_outlined,
                    size: smallPostsItemTitleSize,
                    // English: Medal color based on rank (gold, silver, bronze).
                    // Korean: 순위에 따른 메달 색상 (금, 은, 동).
                    color: index == 0
                        ? const Color(0xFFFFD700) // Gold
                        : index == 1
                            ? const Color(0xFFC0C0C0) // Silver
                            : const Color(0xFFCD7F32), // Bronze
                  ),
                  Expanded(
                    child: TitleTextWidget(
                      title: post.title,
                      textStyle: titleTextStyle,
                      maxLines: smallPostsItemTitleMaxLines,
                    ),
                  ),
                ],
              )
            : TitleTextWidget(
                // English: Default title display without ranking icon.
                // Korean: 랭킹 아이콘이 없는 기본 제목 표시입니다.
                title: post.title,
                textStyle: titleTextStyle,
                maxLines: smallPostsItemTitleMaxLines,
              ),
        const SizedBox(height: 4),
        Consumer(
          builder: (context, ref, child) {
            // English: Fetch admin settings and writer data to configure PostSubInfoOneLine.
            // Korean: PostSubInfoOneLine을 구성하기 위해 관리자 설정 및 작성자 데이터를 가져옵니다.
            final adminSettings = ref.watch(adminSettingsProvider);
            final writerAsync = ref.watch(appUserDataProvider(post.uid));
            return PostSubInfoOneLine(
              post: post,
              mainCategory: adminSettings.mainCategory,
              showMainCategory: adminSettings.useCategory,
              writer: writerAsync.value,
              // English: Conditionally show combined comment+like count based on admin settings and ranking type.
              // Korean: 관리자 설정 및 랭킹 유형에 따라 댓글+좋아요 합산 수를 조건부로 표시합니다.
              showCommentPlusLikeCount:
                  isLikeRanking || isDislikeRanking || isSumRanking
                      ? false
                      : adminSettings.showCommentPlusLikeCount,
              // English: Show like count if it's a like ranking or if enabled by admin (and not other specific ranking types).
              // Korean: 좋아요 랭킹이거나 관리자가 활성화한 경우(그리고 다른 특정 랭킹 유형이 아닌 경우) 좋아요 수를 표시합니다.
              showLikeCount: isLikeRanking
                  ? true
                  : isDislikeRanking || isSumRanking
                      ? false
                      : adminSettings.showLikeCount,
              // English: Show dislike count if it's a dislike ranking or if enabled by admin (and not other specific ranking types).
              // Korean: 싫어요 랭킹이거나 관리자가 활성화한 경우(그리고 다른 특정 랭킹 유형이 아닌 경우) 싫어요 수를 표시합니다.
              showDislikeCount: isDislikeRanking
                  ? true
                  : isLikeRanking || isSumRanking
                      ? false
                      : adminSettings.showDislikeCount,
              // English: Show sum count if it's a sum ranking or if enabled by admin (and not other specific ranking types).
              // Korean: 합계 랭킹이거나 관리자가 활성화한 경우(그리고 다른 특정 랭킹 유형이 아닌 경우) 합계 수를 표시합니다.
              showSumCount: isSumRanking
                  ? true
                  : isLikeRanking || isDislikeRanking
                      ? false
                      : adminSettings.showSumCount,
              // English: Always defer to admin setting for comment count visibility.
              // Korean: 댓글 수 표시는 항상 관리자 설정을 따릅니다.
              showCommentCount: adminSettings.showCommentCount,
              fontSize: smallPostsItemSubInfoSize,
              iconSize: smallPostsItemSubInfoSize + 2,
              showUserAdminLabel: adminSettings.showUserAdminLabel,
              showUserLikeLabel: adminSettings.showUserLikeCount,
              showUserDislikeLabel: adminSettings.showUserDislikeCount,
              showUserSumLabel: adminSettings.showUserSumCount,
              isThumbUpToHeart: adminSettings.isThumbUpToHeart,
            );
          },
        ),
      ],
    );
  }
}

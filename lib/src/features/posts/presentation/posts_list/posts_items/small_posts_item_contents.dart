import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/common_widgets/title_text_widget.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/post_sub_info_one_line.dart';

class SmallPostsItemContents extends ConsumerWidget {
  const SmallPostsItemContents({
    super.key,
    required this.post,
    required this.writer,
    this.isRankingPage = false,
    this.isLikeRanking = false,
    this.isDislikeRanking = false,
    this.isSumRanking = false,
    this.index,
  });

  final Post post;
  final AppUser writer;
  final bool isRankingPage;
  final bool isLikeRanking;
  final bool isDislikeRanking;
  final bool isSumRanking;
  final int? index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: smallPostsItemTitleSize,
        );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isRankingPage && [0, 1, 2].contains(index)
            ? Row(
                children: [
                  if (isRankingPage && [0, 1, 2].contains(index))
                    Icon(
                      Icons.military_tech_outlined,
                      size: smallPostsItemTitleSize,
                      color: index == 0
                          ? const Color(0xFFFFD700)
                          : index == 1
                              ? const Color(0xFFC0C0C0)
                              : const Color(0xFFCD7F32),
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
                title: post.title,
                textStyle: titleTextStyle,
                maxLines: smallPostsItemTitleMaxLines,
              ),
        const SizedBox(height: 4),
        Consumer(
          builder: (context, ref, child) {
            final adminSettings = ref.watch(adminSettingsProvider);
            return PostSubInfoOneLine(
              post: post,
              mainCategory: adminSettings.mainCategory,
              showMainCategory: adminSettings.useCategory,
              writer: writer,
              showCommentPlusLikeCount:
                  isLikeRanking || isDislikeRanking || isSumRanking
                      ? false
                      : adminSettings.showCommentPlusLikeCount,
              showLikeCount: isLikeRanking
                  ? true
                  : isDislikeRanking || isSumRanking
                      ? false
                      : adminSettings.showLikeCount,
              showDislikeCount: isDislikeRanking
                  ? true
                  : isLikeRanking || isSumRanking
                      ? false
                      : adminSettings.showDislikeCount,
              showSumCount: isSumRanking
                  ? true
                  : isLikeRanking || isDislikeRanking
                      ? false
                      : adminSettings.showSumCount,
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

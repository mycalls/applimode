// lib/src/features/posts/presentation/posts_list/posts_items/post_sub_info_one_line.dart

// flutter
import 'package:flutter/material.dart';

// core
import 'package:applimode_app/custom_settings.dart';

// utils
import 'package:applimode_app/src/utils/check_category.dart';
import 'package:applimode_app/src/utils/format.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/writer_label.dart';

// features
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';

// 길이가 길경우 짤리는 현상 방지하기 위해
// SingleChildScrollView 로 래핑해주고
// 사용자 이름의 Flexible 은 언래핑해주었음.
// English: A widget that displays a single line of post sub-information,
// such as category, timestamp, counts (likes, comments), and writer details.
// It's horizontally scrollable to accommodate varying amounts of information.
// Korean: 게시물의 카테고리, 타임스탬프, 개수(좋아요, 댓글), 작성자 정보 등
// 다양한 하위 정보를 한 줄로 표시하는 위젯입니다.
// 다양한 양의 정보를 수용할 수 있도록 가로로 스크롤 가능합니다.
class PostSubInfoOneLine extends StatelessWidget {
  const PostSubInfoOneLine({
    super.key,
    required this.post,
    this.mainCategory,
    this.writer,
    this.showMainCategory,
    this.showCommentPlusLikeCount,
    this.showSumCount,
    this.showLikeCount,
    this.showDislikeCount,
    this.showCommentCount,
    this.isThumbUpToHeart,
    this.captionColor,
    this.countColor,
    this.categoryColor,
    this.fontSize,
    this.iconSize,
    this.showUserAdminLabel,
    this.showUserLikeLabel,
    this.showUserDislikeLabel,
    this.showUserSumLabel,
  });

  // English: The post data object.
  // Korean: 게시물 데이터 객체입니다.
  final Post post;
  // English: A list of main categories, used if 'showMainCategory' is true.
  // Korean: 'showMainCategory'가 true일 경우 사용되는 메인 카테고리 목록입니다.
  final List<MainCategory>? mainCategory;
  // English: The writer's user data, used if writer information needs to be displayed.
  // Korean: 작성자 정보를 표시해야 할 경우 사용되는 작성자의 사용자 데이터입니다.
  final AppUser? writer;
  // English: Flag to control the visibility of the post's main category.
  // Korean: 게시물의 메인 카테고리 표시 여부를 제어하는 플래그입니다.
  final bool? showMainCategory;
  // English: Flag to show the sum of comment and like counts.
  // Korean: 댓글과 좋아요 수의 합계를 표시할지 여부를 나타내는 플래그입니다.
  final bool? showCommentPlusLikeCount;
  // English: Flag to show the sum count (likes - dislikes).
  // Korean: 합계 수(좋아요 - 싫어요)를 표시할지 여부를 나타내는 플래그입니다.
  final bool? showSumCount;
  // English: Flag to show the like count.
  // Korean: 좋아요 수를 표시할지 여부를 나타내는 플래그입니다.
  final bool? showLikeCount;
  // English: Flag to show the dislike count.
  // Korean: 싫어요 수를 표시할지 여부를 나타내는 플래그입니다.
  final bool? showDislikeCount;
  // English: Flag to show the comment count.
  // Korean: 댓글 수를 표시할지 여부를 나타내는 플래그입니다.
  final bool? showCommentCount;
  // English: If true, the like icon will be a heart; otherwise, a thumb-up.
  // Korean: true이면 좋아요 아이콘이 하트 모양이 되고, 그렇지 않으면 엄지척 모양이 됩니다.
  final bool? isThumbUpToHeart;
  // English: Color for caption text (e.g., timestamp, category name).
  // Korean: 캡션 텍스트(예: 타임스탬프, 카테고리 이름)의 색상입니다.
  final Color? captionColor;
  // English: Color for count numbers and their associated icons.
  // Korean: 개수 숫자 및 관련 아이콘의 색상입니다.
  final Color? countColor;
  // English: Specific color for the category text. Overrides default category color if provided.
  // Korean: 카테고리 텍스트의 특정 색상입니다. 제공된 경우 기본 카테고리 색상을 재정의합니다.
  final Color? categoryColor;
  // English: Font size for all text elements in this widget.
  // Korean: 이 위젯의 모든 텍스트 요소에 대한 글꼴 크기입니다.
  final double? fontSize;
  // English: Size for all icons in this widget.
  // Korean: 이 위젯의 모든 아이콘 크기입니다.
  final double? iconSize;
  // English: Flag to show an admin label next to the writer's name if they are an admin.
  // Korean: 작성자가 관리자인 경우 이름 옆에 관리자 레이블을 표시할지 여부를 나타내는 플래그입니다.
  final bool? showUserAdminLabel;
  // English: Flag to show the writer's total like count.
  // Korean: 작성자의 총 좋아요 수를 표시할지 여부를 나타내는 플래그입니다.
  final bool? showUserLikeLabel;
  // English: Flag to show the writer's total dislike count.
  // Korean: 작성자의 총 싫어요 수를 표시할지 여부를 나타내는 플래그입니다.
  final bool? showUserDislikeLabel;
  // English: Flag to show the writer's total sum count (likes - dislikes).
  // Korean: 작성자의 총 합계 수(좋아요 - 싫어요)를 표시할지 여부를 나타내는 플래그입니다.
  final bool? showUserSumLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // English: Default color for count text if 'countColor' is not provided.
    // Korean: 'countColor'가 제공되지 않은 경우 카운트 텍스트의 기본 색상입니다.
    final defaultCountColor = Theme.of(context).colorScheme.primary;
    // English: Style for caption-like text (e.g., category, timestamp).
    // Korean: 캡션과 유사한 텍스트(예: 카테고리, 타임스탬프)의 스타일입니다.
    final captionStyle = textTheme.bodySmall?.copyWith(
      color: captionColor,
      fontSize: fontSize,
    );
    // English: Style for count numbers.
    // Korean: 숫자 카운트의 스타일입니다.
    final countStyle = textTheme.labelMedium?.copyWith(
      color: countColor ?? defaultCountColor,
      fontSize: fontSize,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // English: Main row containing all sub-information pieces.
      // Korean: 모든 하위 정보 조각을 포함하는 메인 행입니다.
      child: Row(
        children: [
          // English: Display category information if enabled and available.
          // Korean: 활성화되어 있고 사용 가능한 경우 카테고리 정보를 표시합니다.
          if (mainCategory != null && (showMainCategory ?? false)) ...[
            Text(
              checkCategory(mainCategory!, post.category).title,
              style: captionStyle?.copyWith(
                  color: categoryColor ??
                      checkCategory(mainCategory!, post.category).color),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '  ·  ',
              style: captionStyle,
            ),
          ],
          // English: Display the formatted creation timestamp (e.g., "2 hours ago").
          // Korean: 형식화된 생성 타임스탬프(예: "2시간 전")를 표시합니다.
          Text(
            Format.toAgo(context, post.createdAt),
            style: captionStyle,
            overflow: TextOverflow.ellipsis,
          ),
          // comment plus like count
          // English: Display the sum of comments and likes if enabled.
          // Korean: 활성화된 경우 댓글과 좋아요의 합계를 표시합니다.
          if (showCommentPlusLikeCount ?? false) ...[
            Text(
              '  ·  ',
              style: captionStyle,
            ),
            Icon(
              Icons.trending_up,
              size: iconSize ?? 14,
              color: countColor,
            ),
            const SizedBox(width: 4),
            Text(
              Format.formatNumber(
                  context, post.postCommentCount + post.likeCount),
              style: countStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // like count
          // English: Display the like count if enabled.
          // Korean: 활성화된 경우 좋아요 수를 표시합니다.
          if (showLikeCount ?? false) ...[
            Text(
              '  ·  ',
              style: captionStyle,
            ),
            Icon(
              isThumbUpToHeart ?? false
                  ? Icons.favorite_outline_rounded
                  : Icons.thumb_up_outlined,
              size: iconSize ?? 14,
              color: countColor,
            ),
            const SizedBox(width: 4),
            Text(
              Format.formatNumber(context, post.likeCount),
              style: countStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // dislike count
          // English: Display the dislike count if enabled.
          // Korean: 활성화된 경우 싫어요 수를 표시합니다.
          if (showDislikeCount ?? false) ...[
            Text(
              '  ·  ',
              style: captionStyle,
            ),
            Icon(
              Icons.thumb_down_outlined,
              size: iconSize ?? 14,
              color: countColor,
            ),
            const SizedBox(width: 4),
            Text(
              Format.formatNumber(context, post.dislikeCount),
              style: countStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // sum count
          // English: Display the sum count (likes - dislikes) if enabled.
          // Korean: 활성화된 경우 합계 수(좋아요 - 싫어요)를 표시합니다.
          if (showSumCount ?? false) ...[
            Text(
              '  ·  ',
              style: captionStyle,
            ),
            Icon(
              Icons.swap_vert_outlined,
              size: iconSize ?? 14,
              color: countColor,
            ),
            const SizedBox(width: 4),
            Text(
              Format.formatNumber(context, post.sumCount),
              style: countStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // comment count
          // English: Display the comment count if enabled.
          // Korean: 활성화된 경우 댓글 수를 표시합니다.
          if (showCommentCount ?? false) ...[
            Text(
              '  ·  ',
              style: captionStyle,
            ),
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: iconSize ?? 14,
              color: countColor,
            ),
            const SizedBox(width: 4),
            Text(
              Format.formatNumber(context, post.postCommentCount),
              style: countStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // writer
          // English: Display writer information if available and enabled.
          // Korean: 사용 가능하고 활성화된 경우 작성자 정보를 표시합니다.
          if (writer != null) ...[
            Text(
              '  ·  ',
              style: captionStyle,
            ),
            // English: Show admin verification icon if applicable.
            // Korean: 해당되는 경우 관리자 인증 아이콘을 표시합니다.
            if ((showUserAdminLabel ?? false) && writer!.isAdmin)
              const Icon(
                Icons.verified_user,
                color: Color(userAdminColor),
                size: smallPostsItemSubInfoSize,
              ),
            if (writer!.verified)
              // English: Show general verification icon.
              // Korean: 일반 인증 아이콘을 표시합니다.
              const Icon(
                Icons.verified,
                color: Color(0xFF00a5e3),
                size: smallPostsItemSubInfoSize,
              ),
            if (writer!.verified ||
                ((showUserAdminLabel ?? false) && writer!.isAdmin))
              const SizedBox(width: 2),
            // English: Display the writer's shortened display name.
            // Korean: 작성자의 축약된 표시 이름을 표시합니다.
            Text(
              Format.getShortName(writer!.displayName),
              style: captionStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // writer like count label
          if ((showUserLikeLabel ?? false) && writer != null) ...[
            // English: Display the writer's total like count using WriterLabel.
            // Korean: WriterLabel을 사용하여 작성자의 총 좋아요 수를 표시합니다.
            const SizedBox(width: 4),
            WriterLabel(
              // label: context.loc.likesCount,
              iconData: Icons.arrow_upward_rounded,
              color: const Color(userLikeCountColor),
              count: writer!.likeCount,
              labelSize: smallPostsItemSubInfoSize - 4,
            ),
          ],
          // writer dislike count label
          if ((showUserDislikeLabel ?? false) && writer != null) ...[
            // English: Display the writer's total dislike count using WriterLabel.
            // Korean: WriterLabel을 사용하여 작성자의 총 싫어요 수를 표시합니다.
            const SizedBox(width: 4),
            WriterLabel(
              // label: context.loc.dislikesCount,
              iconData: Icons.arrow_downward_rounded,
              color: const Color(userDislikeCountColor),
              count: writer!.dislikeCount,
              labelSize: smallPostsItemSubInfoSize - 4,
            ),
          ],
          // writer sum count label
          if ((showUserSumLabel ?? false) && writer != null) ...[
            // English: Display the writer's total sum count using WriterLabel.
            // Korean: WriterLabel을 사용하여 작성자의 총 합계 수를 표시합니다.
            const SizedBox(width: 4),
            WriterLabel(
              // label: context.loc.sumCount,
              iconData: Icons.swap_vert_rounded,
              color: const Color(userSumCountColor),
              count: writer!.sumCount,
              labelSize: smallPostsItemSubInfoSize - 4,
            ),
          ],
        ],
      ),
    );
  }
}

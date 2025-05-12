import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/common_widgets/color_circle.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/cached_circle_image.dart';
import 'package:applimode_app/src/common_widgets/writer_label.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/post_sub_info_one_line.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WriterItem extends ConsumerWidget {
  const WriterItem({
    super.key,
    required this.writerId,
    this.isPage = false,
    this.isAppBar = false,
    this.post,
    this.onTap,
    this.showSubtitle,
    this.mainAlignment,
    this.crossAlignment,
    this.axisSize,
    this.width,
    this.profileImagesize,
    this.nameColor,
    this.captionColor,
    this.countColor,
    this.index,
    this.categoryColor,
    this.nameSize,
    this.subInfoFontSize,
    this.subInfoIconSize,
    this.writerLabelFontSize,
  });

  final String writerId;
  final bool isPage;
  final bool isAppBar;
  final Post? post;
  final VoidCallback? onTap;
  final bool? showSubtitle;
  final MainAxisAlignment? mainAlignment;
  final CrossAxisAlignment? crossAlignment;
  final MainAxisSize? axisSize;
  final double? width;
  final double? profileImagesize;
  final Color? nameColor;
  final Color? captionColor;
  final Color? countColor;
  final int? index;
  final Color? categoryColor;
  final double? nameSize;
  final double? subInfoFontSize;
  final double? subInfoIconSize;
  final double? writerLabelFontSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final writerAsync = ref.watch(appUserDataProvider(writerId));
    return AsyncValueWidget(
        value: writerAsync,
        data: (writer) {
          if (writer == null) {
            return const SizedBox.shrink();
          }
          return InkWell(
            onTap: onTap,
            child: SizedBox(
              width: width,
              child: Row(
                mainAxisAlignment: mainAlignment ?? MainAxisAlignment.start,
                crossAxisAlignment: crossAlignment ?? CrossAxisAlignment.center,
                mainAxisSize: axisSize ?? MainAxisSize.max,
                children: [
                  writer.photoUrl == null
                      ? ColorCircle(size: profileImagesize, index: index)
                      : CachedCircleImage(
                          imageUrl: writer.photoUrl!,
                          size: profileImagesize,
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final adminSettings = ref.watch(adminSettingsProvider);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (adminSettings.showUserAdminLabel &&
                                    writer.isAdmin)
                                  const Icon(
                                    Icons.verified_user,
                                    color: Color(userAdminColor),
                                    size: basicPostsItemNameSize,
                                  ),
                                if (writer.verified)
                                  const Icon(
                                    Icons.verified,
                                    color: Color(0xFF00a5e3),
                                    size: basicPostsItemNameSize,
                                  ),
                                if (writer.verified ||
                                    (adminSettings.showUserAdminLabel &&
                                        writer.isAdmin))
                                  const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    writer.displayName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: nameColor,
                                          fontSize: nameSize,
                                        ),
                                  ),
                                ),
                                if (adminSettings.showUserLikeCount) ...[
                                  const SizedBox(width: 4),
                                  WriterLabel(
                                    //label: context.loc.likesCount,
                                    iconData: Icons.arrow_upward_rounded,
                                    color: const Color(userLikeCountColor),
                                    count: writer.likeCount,
                                    labelSize: writerLabelFontSize,
                                  ),
                                ],
                                if (adminSettings.showUserDislikeCount) ...[
                                  const SizedBox(width: 4),
                                  WriterLabel(
                                    // label: context.loc.dislikesCount,
                                    iconData: Icons.arrow_downward_rounded,
                                    color: const Color(userDislikeCountColor),
                                    count: writer.dislikeCount,
                                    labelSize: writerLabelFontSize,
                                  ),
                                ],
                                if (adminSettings.showUserSumCount) ...[
                                  const SizedBox(width: 4),
                                  WriterLabel(
                                    // label: context.loc.sumCount,
                                    iconData: Icons.swap_vert_rounded,
                                    color: const Color(userSumCountColor),
                                    count: writer.sumCount,
                                    labelSize: writerLabelFontSize,
                                  ),
                                ]
                              ],
                            ),
                            if (showSubtitle == true && post != null)
                              PostSubInfoOneLine(
                                post: post!,
                                showMainCategory: adminSettings.useCategory,
                                mainCategory: adminSettings.useCategory
                                    ? adminSettings.mainCategory
                                    : null,
                                showCommentPlusLikeCount: isPage || isAppBar
                                    ? false
                                    : adminSettings.showCommentPlusLikeCount,
                                showLikeCount: isPage || isAppBar
                                    ? false
                                    : adminSettings.showLikeCount,
                                showDislikeCount: isPage || isAppBar
                                    ? false
                                    : adminSettings.showDislikeCount,
                                showSumCount: isPage || isAppBar
                                    ? false
                                    : adminSettings.showSumCount,
                                showCommentCount: isPage || isAppBar
                                    ? false
                                    : adminSettings.showCommentCount,
                                isThumbUpToHeart:
                                    adminSettings.isThumbUpToHeart,
                                captionColor: captionColor,
                                countColor: countColor,
                                categoryColor: categoryColor,
                                fontSize: subInfoFontSize,
                                iconSize: subInfoIconSize,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

import 'package:applimode_app/src/common_widgets/gradient_color_box.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/src/common_widgets/main_label.dart';
import 'package:applimode_app/src/common_widgets/title_text_widget.dart';
import 'package:applimode_app/src/common_widgets/user_items/writer_item.dart';
import 'package:applimode_app/src/common_widgets/youtube_link_shot.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/round_block_item.dart';
import 'package:applimode_app/src/features/video_player/main_video_player.dart';
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:applimode_app/src/utils/string_converter.dart';
import 'package:applimode_app/src/utils/url_converter.dart';
import 'package:applimode_app/src/utils/get_max_width.dart';
import 'package:applimode_app/src/utils/posts_item_playing_state.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:url_launcher/url_launcher.dart';

class RoundPostsItem extends ConsumerWidget {
  const RoundPostsItem({
    super.key,
    required this.post,
    this.index,
    this.aspectRatio,
    this.isTappable = true,
    this.showMainLabel = true,
    this.showVideoTitle = false,
    this.needTopMargin = false,
    this.needBottomMargin = true,
  });

  final Post post;
  final int? index;
  final double? aspectRatio;
  final bool isTappable;
  final bool showMainLabel;
  final bool showVideoTitle;
  final bool needTopMargin;
  final bool needBottomMargin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // debugInvertOversizedImages = true;

    final writerAsync = ref.watch(appUserDataProvider(post.uid));
    final mainImageUrl = post.mainImageUrl;
    final mainVideoUrl = post.mainVideoUrl;
    final mainVideoImageUrl = post.mainVideoImageUrl;
    final isVideo = mainVideoUrl != null &&
        mainVideoUrl.trim().isNotEmpty &&
        !Regex.ytRegexB.hasMatch(mainVideoUrl);
    final hasTitle = post.title.isNotEmpty;

    final postTitleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontSize: roundPostsItemTitleFontsize,
        );

    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalMargin = screenWidth > pcWidthBreakpoint
        ? ((screenWidth - pcWidthBreakpoint) / 2) + roundCardPadding
        : roundCardPadding;

    return AsyncValueWidget(
      value: writerAsync,
      data: (writer) {
        // debugPrint('roundPostsItem build: $index');
        /*
        final isContent = writer != null && !writer.isBlock && !post.isBlock;
        if (writer == null) {
          return RoundBlockItem(
            aspectRatio: aspectRatio,
            index: index,
            needTopMargin: needTopMargin,
            needBottomMargin: needBottomMargin,
          );
        }
        */
        final isBlock = (writer != null && writer.isBlock) || post.isBlock;
        if (isBlock) {
          return RoundBlockItem(
            aspectRatio: aspectRatio,
            index: index,
            postId: post.id,
            post: post,
            needTopMargin: needTopMargin,
            needBottomMargin: needBottomMargin,
          );
        }
        return InkWell(
          onTap: isTappable && !isVideo
              ? () => context.push(
                    ScreenPaths.post(post.id),
                    extra: post,
                  )
              : null,
          child: Container(
            margin: EdgeInsets.only(
              left: horizontalMargin,
              right: horizontalMargin,
              top: needTopMargin ? roundCardPadding : 0,
              bottom: needBottomMargin ? roundCardPadding : 0,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: AspectRatio(
              aspectRatio: aspectRatio ?? 16 / 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isVideo)
                    MainVideoPlayer(
                      // when delete video post, resolve old video remain
                      key: UniqueKey(),
                      videoUrl: UrlConverter.getIosWebVideoUrl(mainVideoUrl),
                      videoImageUrl: mainVideoImageUrl,
                      aspectRatio: aspectRatio ?? 16 / 9,
                      isRound: true,
                    ),
                  if (!isVideo)
                    mainImageUrl != null
                        ? Positioned.fill(
                            child: PlatformNetworkImage(
                            imageUrl: mainImageUrl,
                            fit: BoxFit.cover,
                            headers: useRTwoSecureGet ? rTwoSecureHeader : null,
                            errorWidget: Regex.ytImageRegex
                                    .hasMatch(mainImageUrl)
                                ? PlatformNetworkImage(
                                    imageUrl:
                                        StringConverter.buildYtProxyThumbnail(
                                            Regex.ytImageRegex
                                                .firstMatch(mainImageUrl)![1]!),
                                    fit: BoxFit.cover,
                                    headers: useRTwoSecureGet
                                        ? rTwoSecureHeader
                                        : null,
                                    errorWidget: Container(
                                      color: Colors.black,
                                    ),
                                  )
                                : Container(
                                    color: Colors.black,
                                  ),
                          ))
                        : GradientColorBox(
                            index: index,
                            child: post.isNoTitle
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      left: 64,
                                      right: 64,
                                      bottom: 24,
                                    ),
                                    child: TitleTextWidget(
                                      title: post.title,
                                      textStyle: postTitleStyle,
                                      maxLines:
                                          roundPostsItemMiddleTitleMaxLines,
                                      textAlign: switch (
                                          roundPostsItemtitleTextAlign) {
                                        TitleTextAlign.start => TextAlign.start,
                                        TitleTextAlign.center =>
                                          TextAlign.center,
                                        TitleTextAlign.end => TextAlign.end,
                                      },
                                    ),
                                  ),
                          ),
                  if (mainImageUrl != null &&
                      Regex.ytImageRegex.hasMatch(mainImageUrl))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 64),
                      child: InkWell(
                        onTap: () {
                          final youtubeId =
                              Regex.ytImageRegex.firstMatch(mainImageUrl)?[1];
                          if (youtubeId != null) {
                            final uri = Uri.tryParse(
                                StringConverter.buildYtFullEmbedUrl(youtubeId));
                            if (uri != null) {
                              launchUrl(uri);
                            }
                          }
                        },
                        child: const YoutubePlayIcon(
                          width: 56,
                          height: 40,
                          iconSize: 24,
                        ),
                      ),
                    ),
                  ...[
                    Positioned(
                      left: 16,
                      bottom: 24,
                      child: InkWell(
                        onTap: () {
                          ref
                              .read(postsItemPlayingStateProvider.notifier)
                              .setFalseAndTrue();
                          context.push(
                            ScreenPaths.post(post.id),
                            extra: post,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!post.isNoWriter)
                              WriterItem(
                                writerId: post.uid,
                                post: post,
                                width: getMaxWidth(
                                  context,
                                  postsListType: PostsListType.round,
                                ),
                                profileImagesize: roundPostsItemProfileSize,
                                nameColor: Colors.white,
                                showSubtitle: true,
                                captionColor: Colors.white,
                                countColor: Colors.white,
                                index: index,
                                categoryColor: Colors.white,
                                nameSize: roundPostsItemNameSize,
                                subInfoFontSize: roundPostsItemSubInfoSize,
                                subInfoIconSize: roundPostsItemSubInfoSize + 2,
                                writerLabelFontSize: roundPostsItemNameSize - 6,
                              ),
                            if ((mainImageUrl != null || isVideo) &&
                                hasTitle &&
                                !post.isNoTitle) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: getMaxWidth(
                                  context,
                                  postsListType: PostsListType.round,
                                ),
                                child: TitleTextWidget(
                                  title: post.title,
                                  textStyle: postTitleStyle,
                                  maxLines: isVideo
                                      ? roundPostsItemVideoTitleMaxLines
                                      : roundPostsItemBottomTitleMaxLines,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (showMainLabel && post.isHeader)
                    MainLabel(
                      left: 16,
                      top: 16,
                      horizontalPadidng: 12,
                      verticalPadding: 4,
                      textStyle: Theme.of(context).textTheme.labelMedium,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:applimode_app/src/common_widgets/gradient_color_box.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/src/common_widgets/main_label.dart';
import 'package:applimode_app/src/common_widgets/title_text_widget.dart';
import 'package:applimode_app/src/common_widgets/user_items/writer_item.dart';
import 'package:applimode_app/src/common_widgets/youtube_link_shot.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/posts/domain/post_and_writer.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/basic_block_item.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/page_item_buttons.dart';
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
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:url_launcher/url_launcher.dart';

class BasicPostsItem extends ConsumerWidget {
  const BasicPostsItem({
    super.key,
    required this.post,
    this.index,
    this.aspectRatio,
    this.isPage = false,
    this.isTappable = true,
    this.showMainLabel = true,
    this.showVideoTitle = false,
  });

  final Post post;
  final int? index;
  final double? aspectRatio;
  final bool isPage;
  final bool isTappable;
  final bool showMainLabel;
  final bool showVideoTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // debugInvertOversizedImages = true;

    final writerAsync = ref.watch(writerFutureProvider(post.uid));
    final mainImageUrl = post.mainImageUrl;
    final mainVideoUrl = post.mainVideoUrl;
    final mainVideoImageUrl = post.mainVideoImageUrl;
    final isVideo = mainVideoUrl != null &&
        mainVideoUrl.trim().isNotEmpty &&
        !Regex.ytRegexB.hasMatch(mainVideoUrl);
    final hasTitle = post.title.isNotEmpty;

    final postTitleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontSize: basicPostsItemTitleFontsize,
        );

    final screenWidth = MediaQuery.sizeOf(context).width;

    return AsyncValueWidget(
      value: writerAsync,
      data: (writer) {
        // debugPrint('BasicPostsItem build: $index');
        final isContent = writer != null && !writer.isBlock && !post.isBlock;
        if (writer == null) {
          return BasicBlockItem(
            aspectRatio: aspectRatio,
            isPage: isPage,
            index: index,
          );
        }
        if (writer.isBlock || post.isBlock) {
          return BasicBlockItem(
            aspectRatio: aspectRatio,
            isPage: isPage,
            index: index,
            postId: post.id,
            postAndWriter: PostAndWriter(post: post, writer: writer),
          );
        }
        return InkWell(
          onTap: isContent && isTappable && !isVideo
              ? () => context.push(
                    ScreenPaths.post(post.id),
                    extra: PostAndWriter(post: post, writer: writer),
                  )
              : null,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: aspectRatio ?? 1.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isContent && isVideo)
                      MainVideoPlayer(
                        // when delete video post, resolve old video remain
                        key: UniqueKey(),
                        videoUrl: UrlConverter.getIosWebVideoUrl(mainVideoUrl),
                        videoImageUrl: mainVideoImageUrl,
                        aspectRatio: aspectRatio ?? 1.0,
                        isPage: isPage,
                      ),
                    if (isContent && !isVideo)
                      mainImageUrl != null
                          ? Positioned.fill(
                              child: PlatformNetworkImage(
                              imageUrl: mainImageUrl,
                              fit: BoxFit.cover,
                              headers:
                                  useRTwoSecureGet ? rTwoSecureHeader : null,
                              errorWidget: Regex.ytImageRegex
                                      .hasMatch(mainImageUrl)
                                  ? PlatformNetworkImage(
                                      imageUrl:
                                          StringConverter.buildYtProxyThumbnail(
                                              Regex.ytImageRegex.firstMatch(
                                                  mainImageUrl)![1]!),
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
                                      padding: const EdgeInsets.all(64.0),
                                      child: SafeArea(
                                        top: false,
                                        bottom: false,
                                        child: TitleTextWidget(
                                          title: post.title,
                                          textStyle: postTitleStyle,
                                          maxLines:
                                              basicPostsItemMiddleTitleMaxLines,
                                          textAlign: switch (
                                              basicPostsItemtitleTextAlign) {
                                            TitleTextAlign.start =>
                                              TextAlign.start,
                                            TitleTextAlign.center =>
                                              TextAlign.center,
                                            TitleTextAlign.end => TextAlign.end,
                                          },
                                        ),
                                      ),
                                    ),
                            ),
                    if (mainImageUrl != null &&
                        Regex.ytImageRegex.hasMatch(mainImageUrl))
                      InkWell(
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
                        child: const YoutubePlayIcon(),
                      ),
                    if (isContent) ...[
                      Positioned(
                        left: 16,
                        bottom: 24,
                        child: SafeArea(
                          top: false,
                          bottom: isPage ? true : false,
                          left: isPage ? true : false,
                          right: isPage ? true : false,
                          child: InkWell(
                            onTap: () {
                              ref
                                  .read(postsItemPlayingStateProvider.notifier)
                                  .setFalseAndTrue();
                              context.push(
                                ScreenPaths.post(post.id),
                                extra: PostAndWriter(
                                  post: post,
                                  writer: writer,
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!post.isNoWriter)
                                  WriterItem(
                                    writer: writer,
                                    isPage: isPage,
                                    post: post,
                                    width: getMaxWidth(
                                      context,
                                      postsListType: isPage
                                          ? PostsListType.page
                                          : PostsListType.square,
                                    ),
                                    profileImagesize: basicPostsItemProfileSize,
                                    nameColor: Colors.white,
                                    showSubtitle: true,
                                    captionColor: Colors.white,
                                    countColor: Colors.white,
                                    index: index,
                                    categoryColor: Colors.white,
                                    nameSize: basicPostsItemNameSize,
                                    subInfoFontSize: basicPostsItemSubInfoSize,
                                    subInfoIconSize:
                                        basicPostsItemSubInfoSize + 2,
                                    writerLabelFontSize:
                                        basicPostsItemNameSize - 6,
                                  ),
                                if ((mainImageUrl != null || isVideo) &&
                                    hasTitle &&
                                    !post.isNoTitle) ...[
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: getMaxWidth(context,
                                        postsListType: isPage
                                            ? PostsListType.page
                                            : PostsListType.square),
                                    child: TitleTextWidget(
                                      title: post.title,
                                      textStyle: postTitleStyle,
                                      maxLines: isVideo
                                          ? basicPostsItemVideoTitleMaxLines
                                          : basicPostsItemBottomTitleMaxLines,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (isContent && isPage)
                      Positioned(
                        right: 16,
                        bottom: 96,
                        child: SafeArea(
                          child: PageItemButtons(
                            post: post,
                            postWriter: writer,
                          ),
                        ),
                      ),
                    if (isContent && showMainLabel && post.isHeader)
                      const MainLabel(left: 16, top: 24),
                  ],
                ),
              ),
              if (!isPage && screenWidth <= pcWidthBreakpoint)
                const SizedBox(height: cardBottomPadding),
            ],
          ),
        );
      },
    );
  }
}

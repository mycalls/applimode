// lib/src/features/posts/presentation/posts_list/posts_items/round_posts_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/common_widgets/gradient_color_box.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/src/common_widgets/main_label.dart';
import 'package:applimode_app/src/common_widgets/title_text_widget.dart';
import 'package:applimode_app/src/common_widgets/user_items/writer_item.dart';
import 'package:applimode_app/src/common_widgets/youtube_link_shot.dart';
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:applimode_app/src/utils/string_converter.dart';
import 'package:applimode_app/src/utils/url_converter.dart';
import 'package:applimode_app/src/utils/get_max_width.dart';
import 'package:applimode_app/src/utils/posts_item_playing_state.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/round_block_item.dart';
import 'package:applimode_app/src/features/video_player/main_video_player.dart';

// English: A widget to display a post item with rounded corners, suitable for card-style layouts.
// It handles various content types like images, videos, and text-only posts, and adapts its margins.
// Korean: 둥근 모서리를 가진 게시물 항목을 표시하는 위젯으로, 카드 스타일 레이아웃에 적합합니다.
// 이미지, 비디오, 텍스트 전용 게시물과 같은 다양한 콘텐츠 유형을 처리하고 여백을 조정합니다.
class RoundPostsItem extends ConsumerWidget {
  const RoundPostsItem({
    super.key,
    required this.post,
    this.index,
    this.aspectRatio,
    this.isTappable = true,
    this.showMainLabel = true,
    this.needTopMargin = false,
    this.needBottomMargin = true,
  });

  // English: The post data to display.
  // Korean: 표시할 게시물 데이터입니다.
  final Post post;
  // English: Optional index of the item, can be used for styling or logic (e.g., GradientColorBox).
  // Korean: 항목의 선택적 인덱스로, 스타일링이나 로직(예: GradientColorBox)에 사용될 수 있습니다.
  final int? index;
  // English: Aspect ratio for the main content area. Defaults to 16/9.
  // Korean: 기본 콘텐츠 영역의 종횡비입니다. 기본값은 16/9입니다.
  final double? aspectRatio;
  // English: Flag to control if the entire item is tappable for navigation.
  // Korean: 전체 항목을 탭하여 탐색할 수 있는지 여부를 제어하는 플래그입니다.
  final bool isTappable;
  // English: Flag to show a "Main" label if the post is a header post.
  // Korean: 게시물이 헤더 게시물인 경우 "Main" 레이블을 표시할지 여부를 나타내는 플래그입니다.
  final bool showMainLabel;
  // English: Flag to add top margin (padding) to the card.
  // Korean: 카드 상단에 여백(패딩)을 추가할지 여부를 나타내는 플래그입니다.
  final bool needTopMargin;
  // English: Flag to add bottom margin (padding) to the card.
  // Korean: 카드 하단에 여백(패딩)을 추가할지 여부를 나타내는 플래그입니다.
  final bool needBottomMargin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // debugInvertOversizedImages = true;

    // English: Fetch writer data asynchronously.
    // Korean: 작성자 데이터를 비동기적으로 가져옵니다.
    final writerAsync = ref.watch(appUserDataProvider(post.uid));
    final mainImageUrl = post.mainImageUrl;
    final mainVideoUrl = post.mainVideoUrl;
    final mainVideoImageUrl = post.mainVideoImageUrl;
    // English: Determine if the post is a video (excluding YouTube links which are handled as images with play icons).
    // Korean: 게시물이 비디오인지 확인합니다 (재생 아이콘이 있는 이미지로 처리되는 YouTube 링크 제외).
    final isVideo = mainVideoUrl != null &&
        mainVideoUrl.trim().isNotEmpty &&
        !Regex.ytRegexB.hasMatch(mainVideoUrl);
    // English: Determine if the main image URL is a YouTube thumbnail.
    // Korean: 기본 이미지 URL이 YouTube 썸네일인지 확인합니다.
    final bool isMainImageYouTube =
        mainImageUrl != null && Regex.ytImageRegex.hasMatch(mainImageUrl);
    final hasTitle = post.title.isNotEmpty;

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

    return AsyncValueWidget(
      value: writerAsync,
      // English: Build the UI once writer data is available.
      // Korean: 작성자 데이터를 사용할 수 있게 되면 UI를 빌드합니다.
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
        // English: Determine if the post or writer is blocked.
        // Korean: 게시물 또는 작성자가 차단되었는지 확인합니다.
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
        // English: Main tappable area for the post item.
        // Korean: 게시물 항목의 기본 탭 가능 영역입니다.
        return InkWell(
          onTap: isTappable && !isVideo
              ? () => context.push(
                    ScreenPaths.post(post.id),
                    extra: post,
                  )
              : null,
          // English: Container for margins and rounded corners.
          // Korean: 여백 및 둥근 모서리를 위한 컨테이너입니다.
          child: Container(
            margin: EdgeInsets.only(
              left: horizontalMargin,
              right: horizontalMargin,
              top: needTopMargin ? roundCardPadding : 0,
              bottom: needBottomMargin ? roundCardPadding : 0,
            ),
            // English: Apply rounded corners to the card.
            // Korean: 카드에 둥근 모서리를 적용합니다.
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: AspectRatio(
              // English: Aspect ratio for the content, defaults to 16/9.
              // Korean: 콘텐츠의 종횡비, 기본값은 16/9입니다.
              aspectRatio: aspectRatio ?? 16 / 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isVideo)
                    // English: Display video player if it's a video post.
                    // Korean: 비디오 게시물인 경우 비디오 플레이어를 표시합니다.
                    MainVideoPlayer(
                      // English: Using UniqueKey() to ensure the MainVideoPlayer is fully rebuilt
                      // and its state reset, especially when the video post changes or is
                      // replaced in a list. This helps prevent issues like the old video
                      // state persisting for a new video widget.
                      // Korean: UniqueKey()를 사용하여 MainVideoPlayer가 완전히 다시 빌드되고
                      // 상태가 재설정되도록 합니다. 특히 비디오 게시물이 변경되거나 목록에서
                      // 교체될 때 유용합니다. 이는 이전 비디오 상태가 새 비디오 위젯에 남아있는
                      // 문제를 방지하는 데 도움이 됩니다.
                      key: UniqueKey(),
                      videoUrl: UrlConverter.getIosWebVideoUrl(mainVideoUrl),
                      videoImageUrl: mainVideoImageUrl,
                      aspectRatio: aspectRatio ?? 16 / 9,
                      isRound: true,
                    ),
                  if (!isVideo)
                    // English: Display image or gradient box if not a video.
                    // Korean: 비디오가 아닌 경우 이미지 또는 그라데이션 상자를 표시합니다.
                    mainImageUrl != null
                        ? Positioned.fill(
                            child: PlatformNetworkImage(
                            imageUrl: mainImageUrl,
                            fit: BoxFit.cover,
                            headers: useRTwoSecureGet ? rTwoSecureHeader : null,
                            // English: Error widget handles fallback for failed image loads.
                            // Korean: 오류 위젯은 이미지 로드 실패 시 대체 콘텐츠를 처리합니다.
                            errorWidget: isMainImageYouTube
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
                                      // English: Proxy also failed. Korean: 프록시도 실패했습니다.
                                      color: Colors.black,
                                    ),
                                  )
                                : Container(
                                    // English: Non-YT image failed. Korean: YT 이미지가 아닌 것이 실패했습니다.
                                    color: Colors.black,
                                  ),
                          ))
                        // English: Display a gradient box with title if no image.
                        // Korean: 이미지가 없는 경우 제목과 함께 그라데이션 상자를 표시합니다.
                        : GradientColorBox(
                            index: index,
                            // English: If post.isNoTitle is true, no title is shown in the gradient box.
                            // Otherwise, the title is displayed, centered and padded.
                            // Korean: post.isNoTitle이 true이면 그라데이션 상자에 제목이 표시되지 않습니다.
                            // 그렇지 않으면 제목이 중앙에 패딩과 함께 표시됩니다.
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
                  if (mainImageUrl != null && isMainImageYouTube)
                    // English: Overlay a play icon if it's a YouTube image, linking to YouTube.
                    // Korean: YouTube 이미지인 경우 YouTube로 연결되는 재생 아이콘을 오버레이합니다.
                    Padding(
                      padding: const EdgeInsets.only(bottom: 64),
                      child: InkWell(
                        onTap: () async {
                          final youtubeId =
                              Regex.ytImageRegex.firstMatch(mainImageUrl)?[1];
                          if (youtubeId != null) {
                            final uri = Uri.tryParse(
                                StringConverter.buildYtFullEmbedUrl(youtubeId));
                            if (uri != null) {
                              // English: Check if the URL can be launched before attempting.
                              // Korean: 시도하기 전에 URL을 실행할 수 있는지 확인합니다.
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                // Optional: Show a snackbar or log an error
                                debugPrint('Could not launch $uri');
                              }
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
                  // English: Positioned widget for writer info and post title at the bottom.
                  // Korean: 하단에 작성자 정보 및 게시물 제목을 위한 Positioned 위젯입니다.
                  ...[
                    Positioned(
                      left: 16,
                      bottom: 24,
                      child: InkWell(
                        onTap: () {
                          ref
                              // English: Notify a state change, possibly related to media playback.
                              // Korean: 미디어 재생과 관련된 상태 변경을 알립니다.
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
                            // English: Display writer information if not hidden.
                            // Korean: 숨겨지지 않은 경우 작성자 정보를 표시합니다.
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
                            // English: Display post title if conditions are met (e.g., image/video exists, title is not empty, not hidden).
                            // Korean: 조건이 충족되면(예: 이미지/비디오 존재, 제목이 비어 있지 않음, 숨겨지지 않음) 게시물 제목을 표시합니다.
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
                  // English: Show "Main" label for header posts.
                  // Korean: 헤더 게시물에 "Main" 레이블을 표시합니다.
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

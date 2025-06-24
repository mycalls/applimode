// lib/src/features/posts/presentation/posts_list/posts_items/basic_posts_item.dart

// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/app_states/posts_item_playing_state.dart';
import 'package:applimode_app/src/core/constants/constants.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:applimode_app/src/utils/string_converter.dart';
import 'package:applimode_app/src/utils/url_converter.dart';
import 'package:applimode_app/src/utils/get_max_width.dart';
import 'package:applimode_app/src/utils/regex.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/async_value_widget.dart';
import 'package:applimode_app/src/common_widgets/gradient_color_box.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/src/common_widgets/main_label.dart';
import 'package:applimode_app/src/common_widgets/title_text_widget.dart';
import 'package:applimode_app/src/common_widgets/video_player/main_video_player.dart';
import 'package:applimode_app/src/common_widgets/youtube_link_shot.dart';

// features
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/posts_items/basic_block_item.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/posts_items/page_item_buttons.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/writer_item.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';

// English: A widget to display a basic post item, adaptable for different layouts (e.g., square, page).
// It handles various content types like images, videos, and text-only posts.
// Korean: 기본 게시물 항목을 표시하는 위젯으로, 다양한 레이아웃(예: 정사각형, 페이지)에 맞게 조정될 수 있습니다.
// 이미지, 비디오, 텍스트 전용 게시물과 같은 다양한 콘텐츠 유형을 처리합니다.
class BasicPostsItem extends ConsumerWidget {
  const BasicPostsItem({
    super.key,
    required this.post,
    this.index,
    this.aspectRatio,
    this.isPage = false,
    this.isTappable = true,
    this.showMainLabel = true,
  });

  // English: The post data to display.
  // Korean: 표시할 게시물 데이터입니다.
  final Post post;
  // English: Optional index of the item, can be used for styling or logic.
  // Korean: 항목의 선택적 인덱스로, 스타일링이나 로직에 사용될 수 있습니다.
  final int? index;
  // English: Aspect ratio for the main content area.
  // Korean: 기본 콘텐츠 영역의 종횡비입니다.
  final double? aspectRatio;
  // English: Flag to indicate if the item is displayed in a page-like view, affecting layout.
  // Korean: 항목이 페이지 형식 뷰에 표시되는지 여부를 나타내는 플래그로, 레이아웃에 영향을 줍니다.
  final bool isPage;
  // English: Flag to control if the entire item is tappable for navigation.
  // Korean: 전체 항목을 탭하여 탐색할 수 있는지 여부를 제어하는 플래그입니다.
  final bool isTappable;
  // English: Flag to show a "Main" label if the post is a header post.
  // Korean: 게시물이 헤더 게시물인 경우 "Main" 레이블을 표시할지 여부를 나타내는 플래그입니다.
  final bool showMainLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // debugInvertOversizedImages = true;

    // English: Fetch writer data asynchronously.
    // Korean: 작성자 데이터를 비동기적으로 가져옵니다.
    final writerAsync = ref.watch(appUserDataProvider(post.uid));
    final mainImageUrl = post.mainImageUrl;
    final mainVideoUrl = post.mainVideoUrl;
    final mainVideoImageUrl = post.mainVideoImageUrl;
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
          fontSize: basicPostsItemTitleFontsize,
        );

    final screenWidth = MediaQuery.sizeOf(context).width;

    // English: Use AsyncValueWidget to handle loading/error states for writer data.
    // Korean: 작성자 데이터의 로딩/오류 상태를 처리하기 위해 AsyncValueWidget을 사용합니다.
    return AsyncValueWidget(
      value: writerAsync,
      data: (writer) {
        // debugPrint('BasicPostsItem build: $index');
        /*
        final isContent = writer != null && !writer.isBlock && !post.isBlock;
        if (writer == null) {
          return BasicBlockItem(
            aspectRatio: aspectRatio,
            isPage: isPage,
            index: index,
          );
        }
        */
        // English: Determine if the post or writer is blocked.
        // Korean: 게시물 또는 작성자가 차단되었는지 확인합니다.
        final isBlock = (writer != null && writer.isBlock) || post.isBlock;
        if (isBlock) {
          return BasicBlockItem(
            aspectRatio: aspectRatio,
            isPage: isPage,
            index: index,
            postId: post.id,
            post: post,
          );
        }
        // English: Main clickable area for the post item.
        // Korean: 게시물 항목의 기본 클릭 가능 영역입니다.
        return InkWell(
          onTap: isTappable && !isVideo
              ? () => context.push(
                    ScreenPaths.post(post.id),
                    extra: post,
                  )
              : null,
          // English: Column layout for aspect ratio content and potential bottom padding.
          // Korean: 종횡비 콘텐츠 및 하단 패딩을 위한 Column 레이아웃입니다.
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: aspectRatio ?? 1.0,
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
                        aspectRatio: aspectRatio ?? 1.0,
                        isPage: isPage,
                      ),
                    if (!isVideo)
                      // English: Display image or gradient box if not a video.
                      // Korean: 비디오가 아닌 경우 이미지 또는 그라데이션 상자를 표시합니다.
                      mainImageUrl != null
                          ? Positioned.fill(
                              child: PlatformNetworkImage(
                              imageUrl: mainImageUrl,
                              fit: BoxFit.cover,
                              headers:
                                  useRTwoSecureGet ? rTwoSecureHeader : null,
                              // English: Error widget handles fallback for failed image loads.
                              // Korean: 오류 위젯은 이미지 로드 실패 시 대체 콘텐츠를 처리합니다.
                              errorWidget: isMainImageYouTube
                                  ? PlatformNetworkImage(
                                      // English: Try YouTube proxy if original YT image failed. Korean: 원본 YT 이미지가 실패한 경우 YouTube 프록시를 시도합니다.
                                      imageUrl: StringConverter
                                          .buildYtProxyThumbnail(Regex
                                                  .ytImageRegex
                                                  .firstMatch(mainImageUrl)![
                                              1]!), // Assumes mainImageUrl is valid YT URL
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
                    if (mainImageUrl != null && isMainImageYouTube)
                      // English: Overlay a play icon if it's a YouTube image, linking to YouTube.
                      // Korean: YouTube 이미지인 경우 YouTube로 연결되는 재생 아이콘을 오버레이합니다.
                      InkWell(
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
                        child: const YoutubePlayIcon(),
                      ),
                    // English: Positioned widget for writer info and post title at the bottom.
                    // Korean: 하단에 작성자 정보 및 게시물 제목을 위한 Positioned 위젯입니다.
                    ...[
                      Positioned(
                        left: 16,
                        bottom: 24,
                        child: SafeArea(
                          // English: Adjust SafeArea based on whether it's a page view.
                          // Korean: 페이지 뷰인지 여부에 따라 SafeArea를 조정합니다.
                          top: false,
                          bottom: isPage ? true : false,
                          left: isPage ? true : false,
                          right: isPage ? true : false,
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
                                // English: Display post title if conditions are met.
                                // Korean: 조건이 충족되면 게시물 제목을 표시합니다.
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
                    // English: Display action buttons if in page view.
                    // Korean: 페이지 뷰인 경우 작업 버튼을 표시합니다.
                    if (isPage)
                      Positioned(
                        right: 16,
                        bottom: 96,
                        child: SafeArea(
                          child: PageItemButtons(
                            post: post,
                          ),
                        ),
                      ),
                    // English: Show "Main" label for header posts.
                    // Korean: 헤더 게시물에 "Main" 레이블을 표시합니다.
                    if (showMainLabel && post.isHeader)
                      const MainLabel(left: 16, top: 24),
                  ],
                ),
              ),
              // English: Add bottom padding for non-page views on smaller screens.
              // Korean: 작은 화면의 비페이지 뷰에 하단 패딩을 추가합니다.
              if (!isPage && screenWidth <= pcWidthBreakpoint)
                const SizedBox(height: cardBottomPadding),
            ],
          ),
        );
      },
    );
  }
}

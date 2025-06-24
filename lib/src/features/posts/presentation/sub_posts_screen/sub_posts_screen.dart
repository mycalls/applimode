// lib/src/features/posts/presentation/sub_posts_screen.dart

// flutter
import 'package:flutter/foundation.dart';

// external
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/app_states/updated_post_id.dart';
import 'package:applimode_app/src/core/app_states/list_state.dart';
import 'package:applimode_app/src/core/constants/constants.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';
import 'package:applimode_app/src/common_widgets/buttons/web_back_button.dart';

// features
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/posts_items/basic_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/posts_items/round_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/posts_items/small_posts_item.dart';

// English: A screen widget to display a list of posts based on a specific query.
// It supports different list item layouts (type) and adapts its AppBar and scrolling behavior.
// Korean: 특정 쿼리를 기반으로 게시물 목록을 표시하는 화면 위젯입니다.
// 다양한 목록 아이템 레이아웃(type)을 지원하며 AppBar 및 스크롤 동작을 조정합니다.
class SubPostsScreen extends ConsumerWidget {
  const SubPostsScreen({
    super.key,
    required this.query,
    this.appBarTitle,
    this.type = PostsListType.square,
  });

  // English: The Firestore query used to fetch the posts for this screen.
  // Korean: 이 화면의 게시물을 가져오는 데 사용되는 Firestore 쿼리입니다.
  final Query<Post> query;
  // English: Optional title to display in the AppBar.
  // Korean: AppBar에 표시할 선택적 제목입니다.
  final String? appBarTitle;
  // English: The type of list layout to display (e.g., square, small, page, round, mixed).
  // Korean: 표시할 목록 레이아웃 유형입니다 (예: square, small, page, round, mixed).
  final PostsListType type;

  // English: Builder function for individual post items in the list.
  // It selects the appropriate item widget based on the 'type'.
  // Korean: 목록의 개별 게시물 아이템을 위한 빌더 함수입니다.
  // 'type'에 따라 적절한 아이템 위젯을 선택합니다.
  Widget _itemBuilder(
      BuildContext context, int index, QueryDocumentSnapshot<Post> doc) {
    final post = doc.data();
    switch (type) {
      case PostsListType.small:
        return SmallPostsItem(
          post: post,
          index: index,
        );
      case PostsListType.square:
        // English: For 'square' type, show BasicPostsItem.
        // Korean: 'square' 타입의 경우, BasicPostsItem을 표시합니다.
        return BasicPostsItem(
          post: post,
          index: index,
        );
      case PostsListType.page:
        // English: For 'page' type, show BasicPostsItem configured for full-page display.
        // Korean: 'page' 타입의 경우, 전체 페이지 표시에 맞게 구성된 BasicPostsItem을 표시합니다.
        return BasicPostsItem(
          post: post,
          index: index,
          aspectRatio: MediaQuery.sizeOf(context).aspectRatio,
          isPage: true,
          // isTappable: false,
          showMainLabel: false,
        );
      case PostsListType.round:
        // English: For 'round' type, show RoundPostsItem.
        // Korean: 'round' 타입의 경우, RoundPostsItem을 표시합니다.
        return RoundPostsItem(
          post: post,
          index: index,
        );
      case PostsListType.mixed:
        // English: For 'mixed' type, apply specific logic:
        // - Video post or image-only post without title: RoundPostsItem.
        // - Otherwise: SmallPostsItem.
        // Korean: 'mixed' 타입의 경우, 특정 로직을 적용합니다:
        // - 비디오 게시물이거나 제목 없는 이미지 전용 게시물: RoundPostsItem.
        // - 그 외: SmallPostsItem.
        // Note: Top margin is applied to RoundPostsItem if it's not the first item.
        if (post.mainVideoUrl != null ||
            (post.mainImageUrl != null && post.title.trim().isEmpty)) {
          return RoundPostsItem(
            post: post,
            index: index,
            needTopMargin: index == 0 ? false : true,
            needBottomMargin: false,
          );
        }
        return SmallPostsItem(
          post: post,
          index: index,
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // English: Watch the posts repository to get a reference for updated post queries.
    // Korean: 업데이트된 게시물 쿼리에 대한 참조를 얻기 위해 게시물 리포지토리를 관찰합니다.
    final updatedPostQuery = ref.watch(postsRepositoryProvider).postsRef();

    final screenWidth = MediaQuery.sizeOf(context).width;
    // English: Calculate horizontal margin for 'round' type items based on screen width.
    // Korean: 화면 너비에 따라 'round' 타입 아이템의 수평 마진을 계산합니다.
    final horizontalMargin = screenWidth > pcWidthBreakpoint
        ? ((screenWidth - pcWidthBreakpoint) / 2) + roundCardPadding
        : roundCardPadding;

    // English: Determine if the current layout is a page view.
    // This affects AppBar style, body structure, and background color.
    // Korean: 현재 레이아웃이 페이지 뷰인지 확인합니다.
    // 이는 AppBar 스타일, 본문 구조 및 배경색에 영향을 줍니다.
    final isPage = type == PostsListType.page;

    return Scaffold(
      // English: Conditionally set the AppBar.
      // For 'page' type, a transparent AppBar is used.
      // For other types, the AppBar is part of the CustomScrollView (SliverAppBar) or null if not needed.
      // Korean: AppBar를 조건부로 설정합니다.
      // 'page' 유형의 경우 투명한 AppBar가 사용됩니다.
      // 다른 유형의 경우 AppBar는 CustomScrollView의 일부(SliverAppBar)이거나 필요하지 않은 경우 null입니다.
      appBar: isPage
          ? AppBar(
              title: Text(appBarTitle ?? ''),
              forceMaterialTransparency: true,
              foregroundColor: Colors.white,
              elevation: 0,
              // English: Show standard back button on mobile, custom WebBackButton on web.
              // Korean: 모바일에서는 표준 뒤로가기 버튼을, 웹에서는 사용자 정의 WebBackButton을 표시합니다.
              automaticallyImplyLeading: kIsWeb ? false : true,
              leading: kIsWeb ? const WebBackButton() : null,
            )
          : null,
      body: isPage
          ? SimplePageListView(
              query: query,
              // English: Indicates that this list view is for a PageView-like structure.
              // SimplePageListView will adapt its internal scrolling/pagination logic.
              // Korean: 이 리스트 뷰가 PageView와 유사한 구조임을 나타냅니다. SimplePageListView는 내부 스크롤/페이지네이션 로직을 조정합니다.
              isPage: true,
              listState: postsListStateProvider,
              itemBuilder: _itemBuilder,
              refreshUpdatedDoc: true,
              updatedDocQuery: updatedPostQuery,
              updatedDocState: updatedPostIdProvider,
            )
          : CustomScrollView(
              // English: For non-page types, use a CustomScrollView to allow for SliverAppBar and SliverList.
              // Korean: 페이지 유형이 아닌 경우 CustomScrollView를 사용하여 SliverAppBar 및 SliverList를 허용합니다.
              slivers: [
                if (!isPage)
                  // English: Standard AppBar that floats as the user scrolls.
                  // Korean: 사용자가 스크롤할 때 뜨는 표준 AppBar입니다.
                  SliverAppBar(
                    floating: true,
                    title: Text(appBarTitle ?? ''),
                    // English: Show standard back button on mobile, custom WebBackButton on web.
                    // Korean: 모바일에서는 표준 뒤로가기 버튼을, 웹에서는 사용자 정의 WebBackButton을 표시합니다.
                    automaticallyImplyLeading: kIsWeb ? false : true,
                    leading: kIsWeb ? const WebBackButton() : null,
                  ),
                SimplePageListView(
                  query: query,
                  listState: postsListStateProvider,
                  padding: switch (type) {
                    // English: Specific bottom padding for mixed type.
                    // Korean: mixed 타입에 대한 특정 하단 패딩입니다.
                    PostsListType.mixed =>
                      const EdgeInsets.only(bottom: roundCardPadding),
                    _ => null,
                  },
                  itemExtent: switch (type) {
                    // English: Calculate itemExtent for square type.
                    // It's screenWidth, plus cardBottomPadding on smaller screens
                    // to account for the SizedBox in BasicPostsItem.
                    // Korean: square 타입에 대한 itemExtent를 계산합니다.
                    // 화면 너비에 작은 화면에서는 BasicPostsItem의 SizedBox를 고려하여 cardBottomPadding을 더합니다.
                    PostsListType.square => screenWidth +
                        (screenWidth <= pcWidthBreakpoint
                            ? cardBottomPadding
                            : 0.0),
                    // English: Calculate itemExtent for round type.
                    // This is the height of the AspectRatio (16:9) within RoundPostsItem's content area,
                    // plus roundCardPadding for its bottom margin.
                    // Korean: round 타입에 대한 itemExtent를 계산합니다.
                    // RoundPostsItem의 콘텐츠 영역 내 AspectRatio(16:9)의 높이에 하단 마진을 위한 roundCardPadding을 더합니다.
                    PostsListType.round =>
                      ((screenWidth - (2 * horizontalMargin)) * 9 / 16) +
                          roundCardPadding,
                    // English: Fixed height for small list items.
                    // Korean: 작은 목록 아이템의 고정 높이입니다.
                    PostsListType.small => listSmallItemHeight,
                    _ => null,
                  },
                  itemBuilder: _itemBuilder,
                  refreshUpdatedDoc: true,
                  updatedDocQuery: updatedPostQuery,
                  updatedDocState: updatedPostIdProvider,
                  // English: Indicates that this SimplePageListView is part of a CustomScrollView.
                  // Korean: 이 SimplePageListView가 CustomScrollView의 일부임을 나타냅니다.
                  isSliver: true,
                )
              ],
            ),
      // English: If 'isPage' is true, the body extends behind the AppBar. Background is black for immersive page view.
      // Korean: 'isPage'가 true이면 body가 AppBar 뒤까지 확장됩니다. 몰입형 페이지 뷰를 위해 배경은 검은색입니다.
      extendBodyBehindAppBar: isPage ? true : false,
      backgroundColor: isPage ? Colors.black : null,
    );
  }
}

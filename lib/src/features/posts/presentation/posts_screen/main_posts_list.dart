// lib/src/features/posts/presentation/posts_list/main_posts_list.dart

import 'dart:async';

// flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/app_states/list_state.dart';
import 'package:applimode_app/src/core/app_states/updated_post_id.dart';
import 'package:applimode_app/src/core/constants/constants.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';

// features
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_screen/posts_app_bar.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/posts_items/basic_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/posts_items/round_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/posts_items/small_posts_item.dart';

// English: A widget that displays the main list of posts, adaptable to various layouts (type).
// It supports pull-to-refresh and different item views based on the PostsListType.
// Korean: 다양한 레이아웃(type)에 적응할 수 있는 메인 게시물 목록을 표시하는 위젯입니다.
// 당겨서 새로고침 기능을 지원하며 PostsListType에 따라 다른 아이템 뷰를 표시합니다.
class MainPostsList extends ConsumerStatefulWidget {
  const MainPostsList({
    super.key,
    this.type = PostsListType.square,
  });

  // English: The type of list layout to display (e.g., square, small, page, round, mixed).
  // Korean: 표시할 목록 레이아웃 유형입니다 (예: square, small, page, round, mixed).
  final PostsListType type;

  @override
  ConsumerState<MainPostsList> createState() => _MainPostsListState();
}

class _MainPostsListState extends ConsumerState<MainPostsList> {
  // English: Scroll controller for the CustomScrollView.
  // Korean: CustomScrollView를 위한 스크롤 컨트롤러입니다.
  final ScrollController _controller = ScrollController();
  // English: Timer to throttle refresh actions, preventing too frequent updates.
  // Korean: 새로고침 작업을 조절하여 너무 잦은 업데이트를 방지하는 타이머입니다.
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // English: Initialize the timer. This provides an initial cooldown for refreshes.
    // If a refresh is triggered very soon after initState, it will be throttled.
    // Korean: 타이머를 초기화합니다. 이는 새로고침에 대한 초기 쿨다운을 제공합니다.
    // initState 직후 매우 빠르게 새로고침이 트리거되면 조절됩니다.
    timer = Timer(const Duration(seconds: mainPostsRefreshTimer), () {});
  }

  @override
  void dispose() {
    // English: Dispose the scroll controller and cancel the timer to prevent memory leaks.
    // Korean: 메모리 누수를 방지하기 위해 스크롤 컨트롤러를 폐기하고 타이머를 취소합니다.
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (timer != null && timer!.isActive) {
      // English: If the timer is active, a refresh is already in cooldown, so return.
      // Korean: 타이머가 활성 상태이면 새로고침이 이미 쿨다운 중이므로 반환합니다.
      return;
    }
    // English: Trigger a list refresh by updating the postsListStateProvider.
    // Korean: postsListStateProvider를 업데이트하여 목록 새로고침을 트리거합니다.
    ref.read(postsListStateProvider.notifier).set(nowToInt());
    // English: Reset the timer to start a new cooldown period.
    // Korean: 새 쿨다운 기간을 시작하기 위해 타이머를 재설정합니다.
    timer = Timer(const Duration(seconds: mainPostsRefreshTimer), () {});
  }

  // English: Builder for the empty state of the list.
  // Korean: 목록이 비어 있을 때 표시될 위젯을 빌드합니다.
  Widget _startPostBuilder(BuildContext context) =>
      Center(child: Text(context.loc.startFirstPost));

  // English: Builder for individual post items in the list.
  // Korean: 목록의 개별 게시물 아이템을 빌드합니다.
  Widget _itemBuilder(
      BuildContext context, int index, QueryDocumentSnapshot<Post> doc) {
    final post = doc.data();
    switch (widget.type) {
      case PostsListType.small:
        // English: For 'small' type, if it's the first item and a header, show RoundPostsItem. Otherwise, SmallPostsItem.
        // Korean: 'small' 타입의 경우, 첫 번째 아이템이고 헤더이면 RoundPostsItem을, 그렇지 않으면 SmallPostsItem을 표시합니다.
        if (index == 0 && post.isHeader) {
          return RoundPostsItem(
            post: post,
            aspectRatio: smallItemHeaderRatio,
            index: index,
          );
        }
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
        // - First header item: RoundPostsItem.
        // - Video post or image-only post without title: RoundPostsItem.
        // - Otherwise: SmallPostsItem.
        // Korean: 'mixed' 타입의 경우, 특정 로직을 적용합니다:
        // - 첫 번째 헤더 아이템: RoundPostsItem.
        // - 비디오 게시물이거나 제목 없는 이미지 전용 게시물: RoundPostsItem.
        // - 그 외: SmallPostsItem.
        if (index == 0 && post.isHeader) {
          return RoundPostsItem(
            post: post,
            aspectRatio: smallItemHeaderRatio,
            index: index,
            needBottomMargin: false,
          );
        }
        if (post.mainVideoUrl != null ||
            (post.mainImageUrl != null && post.title.trim().isEmpty)) {
          return RoundPostsItem(
            post: post,
            index: index,
            needTopMargin: true,
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
  Widget build(BuildContext context) {
    // English: Watch necessary providers for data and state.
    // Korean: 데이터 및 상태에 필요한 프로바이더를 관찰합니다.
    final query = ref.watch(postsRepositoryProvider).defaultPostsQuery();
    final mainQuery = ref.watch(postsRepositoryProvider).mainPostsQuery();
    final recentDocQuery = ref.watch(postsRepositoryProvider).recentPostQuery();
    final updatedPostQuery = ref.watch(postsRepositoryProvider).postsRef();

    final screenWidth = MediaQuery.sizeOf(context).width;
    // English: Calculate horizontal margin for 'round' type items based on screen width.
    // Korean: 화면 너비에 따라 'round' 타입 아이템의 수평 마진을 계산합니다.
    final horizontalMargin = screenWidth > pcWidthBreakpoint
        ? ((screenWidth - pcWidthBreakpoint) / 2) + roundCardPadding
        : roundCardPadding;

    // English: Determine if the current layout is a page view.
    // Korean: 현재 레이아웃이 페이지 뷰인지 확인합니다.
    final isPage = widget.type == PostsListType.page;

    if (isPage) {
      // English: For page view, use RefreshIndicator with SimplePageListView.
      // PageView itself handles scrolling, so SimplePageListView's internal
      // scroll-based pagination will trigger via its itemBuilder.
      // Korean: 페이지 뷰의 경우, RefreshIndicator와 SimplePageListView를 사용합니다.
      // PageView 자체가 스크롤을 처리하므로 SimplePageListView의 내부 스크롤 기반 페이지네이션은 itemBuilder를 통해 트리거됩니다.
      return RefreshIndicator(
        // too many refresh. so changed displacement value.
        displacement: 80,
        onRefresh: _handleRefresh,
        child: SimplePageListView<Post>(
          query: query,
          mainQuery: mainQuery,
          isPage: true,
          recentDocQuery: recentDocQuery,
          allowImplicitScrolling: true,
          listState: postsListStateProvider,
          emptyBuilder: _startPostBuilder,
          itemBuilder: _itemBuilder,
          refreshUpdatedDoc: true,
          updatedDocQuery: updatedPostQuery,
          updatedDocState: updatedPostIdProvider,
        ),
      );
    }
    // English: For other list types, use CustomScrollView with a sliver app bar and sliver list.
    // Korean: 다른 목록 유형의 경우, 슬라이버 앱 바와 슬라이버 목록이 있는 CustomScrollView를 사용합니다.
    return CustomScrollView(
      controller: _controller,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        PostsAppBar(isSliver: true),
        // English: Cupertino-style pull-to-refresh control.
        // Korean: Cupertino 스타일의 당겨서 새로고침 컨트롤입니다.
        CupertinoSliverRefreshControl(
            refreshTriggerPullDistance: 140, onRefresh: _handleRefresh),
        SimplePageListView<Post>(
          query: query,
          mainQuery: mainQuery,
          recentDocQuery: recentDocQuery,
          listState: postsListStateProvider,
          padding: switch (widget.type) {
            PostsListType.mixed =>
              // English: Specific bottom padding for mixed type.
              // Korean: mixed 타입에 대한 특정 하단 패딩입니다.
              const EdgeInsets.only(bottom: roundCardPadding),
            _ => null,
          },
          itemExtent: switch (widget.type) {
            // English: Calculate itemExtent for square type.
            // It's screenWidth, plus cardBottomPadding on smaller screens
            // to account for the SizedBox in BasicPostsItem.
            // Korean: square 타입에 대한 itemExtent를 계산합니다.
            // 화면 너비에 작은 화면에서는 BasicPostsItem의 SizedBox를 고려하여 cardBottomPadding을 더합니다.
            PostsListType.square => screenWidth +
                (screenWidth <= pcWidthBreakpoint ? cardBottomPadding : 0.0),
            // English: Calculate itemExtent for round type.
            // This is the height of the AspectRatio (16:9) within RoundPostsItem's content area,
            // plus roundCardPadding for its bottom margin.
            // Korean: round 타입에 대한 itemExtent를 계산합니다.
            // RoundPostsItem의 콘텐츠 영역 내 AspectRatio(16:9)의 높이에 하단 마진을 위한 roundCardPadding을 더합니다.
            PostsListType.round =>
              ((screenWidth - (2 * horizontalMargin)) * (9 / 16)) +
                  roundCardPadding,
            _ => null,
          },
          emptyBuilder: _startPostBuilder,
          itemBuilder: _itemBuilder,
          refreshUpdatedDoc: true,
          updatedDocQuery: updatedPostQuery,
          updatedDocState: updatedPostIdProvider,
          isSliver: true,
          // English: Pass the scroll controller to SimplePageListView for its internal pagination logic.
          // Korean: 내부 페이지네이션 로직을 위해 스크롤 컨트롤러를 SimplePageListView에 전달합니다.
          controller: _controller,
        )
      ],
    );
  }
}

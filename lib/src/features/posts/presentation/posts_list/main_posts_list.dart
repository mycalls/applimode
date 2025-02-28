import 'dart:async';

import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_app_bar/posts_app_bar.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/basic_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/round_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_posts_item.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';
import 'package:applimode_app/src/utils/updated_post_ids_list.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPostsList extends ConsumerStatefulWidget {
  const MainPostsList({
    super.key,
    this.type = PostsListType.square,
  });

  final PostsListType type;

  @override
  ConsumerState<MainPostsList> createState() => _MainPostsListState();
}

class _MainPostsListState extends ConsumerState<MainPostsList> {
  final ScrollController _controller = ScrollController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: mainPostsRefreshTimer), () {});
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  Widget _startPostBuilder(BuildContext context) =>
      Center(child: Text(context.loc.startFirstPost));

  Widget _itemBuilder(
      BuildContext context, int index, QueryDocumentSnapshot<Post> doc) {
    final post = doc.data();
    switch (widget.type) {
      case PostsListType.small:
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
        return BasicPostsItem(
          post: post,
          index: index,
        );
      case PostsListType.page:
        return BasicPostsItem(
          post: post,
          index: index,
          aspectRatio: MediaQuery.sizeOf(context).aspectRatio,
          isPage: true,
          // isTappable: false,
          showMainLabel: false,
        );
      case PostsListType.round:
        return RoundPostsItem(
          post: post,
          index: index,
        );
      case PostsListType.mixed:
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
    final query = ref.watch(postsRepositoryProvider).defaultPostsQuery();
    final mainQuery = ref.watch(postsRepositoryProvider).mainPostsQuery();
    final recentDocQuery = ref.watch(postsRepositoryProvider).recentPostQuery();
    final updatedPostQuery = ref.watch(postsRepositoryProvider).postsRef();
    final resetUpdatedDocIds =
        ref.watch(updatedPostIdsListProvider.notifier).removeAll;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalMargin = screenWidth > pcWidthBreakpoint
        ? ((screenWidth - pcWidthBreakpoint) / 2) + roundCardPadding
        : roundCardPadding;

    final isPage = widget.type == PostsListType.page;

    if (isPage) {
      return RefreshIndicator(
        // too many refresh. so changed displacement value.
        displacement: 80,
        onRefresh: () async {
          if (timer != null && timer!.isActive) {
            return;
          }
          ref.read(postsListStateProvider.notifier).set(nowToInt());
          timer = Timer(const Duration(seconds: mainPostsRefreshTimer), () {});
        },
        child: SimplePageListView<Post>(
          query: query,
          mainQuery: mainQuery,
          isPage: true,
          recentDocQuery: recentDocQuery,
          allowImplicitScrolling: true,
          listState: postsListStateProvider,
          emptyBuilder: _startPostBuilder,
          itemBuilder: _itemBuilder,
          refreshUpdatedDocs: true,
          updatedDocQuery: updatedPostQuery,
          resetUpdatedDocIds: resetUpdatedDocIds,
          updatedDocsState: updatedPostIdsListProvider,
        ),
      );
    }
    return CustomScrollView(
      controller: _controller,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        PostsAppBar(isSliver: true),
        CupertinoSliverRefreshControl(
            refreshTriggerPullDistance: 140,
            onRefresh: () async {
              if (timer != null && timer!.isActive) {
                return;
              }
              ref.read(postsListStateProvider.notifier).set(nowToInt());
              timer =
                  Timer(const Duration(seconds: mainPostsRefreshTimer), () {});
            }),
        SimplePageListView<Post>(
          query: query,
          mainQuery: mainQuery,
          recentDocQuery: recentDocQuery,
          listState: postsListStateProvider,
          padding: switch (widget.type) {
            PostsListType.mixed =>
              const EdgeInsets.only(bottom: roundCardPadding),
            _ => null,
          },
          itemExtent: switch (widget.type) {
            PostsListType.square =>
              MediaQuery.sizeOf(context).width + cardBottomPadding,
            PostsListType.round =>
              ((screenWidth - (2 * horizontalMargin)) * 9 / 16) +
                  roundCardPadding,
            _ => null,
          },
          emptyBuilder: _startPostBuilder,
          itemBuilder: _itemBuilder,
          refreshUpdatedDocs: true,
          updatedDocQuery: updatedPostQuery,
          resetUpdatedDocIds: resetUpdatedDocIds,
          updatedDocsState: updatedPostIdsListProvider,
          isSliver: true,
          controller: _controller,
        )
      ],
    );
  }
}

import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/round_posts_item.dart';
import 'package:applimode_app/src/utils/app_states/updated_post_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/basic_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_posts_item.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePostsScreen extends ConsumerWidget {
  const ProfilePostsScreen({
    super.key,
    required this.uid,
    this.type = PostsListType.square,
  });

  final String uid;
  final PostsListType type;

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
    final isPage = type == PostsListType.page;

    final updatedPostQuery = ref.watch(postsRepositoryProvider).postsRef();

    final query = ref.watch(postsRepositoryProvider).userPostsQuery(uid);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalMargin = screenWidth > pcWidthBreakpoint
        ? ((screenWidth - pcWidthBreakpoint) / 2) + roundCardPadding
        : roundCardPadding;

    return Scaffold(
      appBar: isPage
          ? AppBar(
              title: Text(context.loc.posts),
              forceMaterialTransparency: true,
              foregroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: kIsWeb ? false : true,
              leading: kIsWeb ? const WebBackButton() : null,
            )
          : null,
      body: isPage
          ? SimplePageListView(
              query: query,
              isPage: true,
              listState: postsListStateProvider,
              itemBuilder: _itemBuilder,
              refreshUpdatedDoc: true,
              updatedDocQuery: updatedPostQuery,
              updatedDocState: updatedPostIdProvider,
            )
          : CustomScrollView(
              slivers: [
                if (!isPage)
                  SliverAppBar(
                    floating: true,
                    title: Text(context.loc.posts),
                    automaticallyImplyLeading: kIsWeb ? false : true,
                    leading: kIsWeb ? const WebBackButton() : null,
                  ),
                SimplePageListView(
                  query: query,
                  listState: postsListStateProvider,
                  padding: switch (type) {
                    PostsListType.mixed =>
                      const EdgeInsets.only(bottom: roundCardPadding),
                    _ => null,
                  },
                  itemExtent: switch (type) {
                    PostsListType.square =>
                      MediaQuery.sizeOf(context).width + cardBottomPadding,
                    PostsListType.round =>
                      ((screenWidth - (2 * horizontalMargin)) * 9 / 16) +
                          roundCardPadding,
                    PostsListType.small => listSmallItemHeight,
                    _ => null,
                  },
                  itemBuilder: _itemBuilder,
                  refreshUpdatedDoc: true,
                  updatedDocQuery: updatedPostQuery,
                  updatedDocState: updatedPostIdProvider,
                  isSliver: true,
                )
              ],
            ),
      extendBodyBehindAppBar: isPage ? true : false,
      backgroundColor: isPage ? Colors.black : null,
    );
  }

/*
    return Scaffold(
        extendBodyBehindAppBar: isPage ? true : false,
        backgroundColor: isPage ? Colors.black : null,
        appBar: AppBar(
          automaticallyImplyLeading: kIsWeb ? false : true,
          leading: kIsWeb ? const WebBackButton() : null,
          title: Text(context.loc.posts),
          forceMaterialTransparency: isPage ? true : false,
          foregroundColor: isPage ? Colors.white : null,
          elevation: isPage ? 0 : null,
        ),
        body: switch (type) {
          PostsListType.page => SimplePageListView(
              query: query,
              isPage: true,
              listState: postsListStateProvider,
              itemBuilder: (context, index, doc) {
                final post = doc.data();
                return BasicPostsItem(
                  post: post,
                  index: index,
                  aspectRatio: MediaQuery.sizeOf(context).aspectRatio,
                  isPage: true,
                  // isTappable: false,
                  showMainLabel: false,
                );
              },
              refreshUpdatedDocs: true,
              updatedDocQuery: updatedPostQuery,
              resetUpdatedDocIds: resetUpdatedDocIds,
              updatedDocsState: updatedPostIdsListProvider,
            ),
          PostsListType.small ||
          PostsListType.square ||
          PostsListType.round ||
          PostsListType.mixed =>
            SimplePageListView(
              query: query,
              listState: postsListStateProvider,
              itemExtent: switch (type) {
                PostsListType.page => null,
                PostsListType.small => listSmallItemHeight,
                PostsListType.square =>
                  MediaQuery.sizeOf(context).width + cardBottomPadding,
                PostsListType.round =>
                  ((screenWidth - (2 * horizontalMargin)) * 9 / 16) +
                      roundCardPadding,
                PostsListType.mixed => null,
              },
              padding: switch (type) {
                PostsListType.page ||
                PostsListType.small ||
                PostsListType.square ||
                PostsListType.round =>
                  null,
                PostsListType.mixed =>
                  const EdgeInsets.only(bottom: roundCardPadding),
              },
              itemBuilder: (context, index, doc) {
                final post = doc.data();
                if (isSmall) {
                  return SmallPostsItem(
                    post: post,
                    index: index,
                  );
                }
                if (isRound) {
                  return RoundPostsItem(
                    post: post,
                    index: index,
                  );
                }
                if (isMixed) {
                  if (post.mainVideoUrl != null ||
                      (post.mainImageUrl != null &&
                          post.title.trim().isEmpty)) {
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
                return BasicPostsItem(
                  post: post,
                  index: index,
                );
              },
              refreshUpdatedDocs: true,
              updatedDocQuery: updatedPostQuery,
              resetUpdatedDocIds: resetUpdatedDocIds,
              updatedDocsState: updatedPostIdsListProvider,
            ),
        });
  }
  */
}

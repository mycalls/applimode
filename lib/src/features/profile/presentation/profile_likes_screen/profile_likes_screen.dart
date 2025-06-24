// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/app_states/list_state.dart';
import 'package:applimode_app/src/core/constants/constants.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/buttons/web_back_button.dart';
import 'package:applimode_app/src/common_widgets/async_value_widget.dart';
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';

// features
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:applimode_app/src/features/posts/application/providers/post_data_provider.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/posts_items/basic_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/posts_items/round_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/shared/posts_items/small_posts_item.dart';

class ProfileLikesScreen extends StatelessWidget {
  const ProfileLikesScreen({
    super.key,
    required this.uid,
    this.type = PostsListType.square,
  });

  final String uid;
  final PostsListType type;

  @override
  Widget build(BuildContext context) {
    final isPage = type == PostsListType.page;
    final isSmall = type == PostsListType.small;
    final isRound = type == PostsListType.round;
    final isMixed = type == PostsListType.mixed;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalMargin = screenWidth > pcWidthBreakpoint
        ? ((screenWidth - pcWidthBreakpoint) / 2) + roundCardPadding
        : roundCardPadding;

    return Scaffold(
      extendBodyBehindAppBar: isPage ? true : false,
      backgroundColor: isPage ? Colors.black : null,
      appBar: AppBar(
        automaticallyImplyLeading: kIsWeb ? false : true,
        leading: kIsWeb ? const WebBackButton() : null,
        title: Text(context.loc.likesPosts),
        forceMaterialTransparency: isPage ? true : false,
        foregroundColor: isPage ? Colors.white : null,
        elevation: isPage ? 0 : null,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final query =
              ref.watch(postLikesQueryProvider(uid: uid, isDislike: false));

          switch (type) {
            case PostsListType.page:
              return SimplePageListView(
                query: query,
                isPage: true,
                listState: postsListStateProvider,
                itemBuilder: (context, index, doc) {
                  final postLike = doc.data();
                  final postAsync =
                      ref.watch(postDataProvider(PostArgs(postLike.postId)));
                  return AsyncValueWidget(
                    value: postAsync,
                    data: (post) {
                      if (post == null) {
                        return const SizedBox.shrink();
                      }
                      return BasicPostsItem(
                        post: post,
                        index: index,
                        aspectRatio: MediaQuery.sizeOf(context).aspectRatio,
                        isPage: true,
                        // isTappable: false,
                        showMainLabel: false,
                      );
                    },
                  );
                },
              );
            case PostsListType.square ||
                  PostsListType.small ||
                  PostsListType.round ||
                  PostsListType.mixed:
              return SimplePageListView(
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
                  final postLike = doc.data();
                  final postAsync =
                      ref.watch(postDataProvider(PostArgs(postLike.postId)));
                  return AsyncValueWidget(
                    value: postAsync,
                    data: (post) {
                      if (post == null) {
                        return const SizedBox.shrink();
                      }
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
                  );
                },
              );
          }
        },
      ),
    );
  }
}

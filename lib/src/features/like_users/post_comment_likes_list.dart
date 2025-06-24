// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/app_states/list_state.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/async_value_widget.dart';
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';
import 'package:applimode_app/src/common_widgets/user_item.dart';

// features
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/comments/data/post_comment_likes_repository.dart';

class PostCommentLikesList extends ConsumerWidget {
  const PostCommentLikesList({
    super.key,
    required this.postCommentId,
    this.isDislike,
  });

  final String postCommentId;
  final bool? isDislike;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postCommentLikesQuery = ref.watch(postCommentLikesQueryProvider(
        commentId: postCommentId, isDislike: isDislike));
    return SafeArea(
      top: false,
      bottom: false,
      child: SimplePageListView(
        query: postCommentLikesQuery,
        listState: likesListStateProvider,
        isNoGridView: true,
        itemBuilder: (context, index, doc) {
          final postCommentLike = doc.data();
          final likeUser = ref.watch(appUserDataProvider(postCommentLike.uid));
          return AsyncValueWidget(
            value: likeUser,
            data: (likeUser) {
              if (likeUser == null) {
                return const SizedBox.shrink();
              }
              return UserItem(
                appUser: likeUser,
                profileImageSize: profileSizeBig,
                index: index,
              );
            },
          );
        },
      ),
    );
  }
}

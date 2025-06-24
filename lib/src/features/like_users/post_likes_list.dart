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
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';

class PostLikesList extends ConsumerWidget {
  const PostLikesList({
    super.key,
    required this.postId,
    this.isDislike,
  });

  final String postId;
  final bool? isDislike;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postLikesQuery =
        ref.watch(postLikesQueryProvider(postId: postId, isDislike: isDislike));

    return SafeArea(
      top: false,
      bottom: false,
      child: SimplePageListView(
        query: postLikesQuery,
        listState: likesListStateProvider,
        isNoGridView: true,
        itemBuilder: (context, index, doc) {
          final postLike = doc.data();
          final likeUser = ref.watch(appUserDataProvider(postLike.uid));
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

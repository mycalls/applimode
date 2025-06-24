// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/buttons/web_back_button.dart';

// features
import 'package:applimode_app/src/features/like_users/post_comment_likes_list.dart';
import 'package:applimode_app/src/features/like_users/post_likes_list.dart';

class LikeUsersScreen extends StatelessWidget {
  const LikeUsersScreen({
    super.key,
    this.isCommentLikes = false,
    this.postId,
    this.postCommentId,
    this.isDislike,
  });

  final bool isCommentLikes;
  final String? postId;
  final String? postCommentId;
  final bool? isDislike;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isDislike ?? false ? context.loc.dislikedBy : context.loc.likedBy),
        automaticallyImplyLeading: kIsWeb ? false : true,
        leading: kIsWeb ? const WebBackButton() : null,
      ),
      body: isCommentLikes
          ? PostCommentLikesList(
              postCommentId: postCommentId!,
              isDislike: isDislike,
            )
          : PostLikesList(
              postId: postId!,
              isDislike: isDislike,
            ),
    );
  }
}

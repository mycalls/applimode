import 'dart:developer' as dev;
import 'package:applimode_app/src/features/comments/data/post_comment_likes_repository.dart';
import 'package:applimode_app/src/features/comments/domain/post_comment_like.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_post_comment_like_data_provider.g.dart';

@riverpod
class UserPostCommentLikeData extends _$UserPostCommentLikeData {
  @override
  FutureOr<List<PostCommentLike>> build({
    required String commentId,
    required String uid,
  }) async {
    dev.log(
        'UserPostCommentLikeData (commentId: $commentId, uid: $uid): Build started.');
    final postCommentLikesRepository =
        ref.watch(postCommentLikesRepositoryProvider);
    final data = await postCommentLikesRepository.fetchPostCommentLikesByUser(
      commentId: commentId,
      uid: uid,
      isDislike: false,
    );
    return data;
  }

  void increaseOptimisticLike({
    required String id,
    // required String uid,
    required String postId,
    // required String commentId,
    required String commentWriterId,
    required String postWriterId,
    required String parentCommentId,
  }) {
    if (state.value != null && state.value!.isEmpty) {
      dev.log(
          'UserPostCommentLikeData (commentId: $commentId, uid: $uid): increase Optimistic Like');
      state = AsyncData([
        PostCommentLike(
          id: id,
          uid: uid,
          postId: postId,
          commentId: commentId,
          commentWriterId: commentWriterId,
          postWriterId: postWriterId,
          parentCommentId: parentCommentId,
          isDislike: false,
          createdAt: DateTime.now(),
        )
      ]);
    }
  }

  void decreaseOptimisticLike() {
    if (state.value != null && state.value!.isNotEmpty) {
      dev.log(
          'UserPostCommentLikeData (commentId: $commentId, uid: $uid): decrease Optimistic Like');
      state = AsyncData([]);
    }
  }

  Future<void> refresh() async {
    dev.log(
        'UserPostCommentLikeData (postId: $commentId, uid: $uid): Manual refresh triggered.');
    ref.invalidateSelf();
    // Ensure the rebuild completes before returning (optional)
    await future;
  }
}

import 'dart:developer' as dev;
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post_like.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_post_like_data_provider.g.dart';

@riverpod
class UserPostLikeData extends _$UserPostLikeData {
  @override
  FutureOr<List<PostLike>> build({
    required String postId,
    required String uid,
  }) async {
    dev.log('UserPostLikeData (postId: $postId, uid: $uid): Build started.');
    final postLikesRepository = ref.watch(postLikesRepositoryProvider);
    final data = await postLikesRepository.fetchPostLikesByUser(
      postId: postId,
      uid: uid,
      isDislike: false,
    );
    return data;
  }

  void increaseOptimisticLike(String id, String postWriterId) {
    if (state.value != null && state.value!.isEmpty) {
      dev.log(
          'UserPostLikeData (postId: $postId, uid: $uid): increase Optimistic Like');
      state = AsyncData([
        PostLike(
          id: id,
          uid: uid,
          postId: postId,
          postWriterId: postWriterId,
          isDislike: false,
          createdAt: DateTime.now(),
        )
      ]);
    }
  }

  void decreaseOptimisticLike() {
    if (state.value != null && state.value!.isNotEmpty) {
      dev.log(
          'UserPostLikeData (postId: $postId, uid: $uid): decrease Optimistic Like');
      state = AsyncData([]);
    }
  }

  Future<void> refresh() async {
    dev.log(
        'UserPostLikeData (postId: $postId, uid: $uid): Manual refresh triggered.');
    ref.invalidateSelf();
    // Ensure the rebuild completes before returning (optional)
    await future;
  }
}

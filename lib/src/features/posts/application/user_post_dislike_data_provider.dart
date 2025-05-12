import 'dart:developer' as dev;
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post_like.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_post_dislike_data_provider.g.dart';

@riverpod
class UserPostDislikeData extends _$UserPostDislikeData {
  @override
  FutureOr<List<PostLike>> build({
    required String postId,
    required String uid,
  }) async {
    dev.log('UserPostDislikeData (postId: $postId, uid: $uid): Build started.');
    final postLikesRepository = ref.watch(postLikesRepositoryProvider);
    final data = await postLikesRepository.fetchPostLikesByUser(
      postId: postId,
      uid: uid,
      isDislike: true,
    );
    return data;
  }

  void increaseOptimisticDislike(String id, String postWriterId) {
    if (state.value != null && state.value!.isEmpty) {
      dev.log(
          'UserPostDislikeData (postId: $postId, uid: $uid): increase Optimistic Dislike');
      state = AsyncData([
        PostLike(
          id: id,
          uid: uid,
          postId: postId,
          postWriterId: postWriterId,
          isDislike: true,
          createdAt: DateTime.now(),
        )
      ]);
    }
  }

  void decreaseOptimisticDislike() {
    if (state.value != null && state.value!.isNotEmpty) {
      dev.log(
          'UserPostDislikeData (postId: $postId, uid: $uid): decrease Optimistic Dislike');
      state = AsyncData([]);
    }
  }

  Future<void> refresh() async {
    dev.log(
        'UserPostDislikeData (postId: $postId, uid: $uid): Manual refresh triggered.');
    ref.invalidateSelf();
    // Ensure the rebuild completes before returning (optional)
    await future;
  }
}

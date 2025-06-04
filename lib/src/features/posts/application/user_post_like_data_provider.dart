// lib/src/features/posts/application/user_post_like_data_provider.dart

import 'dart:developer' as dev;

import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post_like.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_post_like_data_provider.g.dart';

// English: Provider to manage and fetch the like status of a specific post by a specific user.
// Korean: 특정 사용자에 의한 특정 게시물의 좋아요 상태를 관리하고 가져오는 프로바이더입니다.
@riverpod
class UserPostLikeData extends _$UserPostLikeData {
  @override
  FutureOr<List<PostLike>> build({
    required String postId,
    required String uid,
  }) async {
    // English: Log when the provider is disposed.
    // Korean: 프로바이더가 폐기될 때 로그를 기록합니다.
    ref.onDispose(() {
      dev.log('UserPostLikeData (postId: $postId, uid: $uid): Disposed.');
    });
    dev.log('UserPostLikeData (postId: $postId, uid: $uid): Build started.');
    final postLikesRepository = ref.watch(postLikesRepositoryProvider);
    final data = await postLikesRepository.fetchPostLikesByUser(
      postId: postId,
      uid: uid,
      isDislike: false,
    );
    return data;
  }

  // English: Optimistically adds a like record for the user.
  // Korean: 사용자에 대한 좋아요 기록을 낙관적으로 추가합니다.
  // Assumes a user can only like a post once. If already liked, this does nothing.
  // 사용자는 게시물에 한 번만 좋아요를 누를 수 있다고 가정합니다. 이미 좋아요를 누른 경우 아무 작업도 수행하지 않습니다.
  void increaseOptimisticLike(String id, String postWriterId) {
    if (state.hasValue && state.value!.isEmpty) {
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

  // English: Optimistically removes the like record for the user.
  // Korean: 사용자에 대한 좋아요 기록을 낙관적으로 제거합니다.
  // If not currently liked, this does nothing.
  // 현재 좋아요를 누르지 않은 경우 아무 작업도 수행하지 않습니다.
  void decreaseOptimisticLike() {
    if (state.hasValue && state.value!.isNotEmpty) {
      dev.log(
          'UserPostLikeData (postId: $postId, uid: $uid): decrease Optimistic Like');
      state = AsyncData([]);
    }
  }

  // English: Manually triggers a refresh of the user's like status for the post.
  // Korean: 게시물에 대한 사용자의 좋아요 상태를 수동으로 새로고침합니다.
  Future<void> refresh() async {
    dev.log(
        'UserPostLikeData (postId: $postId, uid: $uid): Manual refresh triggered.');
    // English: Invalidates the current provider state, causing it to rebuild and fetch fresh data.
    // Korean: 현재 프로바이더 상태를 무효화하여 다시 빌드하고 최신 데이터를 가져오도록 합니다.
    ref.invalidateSelf();
    // English: Optionally, await the future to ensure the rebuild completes before this method returns.
    // Korean: 선택적으로, 이 메소드가 반환되기 전에 재빌드가 완료되도록 future를 기다립니다.
    await future;
  }
}

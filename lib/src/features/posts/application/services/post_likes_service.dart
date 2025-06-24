// flutter
import 'package:flutter/foundation.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// features
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';

part 'post_likes_service.g.dart';

class PostLikesService {
  const PostLikesService(this.ref);

  final Ref ref;

  PostLikesRepository get postLikesRepository =>
      ref.read(postLikesRepositoryProvider);
  PostsRepository get postsRepository => ref.read(postsRepositoryProvider);
  AppUserRepository get appUserRepository =>
      ref.read(appUserRepositoryProvider);

  Future<void> increasePostLikeCount({
    required String id,
    required String uid,
    required String postId,
    required String postWriterId,
  }) async {
    await postsRepository.increaseLikeCount(postId);
    try {
      await appUserRepository.increaseLikeCount(postWriterId);
    } catch (e) {
      debugPrint('failed increasePostWriterLikeCount: ${e.toString()}');
    }
    await postLikesRepository.createPostLike(
      id: id,
      uid: uid,
      postId: postId,
      postWriterId: postWriterId,
      createdAt: DateTime.now(),
    );
  }

  Future<void> decreasePostLikeCount({
    required String id,
    required String postId,
    required String postWriterId,
  }) async {
    await postsRepository.decreaseLikeCount(postId);
    try {
      await appUserRepository.decreaseLikeCount(postWriterId);
    } catch (e) {
      debugPrint('failed decreasePostWriterLikeCount: ${e.toString()}');
    }
    await postLikesRepository.deletePostLike(id);
  }

  Future<void> increasePostDislikeCount({
    required String id,
    required String uid,
    required String postId,
    required String postWriterId,
  }) async {
    await postsRepository.increaseDislikeCount(postId);
    try {
      await appUserRepository.increaseDislikeCount(postWriterId);
    } catch (e) {
      debugPrint('failed increasePostWriterDislikeCount: ${e.toString()}');
    }
    await postLikesRepository.createPostLike(
      id: id,
      uid: uid,
      postId: postId,
      postWriterId: postWriterId,
      isDislike: true,
      createdAt: DateTime.now(),
    );
  }

  Future<void> decreasePostDislikeCount({
    required String id,
    required String postId,
    required String postWriterId,
  }) async {
    await postsRepository.decreaseDislikeCount(postId);
    try {
      await appUserRepository.decreaseDislikeCount(postWriterId);
    } catch (e) {
      debugPrint('failed decreasePostWriterDislikeCount: ${e.toString()}');
    }
    await postLikesRepository.deletePostLike(id);
  }
}

@riverpod
PostLikesService postLikesService(Ref ref) {
  return PostLikesService(ref);
}

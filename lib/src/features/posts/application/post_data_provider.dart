import 'dart:developer' as dev;
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_data_provider.g.dart';

@riverpod
class PostData extends _$PostData {
  @override
  FutureOr<Post?> build(PostArgs arg) async {
    ref.onDispose(() {
      dev.log('PostData id(${arg.postId}) disposed');
    });
    dev.log(
        'PostData id(${arg.postId}), initialPost(${arg.initialPost}): Build started.');
    if (arg.initialPost != null && arg.initialPost!.id == arg.postId) {
      dev.log("Using initialPost for ${arg.postId}");
      // arg.initialDocument가 null이 아님을 확신
      return arg.initialPost!;
    }
    dev.log("Fetching post ${arg.postId} from database...");
    final postsRepository = ref.watch(postsRepositoryProvider);
    final data = await postsRepository.fetchPost(arg.postId);
    return data;
  }

  void optimisticEdit(Post newPost) {
    if (newPost.id == arg.postId) {
      dev.log(
          'PostData id(${arg.postId}), initialPost(${arg.initialPost}): set Optimistic Edit');
      state = AsyncData(newPost);
    }
  }

  void optimisticBlock() {
    if (state.value != null) {
      dev.log('PostData id(${arg.postId}): set Optimistic Block');
      state = AsyncData(state.value!.copyWith(
        isBlock: true,
      ));
    }
  }

  void optimisticUnblock() {
    if (state.value != null) {
      dev.log('PostData id(${arg.postId}): set Optimistic Unblock');
      state = AsyncData(state.value!.copyWith(
        isBlock: false,
      ));
    }
  }

  void optimisticRecommend() {
    if (state.value != null) {
      dev.log('PostData id(${arg.postId}): set Optimistic Recommend');
      state = AsyncData(state.value!.copyWith(
        isRecommended: true,
      ));
    }
  }

  void optimisticUnrecommend() {
    if (state.value != null) {
      dev.log('PostData id(${arg.postId}): set Optimistic Unrecommend');
      state = AsyncData(state.value!.copyWith(
        isRecommended: false,
      ));
    }
  }

  void optimisticMain() {
    if (state.value != null) {
      dev.log('PostData id(${arg.postId}): set Optimistic Main');
      state = AsyncData(state.value!.copyWith(
        isHeader: true,
      ));
    }
  }

  void optimisticGeneral() {
    if (state.value != null) {
      dev.log('PostData id(${arg.postId}): set Optimistic General');
      state = AsyncData(state.value!.copyWith(
        isHeader: false,
      ));
    }
  }

  void optimisticIncreaseLike() {
    if (state.value != null) {
      dev.log('PostData id(${arg.postId}): set Optimistic Increase Like');
      state = AsyncData(state.value!.copyWith(
        likeCount: state.value!.likeCount + 1,
        sumCount: state.value!.sumCount + 1,
      ));
    }
  }

  void optimisticDecreaseLike() {
    if (state.value != null) {
      dev.log('PostData id(${arg.postId}): set Optimistic Decrease Like');
      state = AsyncData(state.value!.copyWith(
        likeCount: state.value!.likeCount - 1,
        sumCount: state.value!.sumCount - 1,
      ));
    }
  }

  void optimisticIncreaseDislike() {
    if (state.value != null) {
      dev.log('PostData id(${arg.postId}): set Optimistic Increase Dislike');
      state = AsyncData(state.value!.copyWith(
        dislikeCount: state.value!.dislikeCount + 1,
        sumCount: state.value!.sumCount - 1,
      ));
    }
  }

  void optimisticDecreaseDislike() {
    if (state.value != null) {
      dev.log('PostData id(${arg.postId}): set Optimistic Decrease Dislike');
      state = AsyncData(state.value!.copyWith(
        dislikeCount: state.value!.dislikeCount - 1,
        sumCount: state.value!.sumCount + 1,
      ));
    }
  }

  void optimisticIncreaseComment() {
    if (state.value != null) {
      dev.log('PostData id(${arg.postId}): set Optimistic Increase Comment');
      state = AsyncData(state.value!.copyWith(
        postCommentCount: state.value!.postCommentCount + 1,
      ));
    }
  }

  void optimisticDecreaseComment() {
    if (state.value != null) {
      dev.log('PostData id(${arg.postId}): set Optimistic Decrease Comment');
      state = AsyncData(state.value!.copyWith(
        postCommentCount: state.value!.postCommentCount - 1,
      ));
    }
  }

  Future<void> refresh() async {
    dev.log('PostData (${arg.postId}): Manual refresh triggered.');
    ref.invalidateSelf();
    // Ensure the rebuild completes before returning (optional)
    await future;
  }
}

// lib/src/features/posts/application/post_data_provider.dart

import 'dart:developer' as dev;

// external
import 'package:riverpod_annotation/riverpod_annotation.dart';

// features
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';

part 'post_data_provider.g.dart';

@riverpod
class PostData extends _$PostData {
  @override
  FutureOr<Post?> build(PostArgs arg) async {
    // English: Register a callback to log when the provider is disposed.
    // Korean: 프로바이더가 폐기될 때 로그를 기록하는 콜백을 등록합니다.
    ref.onDispose(() {
      dev.log('PostData id(${arg.postId}) disposed');
    });
    dev.log(
        'PostData id(${arg.postId}), initialPost(${arg.initialPost}): Build started.');

    // English: If an initialPost is provided and its ID matches, use it directly to avoid a database fetch.
    // Korean: initialPost가 제공되고 ID가 일치하면 데이터베이스 조회를 피하기 위해 직접 사용합니다.
    if (arg.initialPost != null && arg.initialPost!.id == arg.postId) {
      dev.log("Using initialPost for ${arg.postId}");
      // initialPost is non-null and its ID matches arg.postId here
      return arg.initialPost!;
    }

    // English: If no suitable initialPost is available, fetch the post from the repository.
    // Korean: 적절한 initialPost가 없는 경우, 저장소에서 게시물을 가져옵니다.
    dev.log("Fetching post ${arg.postId} from database...");
    final postsRepository = ref.watch(postsRepositoryProvider);
    final data = await postsRepository.fetchPost(arg.postId);
    return data;
  }

  // English: Helper method to apply optimistic updates to the current state.
  // Korean: 현재 상태에 낙관적 업데이트를 적용하기 위한 헬퍼 메소드입니다.
  // Helper method for optimistic updates
  void _optimisticallyUpdateState(
    String actionDescription,
    Post Function(Post currentPost) updater,
  ) {
    final currentPost = state.value;
    if (currentPost != null) {
      dev.log('PostData id(${arg.postId}): $actionDescription');
      state = AsyncData(updater(currentPost));
    } else {
      dev.log(
          'PostData id(${arg.postId}): $actionDescription attempted but state was null.');
    }
  }

  // English: Optimistically updates the state with a new Post object if IDs match.
  // Korean: ID가 일치하면 새 Post 객체로 상태를 낙관적으로 업데이트합니다.
  void optimisticEdit(Post newPost) {
    if (newPost.id == arg.postId) {
      dev.log(
          'PostData id(${arg.postId}), initialPost(${arg.initialPost}): set Optimistic Edit');
      state = AsyncData(newPost);
    }
  }

  // English: Optimistically marks the post as blocked.
  // Korean: 게시물을 차단된 것으로 낙관적으로 표시합니다.
  void optimisticBlock() {
    _optimisticallyUpdateState(
      'set Optimistic Block',
      (post) => post.copyWith(isBlock: true),
    );
  }

  // English: Optimistically unmarks the post as blocked.
  // Korean: 게시물의 차단 표시를 낙관적으로 해제합니다.
  void optimisticUnblock() {
    _optimisticallyUpdateState(
      'set Optimistic Unblock',
      (post) => post.copyWith(isBlock: false),
    );
  }

  // English: Optimistically marks the post as recommended.
  // Korean: 게시물을 추천된 것으로 낙관적으로 표시합니다.
  void optimisticRecommend() {
    _optimisticallyUpdateState(
      'set Optimistic Recommend',
      (post) => post.copyWith(isRecommended: true),
    );
  }

  // English: Optimistically unmarks the post as recommended.
  // Korean: 게시물의 추천 표시를 낙관적으로 해제합니다.
  void optimisticUnrecommend() {
    _optimisticallyUpdateState(
      'set Optimistic Unrecommend',
      (post) => post.copyWith(isRecommended: false),
    );
  }

  // English: Optimistically marks the post as a main/header post.
  // Korean: 게시물을 메인/헤더 게시물로 낙관적으로 표시합니다.
  void optimisticMain() {
    _optimisticallyUpdateState(
      'set Optimistic Main',
      (post) => post.copyWith(isHeader: true),
    );
  }

  // English: Optimistically marks the post as a general post (not main/header).
  // Korean: 게시물을 일반 게시물(메인/헤더 아님)로 낙관적으로 표시합니다.
  void optimisticGeneral() {
    _optimisticallyUpdateState(
      'set Optimistic General',
      (post) => post.copyWith(isHeader: false),
    );
  }

  // English: Optimistically increases the like count and sum count.
  // Korean: 좋아요 수와 합계 수를 낙관적으로 증가시킵니다.
  void optimisticIncreaseLike() {
    _optimisticallyUpdateState(
      'set Optimistic Increase Like',
      (post) => post.copyWith(
        likeCount: post.likeCount + 1,
        sumCount: post.sumCount + 1,
      ),
    );
  }

  // English: Optimistically decreases the like count and sum count.
  // Korean: 좋아요 수와 합계 수를 낙관적으로 감소시킵니다.
  void optimisticDecreaseLike() {
    _optimisticallyUpdateState(
      'set Optimistic Decrease Like',
      (post) => post.copyWith(
        likeCount: post.likeCount - 1,
        sumCount: post.sumCount - 1,
      ),
    );
  }

  // English: Optimistically increases the dislike count and adjusts sum count.
  // Korean: 싫어요 수를 낙관적으로 증가시키고 합계 수를 조정합니다.
  void optimisticIncreaseDislike() {
    _optimisticallyUpdateState(
      'set Optimistic Increase Dislike',
      (post) => post.copyWith(
        dislikeCount: post.dislikeCount + 1,
        sumCount: post.sumCount - 1,
      ),
    );
  }

  // English: Optimistically decreases the dislike count and adjusts sum count.
  // Korean: 싫어요 수를 낙관적으로 감소시키고 합계 수를 조정합니다.
  void optimisticDecreaseDislike() {
    _optimisticallyUpdateState(
      'set Optimistic Decrease Dislike',
      (post) => post.copyWith(
        dislikeCount: post.dislikeCount - 1,
        sumCount: post.sumCount + 1,
      ),
    );
  }

  // English: Optimistically increases the comment count for the post.
  // Korean: 게시물의 댓글 수를 낙관적으로 증가시킵니다.
  void optimisticIncreaseComment() {
    _optimisticallyUpdateState(
      'set Optimistic Increase Comment',
      (post) => post.copyWith(postCommentCount: post.postCommentCount + 1),
    );
  }

  // English: Optimistically decreases the comment count for the post.
  // Korean: 게시물의 댓글 수를 낙관적으로 감소시킵니다.
  void optimisticDecreaseComment() {
    _optimisticallyUpdateState(
      'set Optimistic Decrease Comment',
      (post) => post.copyWith(postCommentCount: post.postCommentCount - 1),
    );
  }

  // English: Manually triggers a refresh of the post data.
  // Korean: 게시물 데이터를 수동으로 새로고침합니다.
  Future<void> refresh() async {
    dev.log('PostData (${arg.postId}): Manual refresh triggered.');
    // English: Invalidates the current provider state, causing it to rebuild.
    // Korean: 현재 프로바이더 상태를 무효화하여 다시 빌드하도록 합니다.
    ref.invalidateSelf();
    // English: Optionally, await the future to ensure the rebuild completes before this method returns.
    // Korean: 선택적으로, 이 메소드가 반환되기 전에 재빌드가 완료되도록 future를 기다립니다.
    await future;
  }
}

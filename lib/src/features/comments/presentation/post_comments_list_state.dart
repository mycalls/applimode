// external
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_comments_list_state.g.dart';

class PostCommentsListState {
  const PostCommentsListState({
    this.byCreatedAt = true,
    this.byCommentCount = false,
    this.byLikeCount = false,
    this.byDislikeCount = false,
    this.bySumCount = false,
  });

  final bool byCreatedAt;
  final bool byCommentCount;
  final bool byLikeCount;
  final bool byDislikeCount;
  final bool bySumCount;
}

@riverpod
class PostCommentsListStateController
    extends _$PostCommentsListStateController {
  @override
  PostCommentsListState build() {
    return const PostCommentsListState();
  }

  void byCreatedAt() {
    state = const PostCommentsListState();
  }

  void byCommentCount() {
    state = const PostCommentsListState(
      byCreatedAt: false,
      byCommentCount: true,
    );
  }

  void byLikeCount() {
    state = const PostCommentsListState(
      byCreatedAt: false,
      byLikeCount: true,
    );
  }

  void byDislikeCount() {
    state = const PostCommentsListState(
      byCreatedAt: false,
      byDislikeCount: true,
    );
  }

  void bySumCount() {
    state = const PostCommentsListState(
      byCreatedAt: false,
      bySumCount: true,
    );
  }
}

// lib/src/core/app_states/list_state.dart

// external
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_state.g.dart';

@riverpod
class PostsListState extends _$PostsListState {
  @override
  int build() {
    return 0;
  }

  void set(int value) {
    state = value;
  }
}

@riverpod
class CommentsListState extends _$CommentsListState {
  @override
  int build() {
    return 0;
  }

  void set(int value) {
    state = value;
  }
}

@riverpod
class LikesListState extends _$LikesListState {
  @override
  int build() {
    return 0;
  }

  void set(int value) {
    state = value;
  }
}

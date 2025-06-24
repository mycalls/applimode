// lib/src/core/app_states/posts_item_playing_state.dart

// external
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_item_playing_state.g.dart';

@Riverpod(keepAlive: true)
class PostsItemPlayingState extends _$PostsItemPlayingState {
  @override
  bool build() {
    return true;
  }

  void setTrue() {
    state = true;
  }

  void setFalse() {
    state = false;
  }

  void setFalseAndTrue() {
    state = false;
    state = true;
  }
}

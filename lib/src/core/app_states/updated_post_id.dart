// lib/src/core/app_states/updated_post_id.dart

// external
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'updated_post_id.g.dart';

@riverpod
class UpdatedPostId extends _$UpdatedPostId {
  @override
  String? build() {
    return null;
  }

  void set(String id) {
    state = id;
    state = null;
  }

  void reset() {}
}

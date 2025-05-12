import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'updated_comment_id.g.dart';

@riverpod
class UpdatedCommentId extends _$UpdatedCommentId {
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

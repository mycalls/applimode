import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'updated_user_id.g.dart';

@riverpod
class UpdatedUserId extends _$UpdatedUserId {
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

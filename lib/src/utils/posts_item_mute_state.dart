import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_item_mute_state.g.dart';

@Riverpod(keepAlive: true)
class PostsItemMuteState extends _$PostsItemMuteState {
  @override
  bool build() {
    return ref.watch(adminSettingsProvider).isPostsItemVideoMute;
  }

  void setTrue() {
    state = true;
  }

  void setFalse() {
    state = false;
  }
}

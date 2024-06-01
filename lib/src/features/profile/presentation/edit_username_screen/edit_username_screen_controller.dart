import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/profile/application/profile_service.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_username_screen_controller.g.dart';

@riverpod
class EditUsernameScreenController extends _$EditUsernameScreenController {
  // ignore: avoid_public_notifier_properties
  Object? key;
  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<bool> submit(String displayName) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final newState = await AsyncValue.guard(() => ProfileService(ref)
        .editUsername(uid: user.uid, displayName: displayName));
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('editUsername: ${state.error.toString()}');
      return false;
    }

    ref.invalidate(writerFutureProvider);
    ref.invalidate(appUserFutureProvider);

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }
}

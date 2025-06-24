// flutter
import 'package:flutter/widgets.dart';

// external
import 'package:riverpod_annotation/riverpod_annotation.dart';

// features
import 'package:applimode_app/src/features/profile/application/profile_service.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';

part 'change_email_screen_controller.g.dart';

@riverpod
class ChangeEmailScreenController extends _$ChangeEmailScreenController {
// ignore: avoid_public_notifier_properties
  Object? key;
  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<bool> changeEmail({
    required String newEmail,
    required String password,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null || user.email == null) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final newState = await AsyncValue.guard(() => ProfileService(ref)
        .changeEmail(
            currentEmail: user.email!, newEmail: newEmail, password: password));
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('changeEmail: ${state.error.toString()}');
      return false;
    }

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }
}

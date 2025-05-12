import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_bio_screen_controller.g.dart';

@riverpod
class EditBioScreenController extends _$EditBioScreenController {
  // ignore: avoid_public_notifier_properties
  Object? key;
  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<bool> submit(String bio) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final newState = await AsyncValue.guard(() =>
        ref.read(appUserRepositoryProvider).updateBio(uid: user.uid, bio: bio));
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('bioSubmit: ${state.error.toString()}');
      return false;
    }

    ref.read(appUserDataProvider(user.uid).notifier).refresh();

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }
}

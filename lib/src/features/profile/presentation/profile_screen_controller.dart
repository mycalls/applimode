// flutter
import 'package:flutter/widgets.dart';

// external
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:applimode_app/src/core/app_states/list_state.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/now_to_int.dart';

// features
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/authentication/application/delete_account_service.dart';

part 'profile_screen_controller.g.dart';

@riverpod
class ProfileScreenController extends _$ProfileScreenController {
// ignore: avoid_public_notifier_properties
  Object? key;

  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<void> deleteAccount() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    final key = this.key;
    final newState = await AsyncValue.guard(() =>
        ref.read(deleteAccountServiceProvider).deleteAccount(uid: user.uid));

    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('deleteAccount: ${state.error.toString()}');
      return;
    }

    ref.invalidate(authStateChangesProvider);
    ref.read(appUserDataProvider(user.uid).notifier).refresh();
    ref.read(postsListStateProvider.notifier).set(nowToInt());
    ref.read(commentsListStateProvider.notifier).set(nowToInt());
    ref.read(likesListStateProvider.notifier).set(nowToInt());
    // ref.invalidate(mainPostsFutureProvider);

    ref.read(goRouterProvider).go(ScreenPaths.home);
  }
}

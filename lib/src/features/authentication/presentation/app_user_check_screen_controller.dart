import 'package:applimode_app/src/features/authentication/application/app_user_check_service.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_user_check_screen_controller.g.dart';

@riverpod
class AppUserCheckScreenController extends _$AppUserCheckScreenController {
// ignore: avoid_public_notifier_properties
  Object? key;

  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<void> initializeAppUsr() async {
    final authRepository = ref.read(authRepositoryProvider);
    final user = authRepository.currentUser;
    if (user == null) {
      // Go to sign in screen
      ref.read(goRouterProvider).go(ScreenPaths.firebaseSignIn);
      return;
    }

    state = const AsyncLoading();
    final key = this.key;
    final appUser = await ref.read(appUserDataProvider(user.uid).future);
    if (appUser == null) {
      final appUserCheckService = ref.read(appUserCheckServiceProvider);
      final newState = await AsyncValue.guard(
          () => appUserCheckService.initializeAppUser(user.uid));
      if (key == this.key) {
        state = newState;
      }
    }
  }
}

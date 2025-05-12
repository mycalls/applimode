import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/utils/fcm_service.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'like_comment_noti_button_controller.g.dart';

@riverpod
class LikeCommentNotiButtonController
    extends _$LikeCommentNotiButtonController {
  // ignore: avoid_public_notifier_properties
  Object? key;

  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<bool> updateToken() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('user is not exist'), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    final fcmService = ref.read(fcmServiceProvider);

    final token = await fcmService.fcmToken;

    if (token == null) {
      state = AsyncError(Exception('token error'), StackTrace.current);
      return false;
    }

    final key = this.key;
    final newState = await AsyncValue.guard(() async {
      await ref.read(appUserRepositoryProvider).updateFcmToken(
            uid: user.uid,
            token: token,
          );
    });

    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('updateTokenError: ${state.error.toString()}');
      return false;
    }

    ref.read(appUserDataProvider(user.uid).notifier).refresh();
    return true;
  }

  Future<bool> tokenToEmpty() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('user is not exist'), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    final key = this.key;
    final newState = await AsyncValue.guard(() async {
      ref.read(appUserRepositoryProvider).updateFcmToken(
            uid: user.uid,
            token: '',
          );
    });

    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('tokenToEmptyError: ${state.error.toString()}');
      return false;
    }

    ref.read(appUserDataProvider(user.uid).notifier).refresh();
    return true;
  }
}

// flutter
import 'package:flutter/foundation.dart';

// external
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:applimode_app/src/core/app_states/list_state.dart';
import 'package:applimode_app/src/core/app_states/upload_progress_state.dart';

// utils
import 'package:applimode_app/src/utils/now_to_int.dart';

// features
import 'package:applimode_app/src/features/profile/application/profile_service.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';

part 'profile_app_bar_more_controller.g.dart';

@riverpod
class ProfileAppBarMoreController extends _$ProfileAppBarMoreController {
// ignore: avoid_public_notifier_properties
  Object? key;

  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<void> changeProfileImage({
    XFile? xFile,
    String? mediaType,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('Login is required.'), StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    final key = this.key;
    final newState =
        await AsyncValue.guard(() => ProfileService(ref).changeProfileImage(
              uid: user.uid,
              xFile: xFile,
              mediaType: mediaType,
            ));

    if (key == this.key) {
      state = newState;
    }

    ref.read(appUserDataProvider(user.uid).notifier).refresh();
    ref.invalidate(uploadProgressStateProvider);
  }

  Future<void> changeStoryImage({
    XFile? xFile,
    String? mediaType,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('Login is required.'), StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    final key = this.key;
    final newState =
        await AsyncValue.guard(() => ProfileService(ref).changeStoryImage(
              uid: user.uid,
              xFile: xFile,
              mediaType: mediaType,
            ));

    if (key == this.key) {
      state = newState;
    }

    ref.read(appUserDataProvider(user.uid).notifier).refresh();
    ref.invalidate(uploadProgressStateProvider);
  }

  Future<bool> blockAppUser(String uid) async {
    final appUserRepository = ref.read(appUserRepositoryProvider);
    state = const AsyncLoading();
    final key = this.key;
    final newState =
        await AsyncValue.guard(() => appUserRepository.blockAppUser(uid));
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('blockAppUser: ${state.error.toString()}');
      return false;
    }

    ref.read(appUserDataProvider(uid).notifier).refresh();
    ref.read(postsListStateProvider.notifier).set(nowToInt());

    return true;
  }

  Future<bool> unblockAppUser(String uid) async {
    final appUserRepository = ref.read(appUserRepositoryProvider);
    state = const AsyncLoading();
    final key = this.key;
    final newState =
        await AsyncValue.guard(() => appUserRepository.unblockAppUser(uid));
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('unblockAppUser: ${state.error.toString()}');
      return false;
    }

    ref.read(appUserDataProvider(uid).notifier).refresh();
    ref.read(postsListStateProvider.notifier).set(nowToInt());

    return true;
  }
}

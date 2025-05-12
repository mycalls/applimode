import 'dart:developer' as dev;
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_user_data_provider.g.dart';

@riverpod
class AppUserData extends _$AppUserData {
  @override
  FutureOr<AppUser?> build(String appUserId) async {
    dev.log('AppUserData ($appUserId): Build started.');
    final appUserRepository = ref.watch(appUserRepositoryProvider);
    final appUser = await appUserRepository.fetchAppUser(appUserId);
    return appUser;
  }

  void increaseOptimisticLike() {
    if (state.value != null) {
      dev.log('AppUserData ($appUserId): increase Optimistic Like');
      state = AsyncData(state.value!.copyWith(
        likeCount: state.value!.likeCount + 1,
        sumCount: state.value!.sumCount + 1,
      ));
    }
  }

  void decreaseOptimisticLike() {
    if (state.value != null) {
      dev.log('AppUserData ($appUserId): decrease Optimistic Like');
      state = AsyncData(state.value!.copyWith(
        likeCount: state.value!.likeCount - 1,
        sumCount: state.value!.sumCount - 1,
      ));
    }
  }

  void increaseOptimisticDislike() {
    dev.log('AppUserData ($appUserId): increase Optimistic Dislike');
    if (state.value != null) {
      state = AsyncData(state.value!.copyWith(
        dislikeCount: state.value!.dislikeCount + 1,
        sumCount: state.value!.sumCount - 1,
      ));
    }
  }

  void decreaseOptimisticDislike() {
    dev.log('AppUserData ($appUserId): decrease Optimistic Dislike');
    if (state.value != null) {
      state = AsyncData(state.value!.copyWith(
        dislikeCount: state.value!.dislikeCount - 1,
        sumCount: state.value!.sumCount + 1,
      ));
    }
  }

  Future<void> refresh() async {
    dev.log('AppUserData ($appUserId): Manual refresh triggered.');
    ref.invalidateSelf();
    // Ensure the rebuild completes before returning (optional)
    await future;
  }
}

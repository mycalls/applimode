// lib/src/features/authentication/application/app_user_data_provider.dart

import 'dart:developer' as dev;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';

part 'app_user_data_provider.g.dart';

// Provider for fetching and managing AppUser data.
// It takes an `appUserId` as a parameter to fetch data for a specific user.
// AppUser 데이터를 가져오고 관리하기 위한 프로바이더입니다.
// 특정 사용자의 데이터를 가져오기 위해 `appUserId`를 매개변수로 받습니다.
@riverpod
class AppUserData extends _$AppUserData {
  // Builds the initial state by fetching the AppUser data for the given `appUserId`.
  // The `appUserId` parameter from `build` is automatically available as an instance field
  // (e.g., `this.appUserId` or simply `appUserId`) in other methods of this class
  // due to Riverpod's code generation.
  //
  // 주어진 `appUserId`에 대한 AppUser 데이터를 가져와서 초기 상태를 빌드합니다.
  // `build` 메소드의 `appUserId` 매개변수는 Riverpod 코드 생성에 의해
  // 이 클래스의 다른 메소드에서 인스턴스 필드(예: `this.appUserId` 또는 그냥 `appUserId`)로 자동 사용 가능합니다.
  @override
  FutureOr<AppUser?> build(String appUserId) async {
    dev.log('AppUserData ($appUserId): Build started.');
    final appUserRepository = ref.watch(appUserRepositoryProvider);
    final appUser = await appUserRepository.fetchAppUser(appUserId);
    return appUser;
  }

  // Optimistically increases the like count and sum count in the local state.
  // A backend update should follow this optimistic update.
  // 로컬 상태에서 좋아요 수와 합계 수를 낙관적으로 증가시킵니다.
  // 이 낙관적 업데이트 이후에는 백엔드 업데이트가 이루어져야 합니다.
  void increaseOptimisticLike() {
    // Only update if the current state has a value.
    // 현재 상태에 값이 있는 경우에만 업데이트합니다.
    if (state.hasValue) {
      dev.log('AppUserData ($appUserId): increase Optimistic Like');
      state = AsyncData(state.value!.copyWith(
        // state.value is non-null if state.hasValue is true
        likeCount: state.value!.likeCount + 1,
        sumCount: state.value!.sumCount + 1,
      ));
    }
  }

  // Optimistically decreases the like count and sum count in the local state.
  // A backend update should follow this optimistic update.
  // 로컬 상태에서 좋아요 수와 합계 수를 낙관적으로 감소시킵니다.
  // 이 낙관적 업데이트 이후에는 백엔드 업데이트가 이루어져야 합니다.
  void decreaseOptimisticLike() {
    if (state.hasValue) {
      dev.log('AppUserData ($appUserId): decrease Optimistic Like');
      state = AsyncData(state.value!.copyWith(
        // state.value is non-null if state.hasValue is true
        likeCount: state.value!.likeCount - 1,
        sumCount: state.value!.sumCount - 1,
      ));
    }
  }

  // Optimistically increases the dislike count and decreases the sum count in the local state.
  // A backend update should follow this optimistic update.
  // 로컬 상태에서 싫어요 수를 낙관적으로 증가시키고 합계 수를 감소시킵니다.
  // 이 낙관적 업데이트 이후에는 백엔드 업데이트가 이루어져야 합니다.
  void increaseOptimisticDislike() {
    if (state.hasValue) {
      dev.log('AppUserData ($appUserId): increase Optimistic Dislike');
      state = AsyncData(state.value!.copyWith(
        // state.value is non-null if state.hasValue is true
        dislikeCount: state.value!.dislikeCount + 1,
        sumCount: state.value!.sumCount - 1,
      ));
    }
  }

  // Optimistically decreases the dislike count and increases the sum count in the local state.
  // A backend update should follow this optimistic update.
  // 로컬 상태에서 싫어요 수를 낙관적으로 감소시키고 합계 수를 증가시킵니다.
  // 이 낙관적 업데이트 이후에는 백엔드 업데이트가 이루어져야 합니다.
  void decreaseOptimisticDislike() {
    if (state.hasValue) {
      dev.log('AppUserData ($appUserId): decrease Optimistic Dislike');
      state = AsyncData(state.value!.copyWith(
        // state.value is non-null if state.hasValue is true
        dislikeCount: state.value!.dislikeCount - 1,
        sumCount: state.value!.sumCount + 1,
      ));
    }
  }

  // Manually refreshes the AppUser data by invalidating the provider.
  // This will cause the `build` method to re-execute.
  // 프로바이더를 무효화하여 AppUser 데이터를 수동으로 새로 고칩니다.
  // 이렇게 하면 `build` 메소드가 다시 실행됩니다.
  Future<void> refresh() async {
    dev.log('AppUserData ($appUserId): Manual refresh triggered.');
    ref.invalidateSelf();
    // Ensure the rebuild completes before returning (optional)
    await future;
  }
}

// lib/src/features/posts/presentation/posts_drawer/like_comment_noti_button_controller.dart

// flutter
import 'package:flutter/widgets.dart';

// external
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:applimode_app/src/core/fcm/fcm_service.dart';

// features
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';

part 'like_comment_noti_button_controller.g.dart';

// English: Controller for managing the FCM token update logic related to like/comment notifications.
// It handles the asynchronous operations of fetching the FCM token and updating it in the user's profile.
// Korean: 좋아요/댓글 알림과 관련된 FCM 토큰 업데이트 로직을 관리하는 컨트롤러입니다.
// FCM 토큰을 가져오고 사용자 프로필에 업데이트하는 비동기 작업을 처리합니다.
@riverpod
class LikeCommentNotiButtonController
    extends _$LikeCommentNotiButtonController {
  // ignore: avoid_public_notifier_properties
  // English: A key to ensure that state updates are applied only if the controller instance hasn't been disposed and recreated.
  // Korean: 컨트롤러 인스턴스가 폐기되고 다시 생성되지 않은 경우에만 상태 업데이트가 적용되도록 보장하는 키입니다.
  // ignore: avoid_public_notifier_properties
  Object? key;

  @override
  FutureOr<void> build() {
    // English: Initialize the key when the controller is built.
    // Korean: 컨트롤러가 빌드될 때 키를 초기화합니다.
    key = Object();
    // English: Nullify the key when the controller is disposed to prevent updates on stale instances.
    // Korean: 컨트롤러가 폐기될 때 키를 null로 만들어 오래된 인스턴스에 대한 업데이트를 방지합니다.
    ref.onDispose(() => key = null);
    // Note: The initial state is AsyncData(null) by default for FutureOr<void>.
    // 참고: 초기 상태는 FutureOr<void>에 대해 기본적으로 AsyncData(null)입니다.
  }

  // English: Updates the user's FCM token in their profile.
  // Returns true if successful, false otherwise.
  // Korean: 사용자 프로필의 FCM 토큰을 업데이트합니다.
  // 성공하면 true를, 그렇지 않으면 false를 반환합니다.
  Future<bool> updateToken() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      // English: Set error state if the user is not authenticated.
      // Korean: 사용자가 인증되지 않은 경우 오류 상태를 설정합니다.
      state = AsyncError(
          Exception('User is not authenticated.'), StackTrace.current);
      return false;
    }

    // English: Set state to loading before performing the async operation.
    // Korean: 비동기 작업을 수행하기 전에 상태를 로딩 중으로 설정합니다.
    state = const AsyncLoading();

    final fcmService = ref.read(fcmServiceProvider);
    final String? token;
    try {
      token = await fcmService.fcmToken;
    } catch (e, st) {
      // English: Handle potential errors during FCM token retrieval.
      // Korean: FCM 토큰 검색 중 발생할 수 있는 오류를 처리합니다.
      state = AsyncError(Exception('Failed to get FCM token: $e'), st);
      debugPrint('FCM token retrieval error: $e');
      return false;
    }

    if (token == null) {
      // English: Set error state if the FCM token could not be retrieved.
      // Korean: FCM 토큰을 검색할 수 없는 경우 오류 상태를 설정합니다.
      state = AsyncError(Exception('FCM token is null.'), StackTrace.current);
      return false;
    }

    // English: Store the current key to compare later, ensuring the operation belongs to this controller instance.
    // Korean: 나중에 비교하기 위해 현재 키를 저장하여 작업이 이 컨트롤러 인스턴스에 속하는지 확인합니다.
    final currentKey = key;
    // English: Perform the Firestore update operation.
    // Korean: Firestore 업데이트 작업을 수행합니다.
    final newState = await AsyncValue.guard(() async {
      await ref.read(appUserRepositoryProvider).updateFcmToken(
            uid: user.uid,
            token: token!,
          );
    });

    // English: Only update state if the controller instance is still the same.
    // Korean: 컨트롤러 인스턴스가 여전히 동일한 경우에만 상태를 업데이트합니다.
    if (currentKey == key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('updateTokenError: ${state.error.toString()}');
      return false;
    }

    // English: Refresh user data to reflect changes if the operation was successful and state is not an error.
    // Korean: 작업이 성공했고 상태가 오류가 아닌 경우 변경 사항을 반영하기 위해 사용자 데이터를 새로 고칩니다.
    // (Checking !state.hasError again, though covered by the above, is a safeguard if state was modified elsewhere unexpectedly)
    if (!state.hasError) {
      ref.read(appUserDataProvider(user.uid).notifier).refresh();
      return true;
    }
    return false; // Should be covered by state.hasError check above
  }

  // English: Clears the user's FCM token in their profile by setting it to an empty string.
  // Returns true if successful, false otherwise.
  // Korean: 사용자 프로필의 FCM 토큰을 빈 문자열로 설정하여 지웁니다.
  // 성공하면 true를, 그렇지 않으면 false를 반환합니다.
  Future<bool> tokenToEmpty() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      // English: Set error state if the user is not authenticated.
      // Korean: 사용자가 인증되지 않은 경우 오류 상태를 설정합니다.
      state = AsyncError(
          Exception('User is not authenticated.'), StackTrace.current);
      return false;
    }

    // English: Set state to loading.
    // Korean: 상태를 로딩 중으로 설정합니다.
    state = const AsyncLoading();

    // English: Store the current key for instance validation.
    // Korean: 인스턴스 유효성 검사를 위해 현재 키를 저장합니다.
    final currentKey = key;
    // English: Perform the Firestore update operation to clear the token.
    // Korean: 토큰을 지우기 위해 Firestore 업데이트 작업을 수행합니다.
    final newState = await AsyncValue.guard(() async {
      // Using await here as updateFcmToken is async
      await ref.read(appUserRepositoryProvider).updateFcmToken(
            uid: user.uid,
            token: '', // Setting token to empty
          );
    });

    // English: Only update state if the controller instance is still the same.
    // Korean: 컨트롤러 인스턴스가 여전히 동일한 경우에만 상태를 업데이트합니다.
    if (currentKey == key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('tokenToEmptyError: ${state.error.toString()}');
      return false;
    }

    // English: Refresh user data if the operation was successful and state is not an error.
    // Korean: 작업이 성공했고 상태가 오류가 아닌 경우 사용자 데이터를 새로 고칩니다.
    if (!state.hasError) {
      ref.read(appUserDataProvider(user.uid).notifier).refresh();
      return true;
    }
    return false; // Should be covered
  }
}

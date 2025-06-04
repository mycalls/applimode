// lib/src/features/posts/presentation/posts_drawer/new_post_noti_button_controller.dart

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applimode_app/src/utils/call_fcm_function.dart';
import 'package:applimode_app/src/utils/fcm_service.dart';

part 'new_post_noti_button_controller.g.dart';

// English: Controller for managing FCM topic subscriptions/unsubscriptions for new post notifications.
// Korean: 새 게시물 알림에 대한 FCM 토픽 구독/구독 취소를 관리하는 컨트롤러입니다.
@riverpod
class NewPostNotiButtonController extends _$NewPostNotiButtonController {
  // ignore: avoid_public_notifier_properties
  // English: A key to prevent state updates on disposed controller instances.
  // Korean: 폐기된 컨트롤러 인스턴스에 대한 상태 업데이트를 방지하는 키입니다.
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

  // English: Subscribes to the specified FCM topic for new post notifications.
  // Returns true if successful, false otherwise.
  // Korean: 새 게시물 알림을 위해 지정된 FCM 토픽을 구독합니다.
  // 성공하면 true를, 그렇지 않으면 false를 반환합니다.
  Future<bool> turnOnSub(String topic) async {
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

    // English: Store the current key for instance validation.
    // Korean: 인스턴스 유효성 검사를 위해 현재 키를 저장합니다.
    final currentKey = key;

    // English: Perform the subscription operation.
    // Korean: 구독 작업을 수행합니다.
    final newState = await AsyncValue.guard(() async {
      if (kIsWeb) {
        // English: Use Firebase Functions for web.
        // Korean: 웹의 경우 Firebase Functions를 사용합니다.
        await FcmFunctions.callSubscribeToTopic(token: token!, topic: topic);
      } else {
        // English: Use FCM service directly for non-web platforms.
        // Korean: 웹이 아닌 플랫폼의 경우 FCM 서비스를 직접 사용합니다.
        await fcmService.subToTopic(topic);
      }
    });

    // English: Only update state if the controller instance is still the same.
    // Korean: 컨트롤러 인스턴스가 여전히 동일한 경우에만 상태를 업데이트합니다.
    if (currentKey == key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('turnOnSub error: ${state.error.toString()}');
      return false;
    }

    // English: Return true only if there's no error.
    // Korean: 오류가 없는 경우에만 true를 반환합니다.
    return true;
  }

  // English: Unsubscribes from the specified FCM topic.
  // Returns true if successful, false otherwise.
  // Korean: 지정된 FCM 토픽을 구독 취소합니다.
  // 성공하면 true를, 그렇지 않으면 false를 반환합니다.
  Future<bool> turnOffSub(String topic) async {
    // English: Set state to loading.
    // Korean: 상태를 로딩 중으로 설정합니다.
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

    // English: Store the current key for instance validation.
    // Korean: 인스턴스 유효성 검사를 위해 현재 키를 저장합니다.
    final currentKey = key;

    // English: Perform the unsubscription operation.
    // Korean: 구독 취소 작업을 수행합니다.
    final newState = await AsyncValue.guard(() async {
      if (kIsWeb) {
        // English: Use Firebase Functions for web.
        // Korean: 웹의 경우 Firebase Functions를 사용합니다.
        await FcmFunctions.callUnsubscribeFromTopic(
            token: token!, topic: topic);
      } else {
        // English: Use FCM service directly for non-web platforms.
        // Korean: 웹이 아닌 플랫폼의 경우 FCM 서비스를 직접 사용합니다.
        await fcmService.unsubFromTopic(topic);
      }
    });

    // English: Only update state if the controller instance is still the same.
    // Korean: 컨트롤러 인스턴스가 여전히 동일한 경우에만 상태를 업데이트합니다.
    if (currentKey == key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('turnOffSub error: ${state.error.toString()}');
      return false;
    }
    return true; // Return true only if there's no error.
  }
}

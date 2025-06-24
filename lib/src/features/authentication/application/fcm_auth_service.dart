import 'dart:developer' as dev;

// flutter
import 'package:flutter/foundation.dart';

// external
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:applimode_app/src/core/fcm/call_fcm_function.dart';
import 'package:applimode_app/src/core/fcm/fcm_service.dart';
import 'package:applimode_app/src/core/persistence/shared_preferences.dart';

// features
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';

part 'fcm_auth_service.g.dart';

class FCMAuthService {
  const FCMAuthService(this._ref);

  final Ref _ref;

  Future<void> setupToken() async {
    try {
      final fcmService = _ref.read(fcmServiceProvider);

      /// Safari doesn't show permission request dialog if user doesn't respond (like pressing a button)
      /// Delayed for 5 seconds to give the user time to press the button.
      /// If the user does not set up notifications, the app will automatically check when starting up.
      /// safari는 사용자가 반응하지 않은 경우 (버튼 누름 같은) 퍼미션 요청창을 보여주지 않음
      /// 사용자가 버튼을 누를 시간을 확보하기 위해 5초 동안 딜레이시켰음
      /// 만약 사용자가 알림설정을 하지 않을 경우 자동으로 앱 시작 시 항상 체크할 것임
      if (kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)) {
        await Future.delayed(const Duration(seconds: 5));
      }

      await fcmService.requestPermission();

      final settings = await fcmService.notificationSettings;
      debugPrint('authorizationStatus: settings.authorizationStatus');
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        /// After the user approves the notification, the function will be executed the next time the app starts.
        /// 사용자가 알림 승인을 한 후 다음 앱 시작시 해당 함수가 수행됨.
        debugPrint('User granted permission');

        /// Check and update token every time app starts
        /// 앱 시작할 때마다 토큰을 체크하고 업데이트
        final token = await fcmService.fcmToken;
        if (token == null) {
          debugPrint('token is null');
          return;
        }

        /// call the function new post subscription.
        /// 새글 구독 함수 호출
        await setupSub(token);

        final user = _ref.read(authRepositoryProvider).currentUser;
        if (user == null) {
          return;
        }
        final appUser = await _ref.read(appUserDataProvider(user.uid).future);
        final sharedPreferences =
            _ref.read(prefsWithCacheProvider).requireValue;
        final isLikeComment = sharedPreferences.getBool('likeCommentNoti');

        /// Login is required. If notifications have not been set yet, or if notifications have been set but the token is missing or different
        /// 로그인 된 상태에서 아직 알림 설정이 되지 않은 경우, 알림 설정이 됐지만 토큰이 없거나 다른 경우
        if (appUser != null &&
            (isLikeComment == null ||
                (isLikeComment &&
                    (appUser.fcmToken == null ||
                        appUser.fcmToken!.isEmpty ||
                        appUser.fcmToken != token)))) {
          dev.log('token refresh');
          try {
            await _ref.read(appUserRepositoryProvider).updateFcmToken(
                  uid: user.uid,
                  token: token,
                );
            await _ref
                .read(prefsWithCacheProvider)
                .requireValue
                .setBool('likeCommentNoti', true);
            _ref.read(appUserDataProvider(user.uid).notifier).refresh();
          } catch (e) {
            debugPrint('likeCommentNotiInitError: ${e.toString()}');
          }
        }
      }
    } catch (e) {
      debugPrint('setupTokenError: ${e.toString()}');
    }
  }

  /// Function to automatically trigger subscriptions to new posts
  /// 새 글에 대한 구독을 자동으로 실행하는 함수
  Future<void> setupSub(String token) async {
    final fcmService = _ref.read(fcmServiceProvider);
    final isNewPostNoti =
        _ref.read(prefsWithCacheProvider).requireValue.getBool('newPostNoti');
    if (isNewPostNoti == null) {
      try {
        if (kIsWeb) {
          await FcmFunctions.callSubscribeToTopic(
              token: token, topic: 'newPost');
        } else {
          await fcmService.subToTopic('newPost');
        }
        await _ref
            .read(prefsWithCacheProvider)
            .requireValue
            .setBool('newPostNoti', true);
      } catch (e) {
        debugPrint('setupSubError: ${e.toString()}');
      }
    }
  }

  Future<void> tokenToEmpty(String uid) =>
      _ref.read(appUserRepositoryProvider).updateFcmToken(
            uid: uid,
            token: '',
          );
}

@riverpod
FCMAuthService fcmAuthService(Ref ref) {
  return FCMAuthService(ref);
}

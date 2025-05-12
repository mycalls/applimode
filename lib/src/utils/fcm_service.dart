import 'dart:developer' as dev;

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/utils/call_fcm_function.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_service.g.dart';

bool isUsableFcm() {
  if (useFcmMessage) {
    // for web app like pwa
    if (kIsWeb && fcmVapidKey.trim().isNotEmpty) {
      return true;
    }
    // for Android
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return true;
    }
    // for iOS
    if (useApns && !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      return true;
    }
  }

  return false;

  /*
  return (kIsWeb && fcmVapidKey.trim().isNotEmpty) ||
      (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) ||
      (useApns && !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS);
  */
}

class FCMService {
  const FCMService(this._ref, this._fcm);

  final Ref _ref;
  final FirebaseMessaging _fcm;

  Future<String?> get fcmToken =>
      kIsWeb ? _fcm.getToken(vapidKey: fcmVapidKey) : _fcm.getToken();

  Future<bool> authorizedByUser() async {
    /// To show the push notification settings button only when authorized
    /// authorized 된 상태에서만 푸쉬알림 설정 버튼을 보여주기 위해
    final settings = await _fcm.getNotificationSettings();

    /// authorized, denied, notDetermined, provisional
    /// notDetermined -> The app user has not yet chosen whether to allow the application to create notifications. Usually this status is returned prior to the first call of requestPermission.
    /// provisional -> The app is currently authorized to post non-interrupting user notifications.
    dev.log('authorizationStatus: ${settings.authorizationStatus}');
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> setupToken() async {
    try {
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

      await _fcm.requestPermission();

      final settings = await _fcm.getNotificationSettings();
      debugPrint('authorizationStatus: settings.authorizationStatus');
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        /// After the user approves the notification, the function will be executed the next time the app starts.
        /// 사용자가 알림 승인을 한 후 다음 앱 시작시 해당 함수가 수행됨.
        debugPrint('User granted permission');

        /// Check and update token every time app starts
        /// 앱 시작할 때마다 토큰을 체크하고 업데이트
        final token = await fcmToken;
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
    final isNewPostNoti =
        _ref.read(prefsWithCacheProvider).requireValue.getBool('newPostNoti');
    if (isNewPostNoti == null) {
      try {
        if (kIsWeb) {
          await FcmFunctions.callSubscribeToTopic(
              token: token, topic: 'newPost');
        } else {
          await _fcm.subscribeToTopic('newPost');
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

  Future<void> subToTopic(String topic) => _fcm.subscribeToTopic(topic);

  Future<void> unsubFromTopic(String topic) => _fcm.unsubscribeFromTopic(topic);

  Future<void> tokenToEmpty(String uid) =>
      _ref.read(appUserRepositoryProvider).updateFcmToken(
            uid: uid,
            token: '',
          );

  Future<void> setupInteractedMessage() async {
    final initialMessage = await _fcm.getInitialMessage();

    if (initialMessage != null) {
      dev.log('initailMessage exists');
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final type = message.data['type'] as String?;
    final postId = message.data['postId'] as String?;
    final commentId = message.data['commentId'] as String?;
    final goRouter = _ref.read(goRouterProvider);
    if (type == 'post' && postId != null) {
      goRouter.push(ScreenPaths.post(postId));
    } else if (type == 'comments' && postId != null) {
      goRouter.push(ScreenPaths.comments(postId));
    } else if (type == 'replies' && postId != null && commentId != null) {
      goRouter.push(ScreenPaths.replies(postId, commentId));
    } else if (type == 'commentLikes' && postId != null) {
      goRouter.push(ScreenPaths.comments(postId));
    } else if (type == 'postLikes' && postId != null) {
      goRouter.push(ScreenPaths.post(postId));
    }
  }
}

@riverpod
FCMService fcmService(Ref ref) {
  return FCMService(ref, FirebaseMessaging.instance);
}

@riverpod
FutureOr<bool> authorizedByUser(Ref ref) {
  final fcmService = ref.watch(fcmServiceProvider);
  return fcmService.authorizedByUser();
}

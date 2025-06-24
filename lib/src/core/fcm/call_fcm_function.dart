// external
import 'package:cloud_functions/cloud_functions.dart';

// core
import 'package:applimode_app/custom_settings.dart';

class FcmFunctions {
  const FcmFunctions();

  static void callSendMessage({
    String? type,
    required String content,
    String? postId,
    String? commentId,
    bool isTopic = false,
    String? topic,
    String? token,
  }) {
    final callable = FirebaseFunctions.instance.httpsCallable('sendFcmMessage');
    final payload = {
      "notification": {
        // "title": "Noti Title",
        "body": content,
      },
      "data": {
        if (type != null && type.isNotEmpty) "type": type,
        if (postId != null && postId.isNotEmpty) "postId": postId,
        if (commentId != null && commentId.isNotEmpty) "commentId": commentId,
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
      },
      if (isTopic) "topic": topic,
      if (!isTopic) "token": token,
      "android": {
        "priority": "normal", // high
      },
      "apns": {
        "headers": {
          "apns-priority": "5", // 10
        },
        "payload": {
          "aps": {
            "sound": "default",
          },
        }
      },
      // when gettinng a noti on web, if tap the noti it will open the link
      "webpush": {
        "fcm_options": {"link": "https://$firebaseProjectId.web.app/"}
      },
    };
    callable.call(<String, dynamic>{"payload": payload});
  }

  static Future<void> callSubscribeToTopic({
    required String token,
    required String topic,
  }) async {
    final callable =
        FirebaseFunctions.instance.httpsCallable('subscribeToTopic');

    await callable
        .call(<String, String>{"registrationTokens": token, "topic": topic});
  }

  static Future<void> callUnsubscribeFromTopic({
    required String token,
    required String topic,
  }) async {
    final callable =
        FirebaseFunctions.instance.httpsCallable('unsubscribeFromTopic');

    await callable
        .call(<String, String>{"registrationTokens": token, "topic": topic});
  }
}

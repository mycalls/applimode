// lib/src/features/posts/presentation/posts_drawer/like_comment_noti_button.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/fcm_service.dart';
import 'package:applimode_app/src/utils/shared_preferences.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/like_comment_noti_button_controller.dart';

// English: A StatefulWidget that provides a switch to toggle like and comment notifications.
// Korean: 좋아요 및 댓글 알림을 토글하는 스위치를 제공하는 StatefulWidget입니다.
class LikeCommentNotiButton extends ConsumerStatefulWidget {
  const LikeCommentNotiButton({super.key});

  @override
  ConsumerState<LikeCommentNotiButton> createState() =>
      _LikeCommentNotiButtonState();
}

class _LikeCommentNotiButtonState extends ConsumerState<LikeCommentNotiButton> {
  @override
  Widget build(BuildContext context) {
    // English: Access SharedPreferences for storing notification preference.
    // Korean: 알림 설정을 저장하기 위해 SharedPreferences에 접근합니다.
    final sharedPreferences = ref.watch(prefsWithCacheProvider).requireValue;
    // English: Check if the user has authorized notifications via FCM.
    // Korean: 사용자가 FCM을 통해 알림을 승인했는지 확인합니다.
    final authorized = ref.watch(authorizedByUserProvider);
    // English: Determine if the notification setting has been previously set (activated).
    // Korean: 알림 설정이 이전에 설정되었는지(활성화되었는지) 확인합니다.
    final isActivated = sharedPreferences.getBool('likeCommentNoti') != null;

    // English: Watch the loading state from the controller.
    // Korean: 컨트롤러에서 로딩 상태를 관찰합니다.
    final isLoading =
        ref.watch(likeCommentNotiButtonControllerProvider).isLoading;

    // English: Build UI based on notification authorization and activation state.
    // Korean: 알림 승인 및 활성화 상태에 따라 UI를 빌드합니다.
    return authorized.when(
      data: (authorized) => authorized && isActivated
          ? ListTile(
              // English: Icon for notification settings.
              // Korean: 알림 설정을 위한 아이콘입니다.
              leading: const Icon(Icons.notifications_outlined),
              // English: Title text for the like/comment notification setting.
              // Korean: 좋아요/댓글 알림 설정의 제목 텍스트입니다.
              title: Text(context.loc.likeCommentNoti),
              // English: Display a loading indicator or a Switch.
              // Korean: 로딩 인디케이터 또는 스위치를 표시합니다.
              trailing: isLoading
                  ? const CupertinoActivityIndicator()
                  : Switch(
                      // English: Current value of the switch, read from SharedPreferences.
                      // Korean: SharedPreferences에서 읽어온 스위치의 현재 값입니다.
                      value: sharedPreferences.getBool('likeCommentNoti')!,
                      onChanged: (value) async {
                        // English: Logic to handle switch state changes.
                        // Korean: 스위치 상태 변경을 처리하는 로직입니다.
                        bool operationSuccessful;
                        if (value) {
                          // English: If turning on, update FCM token.
                          // Korean: 켜는 경우 FCM 토큰을 업데이트합니다.
                          operationSuccessful = await ref
                              .read(likeCommentNotiButtonControllerProvider
                                  .notifier)
                              .updateToken();
                        } else {
                          // English: If turning off, clear FCM token.
                          // Korean: 끄는 경우 FCM 토큰을 지웁니다.
                          operationSuccessful = await ref
                              .read(likeCommentNotiButtonControllerProvider
                                  .notifier)
                              .tokenToEmpty();
                        }
                        // English: If the backend operation was successful, update SharedPreferences.
                        // Korean: 백엔드 작업이 성공한 경우 SharedPreferences를 업데이트합니다.
                        if (operationSuccessful) {
                          sharedPreferences.setBool('likeCommentNoti', value);
                        }
                        // English: Rebuild the widget to reflect changes, ensuring it's still mounted.
                        // Korean: 변경 사항을 반영하기 위해 위젯을 다시 빌드하되, 마운트된 상태인지 확인합니다.
                        if (mounted) {
                          setState(() {});
                        }
                      }),
              leadingAndTrailingTextStyle:
                  Theme.of(context).textTheme.labelLarge,
            )
          // English: If not authorized or not activated, show nothing.
          // Korean: 승인되지 않았거나 활성화되지 않은 경우 아무것도 표시하지 않습니다.
          : const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}

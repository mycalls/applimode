// lib/src/features/posts/presentation/posts_floating_action_button/posts_floating_action_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';

// English: A FloatingActionButton that is conditionally displayed based on writing permissions.
// It allows users to navigate to the screen for creating new posts.
// Korean: 작성 권한에 따라 조건부로 표시되는 FloatingActionButton 입니다.
// 사용자가 새 게시물 작성 화면으로 이동할 수 있도록 합니다.
class PostsFloatingActionButton extends ConsumerWidget {
  const PostsFloatingActionButton({super.key, this.heroTag});

  // English: Optional Hero tag for the FloatingActionButton.
  // Korean: FloatingActionButton을 위한 선택적 Hero 태그입니다.
  final Object? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // English: Get admin settings to determine writing permissions.
    // Korean: 작성 권한을 결정하기 위해 관리자 설정을 가져옵니다.
    final adminSettings = ref.watch(adminSettingsProvider);
    final isAdminOnlyWrite = adminSettings.adminOnlyWrite;
    // English: 'verifiedOnlyWrite' is a global setting from custom_settings.dart.
    // Korean: 'verifiedOnlyWrite'는 custom_settings.dart의 전역 설정입니다.
    final user = isAdminOnlyWrite || verifiedOnlyWrite
        ? ref.watch(authStateChangesProvider).value
        : null;
    // English: Fetch app-specific user data if needed for permission checks.
    // Korean: 권한 확인에 필요한 경우 앱별 사용자 데이터를 가져옵니다.
    final appUser =
        user != null ? ref.watch(appUserDataProvider(user.uid)).value : null;

    // English: Determine if the FAB should be shown based on writing permissions.
    // Korean: 작성 권한에 따라 FAB를 표시해야 하는지 결정합니다.
    final bool canWriteGeneral = !isAdminOnlyWrite && !verifiedOnlyWrite;
    final bool canWriteAdmin =
        isAdminOnlyWrite && appUser != null && appUser.isAdmin;
    final bool canWriteVerified =
        verifiedOnlyWrite && appUser != null && appUser.verified;

    final bool showFab = canWriteGeneral || canWriteAdmin || canWriteVerified;

    return showFab
        ? FloatingActionButton(
            heroTag: heroTag,
            shape: const CircleBorder(),
            onPressed: () => context.push(ScreenPaths.write),
            // child: const Icon(Icons.add),
            // English: Using an edit icon, common for "write" or "create" actions.
            // Korean: "쓰기" 또는 "만들기" 작업에 일반적인 편집 아이콘을 사용합니다.
            child: const Icon(Icons.edit),
          )
        // English: If conditions are not met, show an empty SizedBox (effectively hiding the FAB).
        // Korean: 조건이 충족되지 않으면 빈 SizedBox를 표시합니다 (FAB를 효과적으로 숨김).
        : const SizedBox.shrink();
  }
}

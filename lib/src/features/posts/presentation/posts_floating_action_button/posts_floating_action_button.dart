import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostsFloatingActionButton extends ConsumerWidget {
  const PostsFloatingActionButton({super.key, this.heroTag});

  final Object? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdminOnlyWrite = ref.watch(adminSettingsProvider).adminOnlyWrite;
    final user = isAdminOnlyWrite || verifiedOnlyWrite
        ? ref.watch(authStateChangesProvider).value
        : null;
    final appUser =
        user != null ? ref.watch(appUserDataProvider(user.uid)).value : null;
    return (!isAdminOnlyWrite && !verifiedOnlyWrite) ||
            (isAdminOnlyWrite && appUser != null && appUser.isAdmin) ||
            (verifiedOnlyWrite && appUser != null && appUser.verified)
        ? FloatingActionButton(
            heroTag: heroTag,
            shape: const CircleBorder(),
            onPressed: () => context.push(ScreenPaths.write),
            // child: const Icon(Icons.add),
            child: const Icon(Icons.edit),
          )
        : const SizedBox.shrink();
  }
}

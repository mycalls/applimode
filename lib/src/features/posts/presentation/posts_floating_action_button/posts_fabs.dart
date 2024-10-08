import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/common_widgets/percent_circular_indicator.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_floating_action_button/direct_upload_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_floating_action_button/direct_upload_button_controller.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_floating_action_button/posts_floating_action_button.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/utils/upload_progress_state.dart';

class PostsFabs extends ConsumerWidget {
  const PostsFabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(directUploadButtonControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });
    final user = adminOnlyWrite || verifiedOnlyWrite
        ? ref.watch(authStateChangesProvider).value
        : null;
    final appUser =
        user != null ? ref.watch(appUserFutureProvider(user.uid)).value : null;
    final isLoading = ref.watch(directUploadButtonControllerProvider).isLoading;
    final uploadState = ref.watch(uploadProgressStateProvider);
    return isLoading
        ? Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 28),
              child: PercentCircularIndicator(
                strokeWidth: 8,
                percentage: uploadState.percentage,
              ),
            ),
          )
        : (!adminOnlyWrite && !verifiedOnlyWrite) ||
                (adminOnlyWrite && appUser != null && appUser.isAdmin) ||
                (verifiedOnlyWrite && appUser != null && appUser.verified)
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DirectUploadButton(
                    heroTag: 'uploadFab',
                  ),
                  SizedBox(height: 12),
                  PostsFloatingActionButton(heroTag: 'publishFab'),
                ],
              )
            : const SizedBox.shrink();
  }
}

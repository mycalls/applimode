// flutter
import 'package:flutter/material.dart';

// external
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/constants/constants.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/show_image_picker.dart';
import 'package:applimode_app/src/utils/show_selection_dialog.dart';

// features
import 'package:applimode_app/src/features/profile/presentation/profile_app_bar_more_controller.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';

class ProfileAppBarMore extends ConsumerWidget {
  const ProfileAppBarMore({
    super.key,
    required this.profileUser,
    required this.user,
    this.color,
    this.isAccount = false,
    this.isAdmin = false,
  });

  final AppUser profileUser;
  final User user;
  final Color? color;
  final bool isAccount;
  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(profileAppBarMoreControllerProvider, (_, next) {
      next.showAlertDialogOnError(context);
    });
    final isLoading = ref.watch(profileAppBarMoreControllerProvider).isLoading;
    final mediaMaxMBSize = ref.watch(adminSettingsProvider).mediaMaxMBSize;

    return /* isLoading
        ? Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedCircularProgressIndicator(
              backgroundColor: color,
            ),
          )
        :*/
        IgnorePointer(
      ignoring: isLoading,
      child: PopupMenuButton(
        tooltip: 'Edit profile',
        icon: Icon(
          Icons.more_vert,
          color: color,
        ),
        //color: color,
        position: PopupMenuPosition.under,
        itemBuilder: (context) {
          return [
            if (isAccount && user.uid == profileUser.uid) ...[
              PopupMenuItem(
                onTap: () {
                  context.push(
                    ScreenPaths.editUsername(
                      profileUser.uid,
                      profileUser.displayName,
                    ),
                  );
                },
                child: Text(context.loc.editUsername),
              ),
              PopupMenuItem(
                onTap: () {
                  showSelectionDialog(
                    context: context,
                    firstTitle: context.loc.defaultImage,
                    firstTap: () async {
                      context.pop();
                      await ref
                          .read(profileAppBarMoreControllerProvider.notifier)
                          .changeProfileImage();
                    },
                    secondTitle: context.loc.chooseFromGallery,
                    secondTap: () async {
                      context.pop();
                      final pickedFile = await showImagePicker(
                        isImage: true,
                        mediaMaxMBSize: mediaMaxMBSize,
                      );
                      if (pickedFile != null) {
                        String? mediaType = pickedFile.mimeType;

                        if (mediaType == null) {
                          final fileExt =
                              pickedFile.name.split('.').last.toLowerCase();
                          if (imageExts.contains(fileExt)) {
                            mediaType = Format.extToMimeType(fileExt);
                          } else {
                            debugPrint('ext is unsupported mediaType');
                            return;
                          }
                        } else {
                          if (!imageContentTypes.contains(mediaType)) {
                            debugPrint('mediaType is unsupported mediaType');
                            return;
                          }
                        }
                        await ref
                            .read(profileAppBarMoreControllerProvider.notifier)
                            .changeProfileImage(
                              xFile: pickedFile,
                              mediaType: mediaType,
                            );
                      }
                    },
                  );
                },
                child: Text(context.loc.changeProfileImage),
              ),
              if (user.email != null)
                PopupMenuItem(
                  onTap: () {
                    showSelectionDialog(
                      context: context,
                      firstTitle: context.loc.defaultImage,
                      firstTap: () async {
                        context.pop();
                        await ref
                            .read(profileAppBarMoreControllerProvider.notifier)
                            .changeStoryImage();
                      },
                      secondTitle: context.loc.chooseFromGallery,
                      secondTap: () async {
                        context.pop();
                        final pickedFile = await showImagePicker(
                          isImage: true,
                          mediaMaxMBSize: mediaMaxMBSize,
                        );
                        if (pickedFile != null) {
                          String? mediaType = pickedFile.mimeType;

                          if (mediaType == null) {
                            final fileExt =
                                pickedFile.name.split('.').last.toLowerCase();
                            if (imageExts.contains(fileExt)) {
                              mediaType = Format.extToMimeType(fileExt);
                            } else {
                              debugPrint('ext is unsupported mediaType');
                              return;
                            }
                          } else {
                            if (!imageContentTypes.contains(mediaType)) {
                              debugPrint('mediaType is unsupported mediaType');
                              return;
                            }
                          }
                          await ref
                              .read(
                                  profileAppBarMoreControllerProvider.notifier)
                              .changeStoryImage(
                                xFile: pickedFile,
                                mediaType: mediaType,
                              );
                        }
                      },
                    );
                  },
                  child: Text(context.loc.changeStoryImage),
                ),
              PopupMenuItem(
                onTap: () {
                  context.push(
                    ScreenPaths.editBio(
                      profileUser.uid,
                      profileUser.bio.trim().isEmpty ? noBio : profileUser.bio,
                    ),
                  );
                },
                child: Text(context.loc.editBio),
              ),
              /*
                  PopupMenuItem(
                    onTap: () {
                      context.push(
                        ScreenPaths.changeEmail(appUser.uid, user.email!),
                      );
                    },
                    child: Text(context.loc.changeEmail),
                  ),
                  */
              PopupMenuItem(
                onTap: () {
                  context.push(
                    ScreenPaths.changePassword(profileUser.uid),
                  );
                },
                child: Text(context.loc.changePassword),
              ),
            ],
            if (!isAccount && isAdmin)
              PopupMenuItem(
                onTap: () async {
                  profileUser.isBlock
                      ? await ref
                          .read(profileAppBarMoreControllerProvider.notifier)
                          .unblockAppUser(profileUser.uid)
                      : ref
                          .read(profileAppBarMoreControllerProvider.notifier)
                          .blockAppUser(profileUser.uid);
                },
                child: Text(profileUser.isBlock
                    ? context.loc.unblockUser
                    : context.loc.blockUser),
              ),
          ];
        },
      ),
    );
  }
}

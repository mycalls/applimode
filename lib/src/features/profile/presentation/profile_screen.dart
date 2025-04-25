import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/animated_color_container.dart';
import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/common_widgets/buttons/icon_back_button.dart';
import 'package:applimode_app/src/common_widgets/error_widgets/error_message_button.dart';
import 'package:applimode_app/src/common_widgets/error_widgets/error_scaffold.dart';
import 'package:applimode_app/src/common_widgets/percent_circular_indicator.dart';
import 'package:applimode_app/src/common_widgets/sized_circular_progress_indicator.dart';
import 'package:applimode_app/src/common_widgets/user_items/user_item.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/features/authentication/application/sign_out_service.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/profile/presentation/buttons/profile_text_button.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_app_bar_more.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_app_bar_more_controller.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_screen_controller.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/show_password_dialog.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomProfileScreen extends ConsumerWidget {
  const CustomProfileScreen({
    super.key,
    required this.uid,
    this.isAccount = false,
  });

  final String uid;
  final bool isAccount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(profileScreenControllerProvider, (_, next) {
      next.showAlertDialogOnError(context);
    });

    final user = ref.watch(authStateChangesProvider).value;
    final userEmail = user?.email;
    final profileUserFuture = user != null && user.uid == uid
        ? ref.watch(appUserFutureProvider(uid))
        : ref.watch(writerFutureProvider(uid));
    final screenState = ref.watch(profileScreenControllerProvider);
    final isLoading = ref.watch(profileAppBarMoreControllerProvider).isLoading;

    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: screenState.isLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedCircularProgressIndicator(),
                const SizedBox(height: 12),
                Text(
                  context.loc.deletingAccount,
                  textAlign: TextAlign.center,
                ),
              ],
            ))
          : AsyncValueWidget(
              value: profileUserFuture,
              data: (profileUser) {
                if (profileUser == null) {
                  return ErrorScaffold(errorMessage: context.loc.userNotExist);
                }
                final adminUser = user != null
                    ? ref.watch(appUserFutureProvider(user.uid)).value
                    : null;
                return Stack(
                  children: [
                    Container(color: primaryColor),
                    profileUser.storyUrl != null
                        ? Positioned.fill(
                            child: PlatformNetworkImage(
                              imageUrl: profileUser.storyUrl!,
                              fit: BoxFit.cover,
                              errorWidget: Container(
                                color: primaryColor,
                              ),
                            ),
                          )
                        : AnimatedColorBox(),
                    CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    kIsWeb
                                        ? const WebBackButton(
                                            color: Colors.white)
                                        : const IconBackButton(
                                            color: Colors.white,
                                          ),
                                    Expanded(
                                      child: UserItem(
                                        appUser: profileUser,
                                        isProfileScreen: true,
                                        profileImageSize: profileSizeMax,
                                        titleColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 24,
                                        ),
                                        isTwoLine:
                                            isAccount && userEmail != null,
                                        secondLine: userEmail,
                                        subtitleColor: Colors.white,
                                      ),
                                    ),
                                    if (isAccount && user != null ||
                                        !isAccount &&
                                            user != null &&
                                            adminUser != null &&
                                            uid != adminUser.uid &&
                                            adminUser.isAdmin)
                                      ProfileAppBarMore(
                                        profileUser: profileUser,
                                        user: user,
                                        color: Colors.white,
                                        isAccount: isAccount,
                                        isAdmin: adminUser != null &&
                                            adminUser.isAdmin,
                                      ),
                                  ],
                                ),
                                if (profileUser.bio.trim().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    child: Text(
                                      profileUser.bio,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: textTheme.headlineLarge?.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          ProfileTextButton(
                                            label: context.loc.posts,
                                            onPressed: () {
                                              context.push(
                                                ScreenPaths.userPosts(uid),
                                              );
                                            },
                                          ),
                                          ProfileTextButton(
                                            label: context.loc.comments,
                                            onPressed: () {
                                              context.push(
                                                ScreenPaths.userComments(uid),
                                              );
                                            },
                                          ),
                                          ProfileTextButton(
                                            label: context.loc.likesPosts,
                                            onPressed: () {
                                              context.push(
                                                ScreenPaths.userLikes(uid),
                                              );
                                            },
                                          ),
                                          if (isAccount && user != null) ...[
                                            ProfileTextButton(
                                              label: context.loc.logOut,
                                              onPressed: () {
                                                //ref.read(authRepositoryProvider).signOut();
                                                ref
                                                    .read(
                                                        signOutServiceProvider)
                                                    .signOut();
                                                if (context.canPop()) {
                                                  context.pop();
                                                }
                                              },
                                            ),
                                            ProfileTextButton(
                                              label: context.loc.deleteAccount,
                                              onPressed: () async {
                                                final result =
                                                    await showPasswordDialog(
                                                        context);
                                                if (result) {
                                                  ref
                                                      .read(
                                                          profileScreenControllerProvider
                                                              .notifier)
                                                      .deleteAccount();
                                                }
                                              },
                                            ),
                                          ]
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                );
              },
              loadingWidget:
                  const Center(child: SizedCircularProgressIndicator()),
              errorwidget:
                  ErrorMessageButton(errorMessage: context.loc.wrongMessage),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isLoading
          ? Center(
              child: PercentCircularIndicator(
                  // backgroundColor: Colors.white,
                  ),
            )
          : null,
    );
  }
}

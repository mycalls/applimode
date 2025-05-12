import 'package:applimode_app/src/common_widgets/color_circle.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/cached_circle_image.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/authentication/application/sign_out_service.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/app_locale_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/app_style_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/app_theme_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/like_comment_noti_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/new_post_noti_button.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/fcm_service.dart' show isUsableFcm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class PostsDrawer extends ConsumerWidget {
  const PostsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // dev.log('Posts Drawer build');
    final user = ref.watch(authStateChangesProvider).value;
    final appUser =
        user != null ? ref.watch(appUserDataProvider(user.uid)).value : null;
    final adminSettings = ref.watch(adminSettingsProvider);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // sign in of profile button
            appUser == null
                ? ListTile(
                    leading: const Icon(Icons.face),
                    title: Text(context.loc.logIn),
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                      context.push(ScreenPaths.firebaseSignIn);
                    })
                : ListTile(
                    leading:
                        appUser.photoUrl == null || appUser.photoUrl!.isEmpty
                            ? const ColorCircle(
                                size: profileSizeSmall,
                              )
                            : CachedCircleImage(
                                imageUrl: appUser.photoUrl!,
                                size: profileSizeSmall,
                              ),
                    title: Text(
                      appUser.displayName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                      context.push(
                        ScreenPaths.account(appUser.uid),
                      );
                    },
                  ),
            divider24,
            // recommeneded posts button
            if (adminSettings.useRecommendation)
              ListTile(
                leading: const Icon(Icons.recommend_outlined),
                title: Text(context.loc.recommendedPosts),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                  context.push(ScreenPaths.recommendedPosts);
                },
              ),
            // ranking screen button
            if (adminSettings.useRanking)
              ListTile(
                leading: const Icon(Icons.military_tech_outlined),
                title: Text(context.loc.ranking),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                  context.push(ScreenPaths.ranking);
                },
              ),
            // categories button
            if (adminSettings.mainCategory.length > 1 &&
                adminSettings.useCategory)
              ...adminSettings.mainCategory.map(
                (e) => ListTile(
                  leading: Icon(
                    Icons.label_outline,
                    color: e.color,
                  ),
                  title: Text(e.title),
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                    context.push(e.path);
                  },
                ),
              ),
            if (adminSettings.useRecommendation ||
                adminSettings.useRanking ||
                adminSettings.useCategory ||
                adminSettings.showAppStyleOption)
              divider24,
            // app style button
            if (adminSettings.showAppStyleOption) const AppStyleButton(),
            // app theme button
            const AppThemeButton(),
            // app locale button
            const AppLocaleButton(),
            // noti buttons
            if (isUsableFcm()) ...[
              const NewPostNotiButton(),
              if (user != null && appUser != null)
                const LikeCommentNotiButton(),
            ],
            divider24,
            // admin-settings button
            if (appUser != null && appUser.isAdmin)
              ListTile(
                leading: const Icon(Icons.admin_panel_settings_outlined),
                title: Text(context.loc.adminSettings),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                  context.push(ScreenPaths.adminSettings);
                },
              ),
            // terms button
            ListTile(
              leading: const Icon(Icons.handshake_outlined),
              title: Text(context.loc.termsOfService),
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                }
                if (termsUrl.trim().isNotEmpty) {
                  launchUrl(
                    Uri.parse(termsUrl),
                  );
                } else {
                  context.push(ScreenPaths.appTerms);
                }
              },
            ),
            // privacy button
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(context.loc.privacyPolicy),
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                }
                if (privacyUrl.trim().isNotEmpty) {
                  launchUrl(
                    Uri.parse(privacyUrl),
                  );
                } else {
                  context.push(ScreenPaths.appPrivacy);
                }
              },
            ),
            // app info button
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(context.loc.appInfo),
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                }
                context.push(ScreenPaths.appInfo);
              },
            ),
            // sign out button
            if (user != null && adminSettings.showLogoutOnDrawer) ...[
              divider24,
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(context.loc.logOut),
                onTap: () {
                  //ref.read(authRepositoryProvider).signOut();
                  ref.read(signOutServiceProvider).signOut();
                  if (context.canPop()) {
                    context.pop();
                  }
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// lib/src/features/posts/presentation/posts_drawer/posts_drawer.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/common_widgets/color_circle.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/cached_circle_image.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/fcm_service.dart' show isUsableFcm;

import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/authentication/application/sign_out_service.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/app_locale_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/app_style_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/app_theme_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/like_comment_noti_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/new_post_noti_button.dart';

// English: A Drawer widget that displays navigation options and settings for the posts feature.
// Korean: 게시물 기능에 대한 탐색 옵션 및 설정을 표시하는 Drawer 위젯입니다.
class PostsDrawer extends ConsumerWidget {
  const PostsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // dev.log('Posts Drawer build');
    final user = ref.watch(authStateChangesProvider).value;
    // English: Fetch authenticated user's app-specific data.
    // Korean: 인증된 사용자의 앱별 데이터를 가져옵니다.
    final appUser =
        user != null ? ref.watch(appUserDataProvider(user.uid)).value : null;
    // English: Fetch admin settings to conditionally display drawer items.
    // Korean: 관리자 설정을 가져와서 드로어 항목을 조건부로 표시합니다.
    final adminSettings = ref.watch(adminSettingsProvider);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // English: Display user profile or login button based on authentication state.
            // Korean: 인증 상태에 따라 사용자 프로필 또는 로그인 버튼을 표시합니다.
            appUser == null
                // English: If user is not logged in, show login button.
                // Korean: 사용자가 로그인하지 않은 경우 로그인 버튼을 표시합니다.
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
                    // English: If user is logged in, show profile picture and display name.
                    // Korean: 사용자가 로그인한 경우 프로필 사진과 표시 이름을 표시합니다.
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
                      // English: Close drawer and navigate to user's account screen.
                      // Korean: 드로어를 닫고 사용자 계정 화면으로 이동합니다.
                      if (context.canPop()) {
                        context.pop();
                      }
                      context.push(
                        ScreenPaths.account(appUser.uid),
                      );
                    },
                  ),
            divider24,
            // English: Display "Recommended Posts" if the feature is enabled in admin settings.
            // Korean: 관리자 설정에서 기능이 활성화된 경우 "추천 게시물"을 표시합니다.
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
            // English: Display "Ranking" if the feature is enabled in admin settings.
            // Korean: 관리자 설정에서 기능이 활성화된 경우 "랭킹"을 표시합니다.
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
            // English: Display category links if categories are used and more than one exists.
            // Korean: 카테고리가 사용되고 하나 이상 존재하는 경우 카테고리 링크를 표시합니다.
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
            // English: Show a divider if any of the preceding sections (recommendation, ranking, category, app style) are visible.
            // Korean: 이전 섹션(추천, 랭킹, 카테고리, 앱 스타일) 중 하나라도 표시되는 경우 구분선을 표시합니다.
            if (adminSettings.useRecommendation ||
                adminSettings.useRanking ||
                adminSettings.useCategory ||
                adminSettings.showAppStyleOption)
              divider24,
            // English: Display "App Style" button if the option is enabled in admin settings.
            // Korean: 관리자 설정에서 옵션이 활성화된 경우 "앱 스타일" 버튼을 표시합니다.
            if (adminSettings.showAppStyleOption) const AppStyleButton(),
            // English: Button to change the application theme (Light/Dark/System).
            // Korean: 애플리케이션 테마(라이트/다크/시스템)를 변경하는 버튼입니다.
            const AppThemeButton(),
            // English: Button to change the application locale (language).
            // Korean: 애플리케이션 로케일(언어)을 변경하는 버튼입니다.
            const AppLocaleButton(),
            // English: Display notification settings if FCM (Firebase Cloud Messaging) is usable.
            // Korean: FCM(Firebase Cloud Messaging)을 사용할 수 있는 경우 알림 설정을 표시합니다.
            if (isUsableFcm()) ...[
              // English: Button to toggle new post notifications.
              // Korean: 새 게시물 알림을 토글하는 버튼입니다.
              const NewPostNotiButton(),
              // English: Button to toggle like/comment notifications, shown only if user is logged in.
              // Korean: 좋아요/댓글 알림을 토글하는 버튼으로, 사용자가 로그인한 경우에만 표시됩니다.
              if (user != null && appUser != null)
                const LikeCommentNotiButton(),
            ],
            divider24,
            // English: Display "Admin Settings" button if the logged-in user is an admin.
            // Korean: 로그인한 사용자가 관리자인 경우 "관리자 설정" 버튼을 표시합니다.
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
            // English: "Terms of Service" button.
            // Korean: "서비스 이용약관" 버튼입니다.
            ListTile(
              leading: const Icon(Icons.handshake_outlined),
              title: Text(context.loc.termsOfService),
              onTap: () {
                if (context.canPop()) {
                  // English: Close the drawer.
                  // Korean: 드로어를 닫습니다.
                  context.pop();
                }
                if (termsUrl.trim().isNotEmpty) {
                  launchUrl(
                    Uri.parse(termsUrl),
                  );
                } else {
                  // English: If no external URL, navigate to in-app terms screen.
                  // Korean: 외부 URL이 없으면 인앱 약관 화면으로 이동합니다.
                  context.push(ScreenPaths.appTerms);
                }
              },
            ),
            // English: "Privacy Policy" button.
            // Korean: "개인정보 처리방침" 버튼입니다.
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(context.loc.privacyPolicy),
              onTap: () {
                if (context.canPop()) {
                  // English: Close the drawer.
                  // Korean: 드로어를 닫습니다.
                  context.pop();
                }
                if (privacyUrl.trim().isNotEmpty) {
                  launchUrl(
                    Uri.parse(privacyUrl),
                  );
                } else {
                  // English: If no external URL, navigate to in-app privacy screen.
                  // Korean: 외부 URL이 없으면 인앱 개인정보 처리방침 화면으로 이동합니다.
                  context.push(ScreenPaths.appPrivacy);
                }
              },
            ),
            // English: "App Info" button.
            // Korean: "앱 정보" 버튼입니다.
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(context.loc.appInfo),
              onTap: () {
                if (context.canPop()) {
                  // English: Close the drawer.
                  // Korean: 드로어를 닫습니다.
                  context.pop();
                }
                context.push(ScreenPaths.appInfo);
              },
            ),
            // English: Display "Log Out" button if user is logged in and admin settings allow.
            // Korean: 사용자가 로그인했고 관리자 설정에서 허용하는 경우 "로그아웃" 버튼을 표시합니다.
            if (user != null && adminSettings.showLogoutOnDrawer) ...[
              divider24,
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(context.loc.logOut),
                onTap: () {
                  //ref.read(authRepositoryProvider).signOut();
                  // English: Sign out the user.
                  // Korean: 사용자를 로그아웃시킵니다.
                  ref.read(signOutServiceProvider).signOut();
                  if (context.canPop()) {
                    // English: Close the drawer.
                    // Korean: 드로어를 닫습니다.
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

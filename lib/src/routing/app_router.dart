import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/app_settings/app_settings_controller.dart';
import 'package:applimode_app/src/common_widgets/error_widgets/error_scaffold.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/full_image_screen.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/admin_settings/presentation/admin_settings_screen.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_phone_screen.dart';
import 'package:applimode_app/src/features/like_users/like_users_screen.dart';
import 'package:applimode_app/src/features/policies/app_privacy_screen.dart';
import 'package:applimode_app/src/features/policies/app_terms_screen.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/presentation/main_posts_screen.dart';
import 'package:applimode_app/src/features/posts/presentation/search_screen.dart';
import 'package:applimode_app/src/features/posts/presentation/sub_posts_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/change_email_screen/change_email_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/change_password_screen/change_password_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/edit_bio_screen/edit_bio_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/edit_username_screen/edit_username_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_comments_screen/profile_comments_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_likes_screen/profile_likes_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_posts_screen/profile_posts_screen.dart';
import 'package:applimode_app/src/features/ranking/ranking_screen.dart';
import 'package:applimode_app/src/features/video_player/full_video_screen.dart';
import 'package:applimode_app/src/routing/maintenance_screen.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:applimode_app/src/utils/multi_images.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/presentation/app_user_check_screen.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_sign_in_screen.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_screen.dart';
import 'package:applimode_app/src/features/editor/presentation/editor_screen.dart';
import 'package:applimode_app/src/features/post/presentation/post_screen.dart';
import 'package:applimode_app/src/features/posts/domain/post_and_writer.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_screen.dart';
import 'package:applimode_app/src/routing/go_router_refresh_stream.dart';
import 'package:video_player/video_player.dart';

part 'app_router.g.dart';

class ScreenPaths {
  // sliver applied
  static String home = '/';
  static String maintenance = '/maintenance';
  static String firebaseSignIn = '/firebaseSignIn';
  static String phone = '/phone';
  static String appUserCheck = '/appUserCheck';
  static String write = '/write';
  // sliver applied
  static String search = '/search';
  static String adminSettings = '/adminSettings';
  // sliver applied
  static String recommendedPosts = '/recommendedPosts';
  // sliver applied
  static String ranking = '/ranking';
  // sliver applied
  static String post(String postId) => '/post/$postId';
  static String edit(String postId) => '/post/$postId/edit';
  static String comments(String postId) => '/post/$postId/comments';
  static String postLikes(String postId) => '/post/$postId/likes';
  static String postDislikes(String postId) => '/post/$postId/dislikes';
  static String replies(String postId, String commentId) =>
      '/post/$postId/comments/$commentId';
  static String account(String uid) => '/account/$uid';
  static String editUsername(String uid, String username) =>
      '/account/$uid/editUsername/$username';
  static String editBio(String uid, String bio) => '/account/$uid/editBio/$bio';
  static String changeEmail(String uid, String email) =>
      '/account/$uid/changeEmail/$email';
  static String changePassword(String uid) => '/account/$uid/changePassword';
  static String profile(String uid) => '/profile/$uid';
  // sliver applied
  static String userPosts(String uid) => '/$uid/posts';
  // sliver applied
  static String userComments(String uid) => '/$uid/comments';
  static String userLikes(String uid) => '/$uid/likes';
  static String commentLikes(String commentId) => '/comment/$commentId/likes';
  static String commentDislikes(String commentId) =>
      '/comment/$commentId/dislikes';
  static String fullImage(String imageUrl) => '/fullImage?imageUrl=$imageUrl';
  static String fullVideo(String videoUrl) => '/fullVideo?videoUrl=$videoUrl';
  static String appInfo = '/appInfo';
  static String appPrivacy = '/privacy';
  static String appTerms = '/terms';
}

@riverpod
GoRouter goRouter(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final adminSettings = ref.watch(adminSettingsProvider);
  final categories = adminSettings.mainCategory;
  final showAppStyleOption = adminSettings.showAppStyleOption;
  final postsListType = adminSettings.postsListType;
  final appSettings = ref.watch(appSettingsControllerProvider);
  final postsRepository = ref.watch(postsRepositoryProvider);

  final analytics = FirebaseAnalytics.instance;

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    observers: [FirebaseAnalyticsObserver(analytics: analytics)],
    redirect: (context, state) async {
      final user = authRepository.currentUser;
      final isLoggedIn = user != null;
      final isMaintenance = adminSettings.isMaintenance;
      final path = state.uri.path;
      if (isMaintenance) {
        if (user == null) {
          return ScreenPaths.maintenance;
        } else {
          final asyncAppUser = ref.watch(appUserFutureProvider(user.uid));
          asyncAppUser.when(
            data: (appUser) {
              if (appUser == null || !appUser.isAdmin) {
                return ScreenPaths.maintenance;
              }
            },
            error: (error, stackTrace) => ScreenPaths.maintenance,
            loading: () => const Center(child: CupertinoActivityIndicator()),
          );
        }
      }
      if (!isMaintenance) {
        if (path == ScreenPaths.maintenance) {
          return ScreenPaths.home;
        }
      }
      if (isLoggedIn) {
        if (path == ScreenPaths.firebaseSignIn) {
          return ScreenPaths.home;
        }
      }
      if (!isLoggedIn) {
        if (path == ScreenPaths.write) {
          return ScreenPaths.firebaseSignIn;
        }
        if (isInitialSignIn && path.startsWith('/')) {
          return ScreenPaths.firebaseSignIn;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MainPostsScreen(
          type: showAppStyleOption
              ? PostsListType.values[appSettings.appStyle ?? 1]
              : postsListType,
        ),
      ),
      GoRoute(
        path: ScreenPaths.maintenance,
        builder: (context, state) => const MaintenanceScreen(),
      ),
      GoRoute(
          path: ScreenPaths.firebaseSignIn,
          pageBuilder: (context, state) {
            return _buildPage(
                child: const FirebaseSignInScreen(), isFullScreen: true);
          }),
      GoRoute(
          path: ScreenPaths.phone,
          pageBuilder: (context, state) {
            return _buildPage(child: const FirebasePhoneScreen());
          }),
      GoRoute(
          path: ScreenPaths.appUserCheck,
          pageBuilder: (context, state) {
            return _buildPage(
              child: const AppUserCheckScreen(),
              // isFullScreen: true,
            );
          }),
      GoRoute(
          path: ScreenPaths.write,
          pageBuilder: (context, state) {
            return _buildPage(
              child: const EditorScreen(),
              // isFullScreen: true,
            );
          }),
      GoRoute(
          path: ScreenPaths.search,
          pageBuilder: (context, state) {
            final preSearchWord = state.extra as String?;
            return _buildPage(
                child: SearchScreen(
              preSearchWord: preSearchWord,
            ));
          }),
      GoRoute(
          path: ScreenPaths.adminSettings,
          pageBuilder: (context, state) {
            return _buildPage(child: const AdminSettingsScreen());
          }),
      GoRoute(
          path: ScreenPaths.recommendedPosts,
          pageBuilder: (context, state) {
            return _buildPage(
                child: SubPostsScreen(
              appBarTitle: context.loc.recommendedPosts,
              query: postsRepository.recommendedPostsQuery(),
              type: showAppStyleOption
                  ? PostsListType.values[appSettings.appStyle ?? 1]
                  : postsListType,
            ));
          }),
      GoRoute(
          path: ScreenPaths.ranking,
          pageBuilder: (context, state) {
            return _buildPage(child: const RankingScreen());
          }),
      ...categories.map(
        (category) => GoRoute(
          path: category.path,
          pageBuilder: (context, state) {
            return _buildPage(
                child: SubPostsScreen(
              query: postsRepository.categoryPostsQuery(category.index),
              appBarTitle: category.title,
              type: showAppStyleOption
                  ? PostsListType.values[appSettings.appStyle ?? 1]
                  : postsListType,
            ));
          },
        ),
      ),
      GoRoute(
        path: '/post/:id',
        pageBuilder: (context, state) {
          final postId = state.pathParameters['id']!;
          final postAndWriter = state.extra as PostAndWriter?;
          return _buildPage(
              child: PostScreen(
            postId: postId,
            postAndWriter: postAndWriter,
          ));
        },
        routes: [
          GoRoute(
            path: 'edit',
            pageBuilder: (context, state) {
              final postId = state.pathParameters['id'];
              final postAndWriter = state.extra as PostAndWriter?;
              return _buildPage(
                child: EditorScreen(
                  postId: postId,
                  postAndWriter: postAndWriter,
                ),
                // isFullScreen: true,
              );
            },
          ),
          GoRoute(
            path: 'likes',
            pageBuilder: (context, state) {
              final postId = state.pathParameters['id'];
              return _buildPage(
                child: LikeUsersScreen(
                  postId: postId,
                  isDislike: false,
                ),
                // isFullScreen: true,
              );
            },
          ),
          GoRoute(
            path: 'dislikes',
            pageBuilder: (context, state) {
              final postId = state.pathParameters['id'];
              return _buildPage(
                child: LikeUsersScreen(
                  postId: postId,
                  isDislike: true,
                ),
                // isFullScreen: true,
              );
            },
          ),
          GoRoute(
            path: 'comments',
            pageBuilder: (context, state) {
              final postId = state.pathParameters['id']!;
              final postWriter = state.extra as AppUser?;
              return _buildPage(
                child: PostCommentsScreen(
                  postId: postId,
                  postWriter: postWriter,
                ),
                // isFullScreen: true,
              );
            },
            routes: [
              GoRoute(
                path: ':parentCommentId',
                pageBuilder: (context, state) {
                  final postId = state.pathParameters['id']!;
                  final commentId = state.pathParameters['parentCommentId']!;
                  return _buildPage(
                      child: PostCommentsScreen(
                    postId: postId,
                    parentCommentId: commentId,
                  ));
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
          path: '/account/:uid',
          pageBuilder: (context, state) {
            final uid = state.pathParameters['uid']!;
            return _buildPage(
              child: CustomProfileScreen(
                uid: uid,
                isAccount: true,
              ),
              // isFullScreen: true,
            );
          },
          routes: [
            GoRoute(
              path: 'editUsername/:username',
              pageBuilder: (context, state) {
                final username = state.pathParameters['username']!;
                return _buildPage(
                    child: EditUsernameScreen(username: username));
              },
            ),
            GoRoute(
              path: 'editBio/:bio',
              pageBuilder: (context, state) {
                final bio = state.pathParameters['bio']!;
                return _buildPage(child: EditBioScreen(bio: bio));
              },
            ),
            GoRoute(
              path: 'changeEmail/:email',
              pageBuilder: (context, state) {
                final email = state.pathParameters['email']!;
                return _buildPage(child: ChangeEmailScreen(email: email));
              },
            ),
            GoRoute(
              path: 'changePassword',
              pageBuilder: (context, state) {
                return _buildPage(child: const ChangePasswordScreen());
              },
            ),
          ]),
      GoRoute(
        path: '/:uid/posts',
        pageBuilder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return _buildPage(
              child: ProfilePostsScreen(
            uid: uid,
            type: showAppStyleOption
                ? PostsListType.values[appSettings.appStyle ?? 1]
                : postsListType,
          ));
        },
      ),
      GoRoute(
        path: '/:uid/comments',
        pageBuilder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return _buildPage(child: ProfileCommentsScreen(uid: uid));
        },
      ),
      GoRoute(
        path: '/:uid/likes',
        pageBuilder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return _buildPage(
              child: ProfileLikesScreen(
            uid: uid,
            type: showAppStyleOption
                ? PostsListType.values[appSettings.appStyle ?? 1]
                : postsListType,
          ));
        },
      ),
      GoRoute(
        path: '/profile/:uid',
        pageBuilder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return _buildPage(
            child: CustomProfileScreen(
              uid: uid,
            ),
            // isFullScreen: true,
          );
        },
      ),
      GoRoute(
        path: '/comment/:commentId/likes',
        pageBuilder: (context, state) {
          final commentId = state.pathParameters['commentId'];
          return _buildPage(
            child: LikeUsersScreen(
              isCommentLikes: true,
              postCommentId: commentId,
              isDislike: false,
            ),
            // isFullScreen: true,
          );
        },
      ),
      GoRoute(
        path: '/comment/:commentId/dislikes',
        pageBuilder: (context, state) {
          final commentId = state.pathParameters['commentId'];
          return _buildPage(
            child: LikeUsersScreen(
              isCommentLikes: true,
              postCommentId: commentId,
              isDislike: true,
            ),
            // isFullScreen: true,
          );
        },
      ),
      GoRoute(
        path: '/fullImage',
        pageBuilder: (context, state) {
          String imageUrl = state.uri.queryParameters['imageUrl']!;
          if (imageUrl.startsWith('https://firebasestorage.googleapis.com/')) {
            imageUrl =
                state.uri.toString().replaceAll('/fullImage?imageUrl=', '');
            final splits = imageUrl.split('/o/');
            imageUrl = '${splits[0]}/o/${splits[1].replaceAll('/', '%2f')}';
          }

          final multiImages = state.extra as MultiImages?;
          return _buildPage(
              child: FullImageScreen(
            imageUrl: imageUrl,
            imageUrlsList: multiImages?.imageUrlsList,
            currentIndex: multiImages?.currentIndex,
          ));
        },
      ),
      GoRoute(
        path: '/fullVideo',
        pageBuilder: (context, state) {
          String videoUrl = state.uri.queryParameters['videoUrl']!;
          if (videoUrl.startsWith('https://firebasestorage.googleapis.com/')) {
            videoUrl =
                state.uri.toString().replaceAll('/fullVideo?videoUrl=', '');
            final splits = videoUrl.split('/o/');
            videoUrl = '${splits[0]}/o/${splits[1].replaceAll('/', '%2f')}';
          }

          final controller = state.extra as VideoPlayerController?;
          return _buildPage(
              child: FullVideoScreen(
            videoUrl: videoUrl,
            videoController: controller,
          ));
        },
      ),
      GoRoute(
        path: '/privacy',
        pageBuilder: (context, state) {
          return _buildPage(child: const AppPrivacyScreen());
        },
      ),
      GoRoute(
        path: '/terms',
        pageBuilder: (context, state) {
          return _buildPage(child: const AppTermsScreen());
        },
      ),
      GoRoute(
        path: '/appInfo',
        pageBuilder: (context, state) {
          final thisYear = DateTime.now().year;
          final legalese = '© $thisYear $appCreator';
          return _buildPage(
              child: LicensePage(
            applicationName: fullAppName,
            applicationLegalese: legalese,
            applicationVersion: appVersion,
          ));
        },
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
        child: ErrorScaffold(
      errorMessage: context.loc.pageNotFound,
      isHome: true,
    )),
  );
}

// Screen transitions branch depending on the target platform
// 타겟플램폼에 따라 스크린 트랜지션 분기
Page<dynamic> _buildPage({
  required Widget child,
  bool isFullScreen = false,
}) {
  // Extra page shown when swiping back in Safari on iOS
  // To temporarily resolve this issue,
  // use NoTransitionPage on the web on apple devices.
  // If it is resolved in flutter, we will change.

  // final isIosWeb = kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  /*
  final isApple = defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
  */
  final isAppleWeb = kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);
  final isAppleNative = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);
  /*
  final isAndOrWin = defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.windows;
  */

  if (isAppleWeb) {
    return NoTransitionPage(
      child: child,
    );
  }
  if (isAppleNative) {
    return CupertinoPage(
      child: child,
    );
  }
  /*
  if (isAndOrWin) {
    return CustomTransitionPage(
      fullscreenDialog: isFullScreen,
      transitionsBuilder: isFullScreen
          ? buildVerticalSlideTransitiron
          : buildHorizontalSlideTransitiron,
      child: child,
    );
  }
  */
  return MaterialPage(
    child: child,
    fullscreenDialog: isFullScreen,
  );
}

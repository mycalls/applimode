// lib/src/routing/app_router.dart

import 'dart:developer' as dev;

// flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/app_settings/app_settings_controller.dart';
import 'package:applimode_app/src/core/constants/constants.dart';

// routing
import 'package:applimode_app/src/routing/go_router_refresh_stream.dart';
import 'package:applimode_app/src/routing/maintenance_screen.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/multi_images.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/error_widgets/error_scaffold.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/full_image_screen.dart';
import 'package:applimode_app/src/common_widgets/video_player/full_video_screen.dart';

// features
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/admin_settings/presentation/admin_settings_screen.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/presentation/app_user_check_screen.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_email_verifacation_screen.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_phone_screen.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_sign_in_screen.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_screen.dart';
import 'package:applimode_app/src/features/editor/presentation/editor_screen.dart';
import 'package:applimode_app/src/features/like_users/like_users_screen.dart';
import 'package:applimode_app/src/features/policies/app_privacy_screen.dart';
import 'package:applimode_app/src/features/policies/app_terms_screen.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/post_screen/post_screen.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_screen/main_posts_screen.dart';
import 'package:applimode_app/src/features/posts/presentation/search_screen/search_screen.dart';
import 'package:applimode_app/src/features/posts/presentation/sub_posts_screen/sub_posts_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/change_email_screen/change_email_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/change_password_screen/change_password_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/edit_bio_screen/edit_bio_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/edit_username_screen/edit_username_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_comments_screen/profile_comments_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_likes_screen/profile_likes_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_posts_screen/profile_posts_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_screen.dart';
import 'package:applimode_app/src/features/ranking/ranking_screen.dart';

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
  static String appError = '/error';

  // 이메일 인증용. 추후 위치 변경할 것
  static String verifyEmail = '/verify-email';
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
      // This redirect function is called before any navigation occurs.
      // It allows us to change the navigation target based on application state (e.g., auth, maintenance).
      // 이 리다이렉트 함수는 네비게이션이 발생하기 전에 호출됩니다.
      // 이를 통해 애플리케이션 상태(예: 인증, 유지보수 모드)에 따라 네비게이션 대상을 변경할 수 있습니다.
      try {
        final user = authRepository.currentUser;
        final isLoggedIn = user != null;
        final isMaintenance = adminSettings.isMaintenance;
        final path = state.uri.path;
        dev.log('initial path: $path');

        // Handle maintenance mode
        // 유지보수 모드 처리
        if (isMaintenance && path != ScreenPaths.maintenance) {
          // 비로그인 사용자는 처리
          if (!isLoggedIn) {
            return ScreenPaths.maintenance;
          }
          // 로그인 사용자 처리
          if (isLoggedIn) {
            // If in maintenance, only allow admins to proceed.
            // Otherwise, redirect to the maintenance screen.
            // 유지보수 모드에서는 관리자만 접근을 허용합니다.
            // 관리자가 아니거나 사용자 정보를 가져올 수 없는 경우 유지보수 화면으로 리다이렉트합니다.
            // 관리자 또한 현재 조건을 통과 하더라도 하단의 접근 조건을 통과해야만 원하는 경로로 이동할 수 있습니다.
            // 비동기 실행에 대해 문제 삼지 않을것. 이것은 매우 특수한 상황.
            // 사이트가 마비되어 정비 안내 페이지가 뜬 상태에서 관리자인지 체크하는 매우 특별한 상황.
            // 관리자 확인은 auth의 사용자가 아닌 firestore의 사용자 테이블에서 확인.
            // 비동기 작업이 아닌 경우는 사용자의 상태를 확인할수 없음.
            // 예를 들어 앱을 완전히 종료했다 들어갔는데 정비페이지가 뜨는 상황이라면
            // 동기작업으로 그 사용자가 현재 관리자인지 아닌지는 절대로 알수가 없음.
            final appUser =
                await ref.read(appUserDataProvider(user.uid).future);
            // If appUser is null (e.g., data fetch failed or user document doesn't exist)
            // or the user is not an admin, redirect to maintenance.
            // appUser가 null이거나(예: 데이터 가져오기 실패 또는 사용자 문서 없음) 사용자가 관리자가 아니면 유지보수 화면으로 리다이렉트합니다.
            if (appUser == null || !appUser.isAdmin) {
              return ScreenPaths.maintenance;
            }
            // 관리자일 경우 그대로 플로우를 타도록 둘것. 굳이 여기서 null을 반환에서 플로우를 빠져나가 않아야 함
          }
        }
        // If not in maintenance mode, but the user is trying to access the maintenance page,
        // redirect them to the home page.
        // 유지보수 모드가 아닌데 사용자가 유지보수 페이지에 접근하려고 하면 홈 페이지로 리다이렉트합니다.
        if (!isMaintenance) {
          if (path == ScreenPaths.maintenance) {
            return ScreenPaths.home;
          }
        }

        // Handle Logged-Out Users
        // 비로그인 사용자 처리
        if (!isLoggedIn) {
          // when access restriction is enable, logged out users can access to public paths
          // 접근 제한이 활성화 된 경우, 공개된 경로만 접근
          if (isInitialSignIn || isEmailVerified) {
            final publicPaths = <String>[
              ScreenPaths.firebaseSignIn,
              ScreenPaths.phone,
              ScreenPaths.verifyEmail,
              ScreenPaths.appError,
              ScreenPaths.maintenance,
            ];
            if (!publicPaths.contains(path)) {
              return ScreenPaths.firebaseSignIn;
            }
          }

          // logged out users can not access to the write page
          // 비로그인 사용자의 글쓰기 페이지 접근시 로그인 페이지로 이동
          if (path == ScreenPaths.write) {
            return ScreenPaths.firebaseSignIn;
          }
        }

        // Handle Logged-In Users
        // 로그인 사용자 처리
        if (isLoggedIn) {
          // 인증필수시 미인증 로그인 사용자 처리
          // isEmailVerified 설정이 true일 경우 미인증 로그인 사용자는 인증페이지로 이동
          final isVerified = user.emailVerified || user.phoneNumber != null;
          if (isEmailVerified && !isVerified) {
            final allowedPaths = <String>[
              ScreenPaths.verifyEmail,
              ScreenPaths.appError,
              ScreenPaths.maintenance,
            ];
            if (!allowedPaths.contains(path)) {
              return ScreenPaths.verifyEmail;
            }
          }

          /*
          // 사인인페이지에서 상태관리 직접 수행.
          // 위의 조건에 해당하지 않은 로그인 사용자가 로그인페이지에 접근할 경우 홈으로
          if (path == ScreenPaths.firebaseSignIn) {
            return ScreenPaths.home;
          }
          */
        }

        // If none of the above conditions are met, allow the navigation to proceed as requested.
        // 위의 조건에 해당하지 않으면 요청된 대로 네비게이션을 진행합니다.
        return null;
      } catch (e, st) {
        // If any error occurs during the redirect logic (e.g., network issue fetching user data),
        // log the error and redirect to a generic error screen.
        // 리다이렉트 로직 중 오류가 발생하면 (예: 사용자 데이터 가져오기 중 네트워크 문제), 오류를 기록하고 일반 오류 화면으로 리다이렉트합니다.
        debugPrint('Error during redirect: $e\n$st');
        if (state.uri.path != ScreenPaths.appError) {
          return ScreenPaths.appError;
        }
        return null;
      }
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
      // 이메일 인증 라우트
      GoRoute(
        path: ScreenPaths.verifyEmail,
        pageBuilder: (context, state) {
          return _buildPage(child: const FirebaseEmailVerificationScreen());
        },
      ),
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
      // Dynamically generate routes for each category defined in admin settings.
      // 관리자 설정에 정의된 각 카테고리에 대한 경로를 동적으로 생성합니다.
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
          final post = state.extra as Post?;
          return _buildPage(
              child: PostScreen(
            postId: postId,
            post: post,
          ));
        },
        routes: [
          GoRoute(
            path: 'edit',
            pageBuilder: (context, state) {
              final postId = state.pathParameters['id'];
              final post = state.extra as Post?;
              return _buildPage(
                child: EditorScreen(
                  postId: postId,
                  post: post,
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
              return _buildPage(
                child: PostCommentsScreen(
                  postId: postId,
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
          // This manipulation is to handle cases where the imageUrl from Firebase Storage
          // might have slashes in its path that get decoded by Uri.parse,
          // potentially breaking the URL if used directly.
          // Re-encoding ensures the URL remains valid for Firebase Storage.
          // 이 조작은 Firebase Storage의 imageUrl 경로에 있는 슬래시가 Uri.parse에 의해 디코딩되어
          // URL을 직접 사용할 경우 문제가 발생할 수 있는 경우를 처리하기 위한 것입니다.
          // 다시 인코딩하면 Firebase Storage에 대해 URL이 유효하게 유지됩니다.
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
          // Similar to imageUrl, this ensures Firebase Storage video URLs with slashes
          // in their object paths are correctly handled after URI parsing.
          // imageUrl과 유사하게, 이 로직은 URI 파싱 후 객체 경로에 슬래시가 있는
          // Firebase Storage 비디오 URL이 올바르게 처리되도록 보장합니다.
          if (videoUrl.startsWith('https://firebasestorage.googleapis.com/')) {
            videoUrl =
                state.uri.toString().replaceAll('/fullVideo?videoUrl=', '');
            final splits = videoUrl.split('/o/');
            videoUrl = '${splits[0]}/o/${splits[1].replaceAll('/', '%2f')}';
          }

          final data = state.extra as Map<String, dynamic>;
          return _buildPage(
              child: FullVideoScreen(
            videoUrl: videoUrl,
            videoController: data['controller'],
            position: data['position'],
          ));
        },
      ),
      GoRoute(
        path: ScreenPaths.appPrivacy,
        pageBuilder: (context, state) {
          return _buildPage(child: const AppPrivacyScreen());
        },
      ),
      GoRoute(
        path: ScreenPaths.appTerms,
        pageBuilder: (context, state) {
          return _buildPage(child: const AppTermsScreen());
        },
      ),
      GoRoute(
        path: ScreenPaths.appInfo,
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
      GoRoute(
        path: ScreenPaths.appError,
        pageBuilder: (context, state) {
          // Generic error page for errors caught during redirection or other app-level issues.
          // 리다이렉션 중 발생한 오류 또는 기타 앱 수준 문제에 대한 일반 오류 페이지입니다.
          return _buildPage(
              child: ErrorScaffold(
            errorMessage: context.loc.tryLater,
            isHome: true,
          ));
        },
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
        // Fallback error page for when GoRouter cannot find a route.
        // GoRouter가 경로를 찾을 수 없을 때 사용되는 대체 오류 페이지입니다.
        child: ErrorScaffold(
      errorMessage: context.loc.pageNotFound,
      isHome: true,
    )),
  );
}

// Screen transitions branch depending on the target platform
// 대상 플랫폼에 따라 화면 전환 방식을 분기합니다.
Page<dynamic> _buildPage({
  required Widget child,
  bool isFullScreen = false,
}) {
  // Extra page shown when swiping back in Safari on iOS
  // iOS Safari에서 뒤로 스와이프할 때 추가 페이지가 표시되는 문제 해결

  // To temporarily resolve this issue,
  // use NoTransitionPage on the web on apple devices.
  // If it is resolved in flutter, we will change.
  // 이 문제를 일시적으로 해결하기 위해 Apple 기기의 웹에서는 NoTransitionPage를 사용합니다.
  // Flutter에서 이 문제가 해결되면 변경할 예정입니다.

  // final isIosWeb = kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  /*
  final isApple = defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
  */

  // Check if the app is running on the web on an Apple platform (iOS or macOS).
  // 앱이 Apple 플랫폼(iOS 또는 macOS)의 웹에서 실행 중인지 확인합니다.
  final isAppleWeb = kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);
  // Check if the app is running natively on an Apple platform (iOS or macOS).
  // 앱이 Apple 플랫폼(iOS 또는 macOS)에서 네이티브로 실행 중인지 확인합니다.
  final isAppleNative = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);
  /*
  final isAndOrWin = defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.windows;
  */

  if (isAppleWeb) {
    // Use NoTransitionPage for web on Apple devices to avoid swipe-back gesture issues in Safari.
    // Apple 기기의 웹에서는 Safari의 뒤로 스와이프 제스처 문제를 피하기 위해 NoTransitionPage를 사용합니다.
    return NoTransitionPage(
      child: child,
    );
  }
  if (isAppleNative) {
    // Use CupertinoPage for native iOS and macOS apps for native-feeling transitions.
    // 네이티브 iOS 및 macOS 앱에서는 네이티브 느낌의 전환을 위해 CupertinoPage를 사용합니다.
    return CupertinoPage(
      child: child,
    );
  }
  // Implement custom transitions for Android/Windows if needed.
  // 필요한 경우 Android/Windows용 사용자 정의 전환을 구현합니다.
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
  // Fallback to MaterialPage for other platforms (Android, Windows, Linux, Fuchsia web/native).
  // 다른 플랫폼(Android, Windows, Linux, Fuchsia 웹/네이티브)에서는 MaterialPage를 기본으로 사용합니다.
  return MaterialPage(
    child: child,
    fullscreenDialog: isFullScreen,
  );
}

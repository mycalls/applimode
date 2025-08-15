// lib/src/features/authentication/presentation/firebase_sign_in_screen.dart

import 'dart:developer' as dev;

// flutter

import 'package:flutter/material.dart';

// external
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// core
import 'package:applimode_app/custom_settings.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/sized_circular_progress_indicator.dart';

// features
import 'package:applimode_app/src/features/authentication/presentation/auth_footer.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_phone_screen.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_sign_in_screen_controller.dart';

class FirebaseSignInScreen extends ConsumerWidget {
  const FirebaseSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authProviders = ref.watch(authProvidersProvider);
    final controller =
        ref.watch(firebaseSignInScreenControllerProvider.notifier);
    final controllerState = ref.watch(firebaseSignInScreenControllerProvider);

    ref.listen(firebaseSignInScreenControllerProvider, (_, state) {
      state.showAlertDialogOnError(context,
          content: context.loc.failedInitializing);
    });

    ErrorText.localizeError = (BuildContext context, FirebaseAuthException e) {
      debugPrint(e.code);
      return switch (e.code) {
        'invalid-email' => context.loc.invalidEmail,
        'email-already-in-use' => context.loc.emailAlreadyInUse,
        'weak-password' => context.loc.weakPassword,
        'user-disabled' => context.loc.userDisabled,
        'user-not-found' => context.loc.userNotFound,
        'credential-already-in-use' => context.loc.emailAlreadyInUse,
        'wrong-password' => context.loc.wrongPassword,
        'invalid-login-credentials' => context.loc.invalidLoginCredentials,
        'invalid-credential' => context.loc.invalidCredential,
        // in phone auth, the error message shows up and goes away
        // _ => context.loc.unknownIssueWithAuth,
        _ => '',
      };
    };
    return Scaffold(
      appBar: AppBar(),
      // appBar: AppBar(title: const Text('Welcome')),
      body: controllerState.isLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedCircularProgressIndicator(),
                const SizedBox(height: 4),
                Text(
                  context.loc.initializing,
                  textAlign: TextAlign.center,
                ),
              ],
            ))
          : SignInScreen(
              // providers: authProviders,
              styles: const {
                EmailFormStyle(signInButtonVariant: ButtonVariant.filled)
              },
              footerBuilder: (context, action) {
                if (action == AuthAction.signUp) {
                  return SignUpFooter();
                }
                return const SizedBox.shrink();
              },
              actions: [
                // 사용자 로그인
                AuthStateChangeAction<SignedIn>(
                  (_, state) async {
                    dev.log('AuthStateChangeAction<SignedIn>: ${state.user}');
                    // 불가능하지만 사용자가 null일 경우 콜백 탈출
                    if (state.user == null) {
                      return;
                    }
                    // 이메일 인증 필수 설정에 인증이 안된 사용자
                    if (isEmailVerified && !state.user!.emailVerified) {
                      // 현재 창 네비게이션 스택에서 제외
                      Router.neglect(context, () {
                        context.go(ScreenPaths.verifyEmail);
                      });
                    } else {
                      await controller.initializeAppUsr();
                      if (context.mounted) {
                        Router.neglect(context, () {
                          context.go(ScreenPaths.home);
                        });
                      }
                    }
                    // controller.initializeAppUsr();
                    // context.go(ScreenPaths.appUserCheck);
                  },
                ),
                AuthStateChangeAction<UserCreated>((_, state) async {
                  dev.log(
                      'AuthStateChangeAction<UserCreated>: ${state.credential.user}');
                  // 사용자 가입
                  final user = state.credential.user;
                  if (user == null) {
                    return;
                  }
                  if (isEmailVerified && !user.emailVerified) {
                    Router.neglect(context, () {
                      context.go(ScreenPaths.verifyEmail);
                    });
                  } else {
                    await controller.initializeAppUsr();
                    user.sendEmailVerification().catchError((e) {
                      dev.log("Failed to send verification email", error: e);
                    });
                    if (context.mounted) {
                      Router.neglect(context, () {
                        context.go(ScreenPaths.home);
                      });
                    }
                  }
                  // controller.initializeAppUsr();
                  // context.go(ScreenPaths.appUserCheck);
                }),
                VerifyPhoneAction((_, __) {
                  // context.push(ScreenPaths.phone);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FirebasePhoneScreen()));
                })
              ],
            ),
    );
  }
}

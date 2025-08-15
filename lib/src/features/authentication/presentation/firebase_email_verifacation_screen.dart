// lib/src/features/authentication/presentation/firebase_email_verifacation_screen.dart

import 'dart:async';
import 'dart:developer' as dev;

// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// core
// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/responsive_widget.dart';
import 'package:applimode_app/src/common_widgets/sized_circular_progress_indicator.dart';

// features
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_email_verifacation_notifiers.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_sign_in_screen_controller.dart';

class FirebaseEmailVerificationScreen extends ConsumerStatefulWidget {
  const FirebaseEmailVerificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FirebaseEmailVerificationScreenState();
}

class _FirebaseEmailVerificationScreenState
    extends ConsumerState<FirebaseEmailVerificationScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 주기적으로 이메일 인증 상태를 확인하기 위해 타이머를 설정합니다.
    // initState에서 async 작업을 직접 호출하는 것은 권장되지 않으므로,
    // 첫 프레임이 렌더링 된 후에 호출하도록 합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendEmailVerification();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    dev.log('AppLifecycleState changed: $state');
    if (state == AppLifecycleState.resumed) {
      dev.log('AppLifecycleState resumed');
      _checkEmailVerification();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _sendEmailVerification() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null && !user.emailVerified) {
      ref.read(isResendLockProvider.notifier).setTrue();
      user.sendEmailVerification().catchError((e) {
        dev.log("Failed to send verification email", error: e);
      }).whenComplete(() {
        Future.delayed(const Duration(seconds: 10), () {
          if (mounted) {
            ref.read(isResendLockProvider.notifier).setFalse();
          }
        });
      });
    }
  }

  Future<void> _checkEmailVerification() async {
    dev.log('called _checkEmailVerification');
    if (!mounted) return;
    ref.read(isCheckLockProvider.notifier).setTrue();
    await ref
        .read(authRepositoryProvider)
        .currentUser
        ?.reload()
        .whenComplete(() {
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted) {
          ref.read(isCheckLockProvider.notifier).setFalse();
        }
      });
    });
    if (!mounted) return;
    final refreshedUser = ref.read(authRepositoryProvider).currentUser;
    dev.log('user: $refreshedUser');
    if (refreshedUser == null) {
      Router.neglect(context, () {
        context.go(ScreenPaths.firebaseSignIn);
      });
    } else {
      if (refreshedUser.emailVerified) {
        dev.log('Email verified. initialing user and navigating.');
        final controller =
            ref.read(firebaseSignInScreenControllerProvider.notifier);
        await controller.initializeAppUsr();

        // 마지막으로 context를 사용하기 전에도 mounted를 확인합니다.
        if (mounted) {
          Router.neglect(context, () {
            context.go(ScreenPaths.home);
          });
        }
      }
    }
  }

  Future<void> _handleBack() async {
    try {
      ref.read(isGoBackProvider.notifier).setTrue();
      await ref.read(authRepositoryProvider).currentUser?.delete();
      if (mounted) {
        Router.neglect(context, () {
          context.go(ScreenPaths.firebaseSignIn);
        });
      }
    } catch (e) {
      dev.log('can not delete user and go back');
    } finally {
      ref.read(isGoBackProvider.notifier).setFalse();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(firebaseSignInScreenControllerProvider, (_, state) {
      state.showAlertDialogOnError(context,
          content: context.loc.failedInitializing);
    });

    final controllerState = ref.watch(firebaseSignInScreenControllerProvider);
    final isGoingBack = ref.watch(isGoBackProvider);

    // 메일 다시 보내기 일정 시간 비활성화를 위한 상태
    final isResendLock = ref.watch(isResendLockProvider);

    // 인증 상태 체크 일정 시간 비활성화를 위한 상태
    final isCheckLock = ref.watch(isCheckLockProvider);

    return Scaffold(
      appBar: AppBar(),
      body: controllerState.isLoading || isGoingBack
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
          : SafeArea(
              child: ResponsiveCenterScrollView(
                maxContentWidth: 480,
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 24.0,
                  children: [
                    Text(
                      'Please click the verification link sent to your email and wait a moment.',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                        onPressed: isCheckLock ? null : _checkEmailVerification,
                        child: Text('Manually check verification status')),
                    ElevatedButton(
                        onPressed: isResendLock ? null : _sendEmailVerification,
                        child: Text('Resend verification email')),
                    ElevatedButton(
                        onPressed: _handleBack, child: Text('Go Back')),
                  ],
                ),
              ),
            ),
    );
  }
}

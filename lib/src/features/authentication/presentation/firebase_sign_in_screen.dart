import 'package:applimode_app/src/common_widgets/sized_circular_progress_indicator.dart';
import 'package:applimode_app/src/features/authentication/presentation/auth_footer.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_phone_screen.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_sign_in_screen_controller.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';

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
        _ => context.loc.unknownIssueWithAuth,
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
                AuthStateChangeAction<SignedIn>(
                  (context, state) {
                    controller.initializeAppUsr();
                    // context.go(ScreenPaths.appUserCheck);
                  },
                ),
                AuthStateChangeAction<UserCreated>((context, state) {
                  controller.initializeAppUsr();
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

// lib/src/features/authentication/presentation/firebase_phone_screen.dart

// flutter
import 'package:flutter/material.dart';

// external
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// core
// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/sized_circular_progress_indicator.dart';

// features
import 'package:applimode_app/src/features/authentication/presentation/auth_footer.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_sign_in_screen_controller.dart';

class FirebasePhoneScreen extends StatelessWidget {
  const FirebasePhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhoneInputScreen(
        footerBuilder: (context) {
          return SignUpFooter();
        },
        actions: [
          SMSCodeRequestedAction((context, action, flowKey, phoneNumber) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FirebaseSMSCodeInputScreen(
                  flowKey: flowKey,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class FirebaseSMSCodeInputScreen extends ConsumerWidget {
  const FirebaseSMSCodeInputScreen({super.key, required this.flowKey});

  final Object flowKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(firebaseSignInScreenControllerProvider, (_, state) {
      state.showAlertDialogOnError(context,
          content: context.loc.failedInitializing);
    });

    final controller =
        ref.watch(firebaseSignInScreenControllerProvider.notifier);
    final controllerState = ref.watch(firebaseSignInScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(),
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
          : SMSCodeInputScreen(
              headerBuilder: (context, constraints, shrinkOffset) =>
                  RecaptchaFooter(),
              flowKey: flowKey,
              actions: [
                AuthStateChangeAction<SignedIn>(
                  (_, __) async {
                    await controller.initializeAppUsr();
                    if (context.mounted) {
                      Router.neglect(context, () {
                        context.go(ScreenPaths.home);
                      });
                    }
                  },
                ),
                AuthStateChangeAction<UserCreated>((_, __) async {
                  await controller.initializeAppUsr();
                  if (context.mounted) {
                    Router.neglect(context, () {
                      context.go(ScreenPaths.home);
                    });
                  }
                }),
              ],
            ),
    );
  }
}

// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';

// features
import 'package:applimode_app/src/features/authentication/presentation/app_user_check_screen_controller.dart';

class AppUserCheckScreen extends ConsumerStatefulWidget {
  const AppUserCheckScreen({super.key});

  @override
  ConsumerState<AppUserCheckScreen> createState() => _AppUserCheckScreenState();
}

class _AppUserCheckScreenState extends ConsumerState<AppUserCheckScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(appUserCheckScreenControllerProvider.notifier)
          .initializeAppUsr();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appUserCheckScreenControllerProvider);
    ref.listen(appUserCheckScreenControllerProvider, (_, next) {
      next.showAlertDialogOnError(
        context,
        content: context.loc.failedInitializing,
      );
      if (!next.hasError) {
        context.go(ScreenPaths.home);
      }
    });
    return Scaffold(
      body: Center(
        child: state.isLoading
            ? const CircularProgressIndicator.adaptive()
            : TextButton(
                onPressed: () {
                  ref
                      .read(appUserCheckScreenControllerProvider.notifier)
                      .initializeAppUsr();
                },
                child: Text(context.loc.tryAgain),
              ),
      ),
    );
  }
}

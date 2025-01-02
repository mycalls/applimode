import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/common_widgets/error_widgets/error_scaffold.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/routing/app_startup_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:applimode_app/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // ignore: avoid_print
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  debugPrint('firebase init starts: ${DateTime.now()}');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('firebase init ends: ${DateTime.now()}');
  FirebaseUIAuth.configureProviders([
    if (fbAuthProviders.isEmpty ||
        fbAuthProviders.contains(FBAuthProvider.email.name))
      EmailAuthProvider(),
    if (fbAuthProviders.contains(FBAuthProvider.phone.name))
      PhoneAuthProvider(),
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await RemoteConfigService(FirebaseRemoteConfig.instance).initialize();
  usePathUrlStrategy();
  registerErrorHandlers();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(
    const ProviderScope(
      child: AppStartupWidget(),
    ),
  );
  FlutterNativeSplash.remove();
}

void registerErrorHandlers() {
  // Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const ErrorScaffold(
      errorMessage: 'Something is wrong. Please try later.',
      isHome: true,
    );
  };
}

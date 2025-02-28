import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:applimode_app/l10n/app_localizations.dart';
import 'package:applimode_app/src/app_settings/app_settings_controller.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/themes/app_theme_data.dart';
import 'package:applimode_app/src/utils/fcm_service.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // debugPrint('MaterialApp build');

    if (isUsableFcm()) {
      final fcmService = ref.watch(fcmServiceProvider);
      fcmService.setupToken();
      fcmService.setupInteractedMessage();
    }

    final goRouter = ref.watch(goRouterProvider);
    final appSettings = ref.watch(appSettingsControllerProvider);

    if (useAdminSettingsInterval) {
      ref.watch(adminSettingsServiceProvider).initialize();
    }
    final adminSettings = ref.watch(adminSettingsProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: fullAppName,
      routerConfig: goRouter,
      localizationsDelegates: [
        AppLocalizations.delegate,
        FirebaseUILocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: appSettings.appLocale,
      themeMode: appSettings.appThemeMode,
      theme: AppThemeData.themeData(
        brightness: Brightness.light,
        colorSchemeSeed: adminSettings.mainColor,
      ),
      darkTheme: AppThemeData.themeData(
        brightness: Brightness.dark,
        colorSchemeSeed: adminSettings.mainColor,
      ),
    );
  }
}

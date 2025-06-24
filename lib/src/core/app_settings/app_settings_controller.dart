// lib/src/core/app_settings/app_settings_controller.dart

// flutter
import 'package:flutter/material.dart';

// external
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/app_settings/app_settings.dart';
import 'package:applimode_app/src/core/constants/constants.dart';
import 'package:applimode_app/src/core/persistence/shared_preferences.dart';

part 'app_settings_controller.g.dart';

@riverpod
class AppSettingsController extends _$AppSettingsController {
  AppSettingsController();

  @override
  AppSettings build() {
    final sharedPreferences = ref.read(prefsWithCacheProvider).requireValue;
    final appThemeMode =
        ThemeMode.values[sharedPreferences.getInt('appThemeMode') ?? 0];
    final appLocaleString = sharedPreferences.getString('appLocale');
    final appLocale = appLocaleString == null ? null : Locale(appLocaleString);
    final appStyle =
        sharedPreferences.getInt('appStyle') ?? sparePostsListType.index;

    return AppSettings(
      appThemeMode: appThemeMode,
      appLocale: appLocale,
      appStyle: appStyle,
    );
  }

  Future<void> setAppThemeMode(ThemeMode theme) async {
    final sharedPreferences = ref.read(prefsWithCacheProvider).requireValue;
    await sharedPreferences.setInt('appThemeMode', theme.index);
    final appThemeMode =
        ThemeMode.values[sharedPreferences.getInt('appThemeMode') ?? 0];

    state = AppSettings(
      appThemeMode: appThemeMode,
      appLocale: state.appLocale,
      appStyle: state.appStyle,
    );
  }

  Future<void> setAppLocale(String languageCode) async {
    final sharedPreferences = ref.read(prefsWithCacheProvider).requireValue;
    await sharedPreferences.setString('appLocale', languageCode);
    final appLocaleString = sharedPreferences.getString('appLocale');
    final appLocale = appLocaleString == null ? null : Locale(appLocaleString);
    state = AppSettings(
      appThemeMode: state.appThemeMode,
      appLocale: appLocale,
      appStyle: state.appStyle,
    );
  }

  Future<void> removeAppLocale() async {
    final sharedPreferences = ref.read(prefsWithCacheProvider).requireValue;
    await sharedPreferences.remove('appLocale');
    state = AppSettings(
      appThemeMode: state.appThemeMode,
      appLocale: null,
      appStyle: state.appStyle,
    );
  }

  Future<void> setAppStyle(PostsListType postsListType) async {
    final sharedPreferences = ref.read(prefsWithCacheProvider).requireValue;
    await sharedPreferences.setInt('appStyle', postsListType.index);
    final appStyle =
        sharedPreferences.getInt('appStyle') ?? sparePostsListType.index;

    state = AppSettings(
      appThemeMode: state.appThemeMode,
      appLocale: state.appLocale,
      appStyle: appStyle,
    );
  }
}

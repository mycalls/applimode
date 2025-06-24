// lib/src/features/posts/presentation/posts_drawer/app_locale_button.dart

// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:applimode_app/l10n/app_localizations.dart';
import 'package:applimode_app/src/core/app_settings/app_settings_controller.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

// English: A widget that provides a button to change the application's locale (language).
// Korean: 애플리케이션의 로케일(언어)을 변경하는 버튼을 제공하는 위젯입니다.
class AppLocaleButton extends ConsumerWidget {
  const AppLocaleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // English: Get the list of supported locales for the application.
    // Korean: 애플리케이션에서 지원하는 로케일 목록을 가져옵니다.
    const locales = AppLocalizations.supportedLocales;
    // English: Watch the current app locale's language code from the settings controller.
    // Korean: 설정 컨트롤러에서 현재 앱 로케일의 언어 코드를 관찰합니다.
    final languageCode =
        ref.watch(appSettingsControllerProvider).appLocale?.languageCode;

    return MenuAnchor(
      style: const MenuStyle(
          padding:
              WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24))),
      builder: (context, controller, child) => ListTile(
        onTap: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            FocusScope.of(context).unfocus();
            controller.open();
          }
        },
        // English: Icon indicating language settings.
        // Korean: 언어 설정을 나타내는 아이콘입니다.
        leading: const Icon(Icons.language),
        // English: Title text for the language setting item.
        // Korean: 언어 설정 항목의 제목 텍스트입니다.
        title: Text(context.loc.appLanguage),
        // English: Trailing text showing the currently selected language or "System Language".
        // Korean: 현재 선택된 언어 또는 "시스템 언어"를 보여주는 후행 텍스트입니다.
        trailing: languageCode == null
            ? Text(context.loc.systemLanguage)
            : selectedLanguage(languageCode),
        leadingAndTrailingTextStyle: Theme.of(context).textTheme.labelLarge,
      ),
      menuChildren: [
        // English: Menu item to revert to the system's language setting.
        // Korean: 시스템 언어 설정으로 되돌리는 메뉴 항목입니다.
        MenuItemButton(
          onPressed: () {
            ref.read(appSettingsControllerProvider.notifier).removeAppLocale();
          },
          child: Text(context.loc.systemLanguage),
        ),
        // English: Generate menu items for each supported locale.
        // Korean: 지원되는 각 로케일에 대한 메뉴 항목을 생성합니다.
        ...locales.map(
          (locale) => MenuItemButton(
            onPressed: () {
              ref
                  .read(appSettingsControllerProvider.notifier)
                  .setAppLocale(locale.languageCode);
            },
            child: selectedLanguage(locale.languageCode),
          ),
        ),
      ],
    );
  }

  // English: Helper method to return a Text widget displaying the language name based on its code.
  // Korean: 언어 코드에 따라 언어 이름을 표시하는 Text 위젯을 반환하는 헬퍼 메소드입니다.
  Widget selectedLanguage(String langugaeCode) {
    // English: Maps language code to its display name.
    // Korean: 언어 코드를 표시 이름에 매핑합니다.
    switch (langugaeCode) {
      case 'en':
        return const Text('English');
      case 'ko':
        return const Text('한국어');
      case 'es':
        return const Text('Español');
      case 'ja':
        return const Text('日本語');
      case 'zh':
        return const Text('中文简体');
      default:
        return const Text('English');
    }
  }
}

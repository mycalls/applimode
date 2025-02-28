import 'package:applimode_app/src/app_settings/app_settings_controller.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/l10n/app_localizations.dart';

class AppLocaleButton extends ConsumerWidget {
  const AppLocaleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const locales = AppLocalizations.supportedLocales;
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
        leading: const Icon(Icons.language),
        title: Text(context.loc.appLanguage),
        trailing: languageCode == null
            ? Text(context.loc.systemLanguage)
            : selectedLanguage(languageCode),
        leadingAndTrailingTextStyle: Theme.of(context).textTheme.labelLarge,
      ),
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            ref.read(appSettingsControllerProvider.notifier).removeAppLocale();
          },
          child: Text(context.loc.systemLanguage),
        ),
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

  Widget selectedLanguage(String langugaeCode) {
    switch (langugaeCode) {
      case 'en':
        return const Text('English');
      case 'ko':
        return const Text('한국어');
      default:
        return const Text('English');
    }
  }
}

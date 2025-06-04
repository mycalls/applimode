// lib/src/features/posts/presentation/posts_drawer/app_theme_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/app_settings/app_settings_controller.dart';

// English: A widget that provides a button to change the application's theme (Light, Dark, System).
// Korean: 애플리케이션의 테마(라이트, 다크, 시스템)를 변경하는 버튼을 제공하는 위젯입니다.
class AppThemeButton extends ConsumerWidget {
  const AppThemeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // English: Watch the current app theme mode from the settings controller.
    // Korean: 설정 컨트롤러에서 현재 앱 테마 모드를 관찰합니다.
    final appThemeMode = ref.watch(appSettingsControllerProvider).appThemeMode;
    // English: Get the notifier for the app settings controller to update the theme mode.
    // Korean: 테마 모드를 업데이트하기 위해 앱 설정 컨트롤러의 notifier를 가져옵니다.
    final appThemeModeController =
        ref.watch(appSettingsControllerProvider.notifier);

    // English: Uses MenuAnchor to display a list tile that, when tapped, shows a menu of theme options.
    // Korean: MenuAnchor를 사용하여 탭하면 테마 옵션 메뉴를 표시하는 리스트 타일을 보여줍니다.
    return MenuAnchor(
      style: const MenuStyle(
          padding:
              WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24))),
      // English: Builds the ListTile that acts as the anchor for the menu.
      // Korean: 메뉴의 앵커 역할을 하는 ListTile을 빌드합니다.
      builder: (context, controller, child) => ListTile(
        onTap: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            FocusScope.of(context).unfocus();
            controller.open();
          }
        },
        // English: Icon representing theme settings (e.g., light mode).
        // Korean: 테마 설정(예: 라이트 모드)을 나타내는 아이콘입니다.
        leading: const Icon(Icons.light_mode_outlined),
        // English: Title for the app theme setting.
        // Korean: 앱 테마 설정의 제목입니다.
        title: Text(context.loc.appTheme),
        // English: Displays the name of the currently selected theme mode.
        // Korean: 현재 선택된 테마 모드의 이름을 표시합니다.
        trailing: Text(_getThemeModeLabel(context, appThemeMode)),
        leadingAndTrailingTextStyle: Theme.of(context).textTheme.labelLarge,
      ),
      // English: Generates a list of MenuItemButton widgets for each available theme mode.
      // Korean: 사용 가능한 각 테마 모드에 대해 MenuItemButton 위젯 목록을 생성합니다.
      menuChildren: ThemeMode.values.map((themeMode) {
        return MenuItemButton(
          onPressed: () {
            // English: Sets the selected theme mode in the settings controller.
            // Korean: 선택한 테마 모드를 설정 컨트롤러에 설정합니다.
            appThemeModeController.setAppThemeMode(themeMode);
          },
          // English: Displays the localized name of the theme mode option.
          // Korean: 테마 모드 옵션의 현지화된 이름을 표시합니다.
          child: Text(_getThemeModeLabel(context, themeMode)),
        );
      }).toList(),
    );
  }

  // English: Helper method to get the localized string for a given ThemeMode.
  // Korean: 주어진 ThemeMode에 대한 현지화된 문자열을 가져오는 헬퍼 메소드입니다.
  String _getThemeModeLabel(BuildContext context, ThemeMode? mode) {
    // English: Maps the ThemeMode to its corresponding localized name.
    // Korean: ThemeMode를 해당 현지화된 이름에 매핑합니다.
    switch (mode) {
      case ThemeMode.light:
        return context.loc.lightThemeMode;
      case ThemeMode.dark:
        return context.loc.darkThemeMode;
      case ThemeMode.system:
      default: // Also handles null, defaulting to system theme label
        return context.loc.systemThemeMode;
    }
  }
}

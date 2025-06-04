// lib/src/features/posts/presentation/posts_drawer/app_style_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/app_settings/app_settings_controller.dart';

// English: A widget that provides a button to change the application's display style for post lists.
// Korean: 게시물 목록에 대한 애플리케이션의 표시 스타일을 변경하는 버튼을 제공하는 위젯입니다.
class AppStyleButton extends ConsumerWidget {
  const AppStyleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // English: Watch the current app style from the settings controller.
    // Korean: 설정 컨트롤러에서 현재 앱 스타일을 관찰합니다.
    // The 'appStyle' is an integer representing the index of PostsListType.
    // 'appStyle'은 PostsListType의 인덱스를 나타내는 정수입니다.
    final appStyle = ref.watch(appSettingsControllerProvider).appStyle;
    // English: Get the notifier for the app settings controller to update the style.
    // Korean: 스타일을 업데이트하기 위해 앱 설정 컨트롤러의 notifier를 가져옵니다.
    final appStyleController =
        ref.watch(appSettingsControllerProvider.notifier);

    // English: Uses MenuAnchor to display a list tile that, when tapped, shows a menu of style options.
    // Korean: MenuAnchor를 사용하여 탭하면 스타일 옵션 메뉴를 표시하는 리스트 타일을 보여줍니다.
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
        // English: Icon representing app style or layout.
        // Korean: 앱 스타일 또는 레이아웃을 나타내는 아이콘입니다.
        leading: const Icon(Icons.space_dashboard_outlined),
        // English: Title for the app style setting.
        // Korean: 앱 스타일 설정의 제목입니다.
        title: Text(context.loc.appStyle),
        // English: Displays the currently selected app style's name.
        // Defaults to 'mixedType' (index 4) if no style is set.
        // Korean: 현재 선택된 앱 스타일의 이름을 표시합니다.
        // 설정된 스타일이 없으면 'mixedType'(인덱스 4)으로 기본 설정됩니다.
        trailing: Text(
            getTrailingLabel(context, appStyle ?? PostsListType.mixed.index)),
        leadingAndTrailingTextStyle: Theme.of(context).textTheme.labelLarge,
      ),
      // English: Generates a list of MenuItemButton widgets for each available app style.
      // Korean: 사용 가능한 각 앱 스타일에 대해 MenuItemButton 위젯 목록을 생성합니다.
      menuChildren: PostsListType.values.map((style) {
        return MenuItemButton(
          onPressed: () {
            // English: Sets the selected app style in the settings controller.
            // Korean: 선택한 앱 스타일을 설정 컨트롤러에 설정합니다.
            appStyleController.setAppStyle(style);
          },
          // English: Displays the localized name of the style option.
          // Korean: 스타일 옵션의 현지화된 이름을 표시합니다.
          child: Text(getTrailingLabel(context, style.index)),
        );
      }).toList(),
    );
  }

  // English: Helper method to get the localized string for a given app style index.
  // Korean: 주어진 앱 스타일 인덱스에 대한 현지화된 문자열을 가져오는 헬퍼 메소드입니다.
  String getTrailingLabel(BuildContext context, int index) {
    // English: Maps the style index to its corresponding localized name.
    // Korean: 스타일 인덱스를 해당 현지화된 이름에 매핑합니다.
    switch (index) {
      case 0:
        return context.loc.listType;
      case 1:
        return context.loc.cardType;
      case 2:
        return context.loc.pageType;
      case 3:
        return context.loc.roundCardType;
      case 4:
        return context.loc.mixedType;
      default:
        return context.loc.mixedType;
    }
  }
}

// lib/src/features/posts/presentation/posts_app_bar/posts_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

// English: Defines constants for home bar styles.
// Korean: 홈 바 스타일에 대한 상수들을 정의합니다.

// English: Constant for home bar style: Text only.
// Korean: 홈 바 스타일 상수: 텍스트만.
const int kHomeBarStyleTextOnly = 0;
// English: Constant for home bar style: Image only.
// Korean: 홈 바 스타일 상수: 이미지만.
const int kHomeBarStyleImageOnly = 1;
// English: Constant for home bar style: Image and text.
// Korean: 홈 바 스타일 상수: 이미지와 텍스트.
const int kHomeBarStyleImageAndText = 2;

// English: A custom AppBar for the posts screen, adaptable as a normal or Sliver AppBar.
// Korean: 게시물 화면을 위한 사용자 정의 AppBar로, 일반 또는 Sliver AppBar로 사용 가능합니다.
class PostsAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const PostsAppBar({
    super.key,
    this.forceMaterialTransparency = false,
    this.foregroundColor,
    this.elevation,
    this.centerTitle,
    this.isSliver = false,
  });

  // English: If true, forces the AppBar's background to be transparent.
  // Korean: true인 경우 AppBar의 배경을 강제로 투명하게 만듭니다.
  final bool forceMaterialTransparency;
  final Color? foregroundColor;
  final double? elevation;
  final bool? centerTitle;
  // English: If true, renders as a SliverAppBar for use in CustomScrollView.
  // Korean: true인 경우 CustomScrollView 내에서 사용하기 위한 SliverAppBar로 렌더링됩니다.
  final bool isSliver;

  @override
  Size get preferredSize => const Size.fromHeight(mainScreenAppBarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminSettings = ref.watch(adminSettingsProvider);
    final homeBarStyle = adminSettings.homeBarStyle;
    final homeBarTitle = adminSettings.homeBarTitle;
    final homeBarImageUrl = adminSettings.homeBarImageUrl;
    final isMaintenance = adminSettings.isMaintenance;

    // English: Widget to be displayed as the title of the AppBar.
    // Korean: AppBar의 제목으로 표시될 위젯입니다.
    final Widget titleWidget = isMaintenance
        ? const MaintenanaceColumn()
        : PostsAppBarRow(
            homeBarTitle: homeBarTitle,
            homeBarStyle: homeBarStyle,
            homeBarImageUrl: homeBarImageUrl,
          );

    // English: List of actions for the AppBar.
    // Korean: AppBar를 위한 액션 목록입니다.
    final List<Widget> actionsList = _buildActions(context);

    if (isSliver) {
      // English: Renders as a SliverAppBar, typically used within a CustomScrollView.
      // Korean: CustomScrollView 내에서 주로 사용되는 SliverAppBar로 렌더링합니다.
      return SliverAppBar(
        title: titleWidget,
        forceMaterialTransparency: forceMaterialTransparency,
        foregroundColor: foregroundColor,
        elevation: elevation,
        centerTitle: centerTitle,
        actions: actionsList,
        // English: Ensures the AppBar becomes visible as soon as the user scrolls down.
        // Korean: 사용자가 아래로 스크롤하는 즉시 AppBar가 보이도록 합니다.
        floating: true,
        // pinned: false, // Default
        // snap: false, // Default. Consider setting to true if you want the AppBar to snap into view.
      );
    } else {
      // English: Renders as a standard AppBar.
      // Korean: 표준 AppBar로 렌더링합니다.
      return AppBar(
        title: titleWidget,
        forceMaterialTransparency: forceMaterialTransparency,
        foregroundColor: foregroundColor,
        elevation: elevation,
        centerTitle: centerTitle,
        actions: actionsList,
      );
    }
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      if (showSearchButton)
        IconButton(
          onPressed: () => context.push(ScreenPaths.search),
          icon: const Icon(Icons.search),
        ),
    ];
  }
}

// English: A widget to display maintenance information in the AppBar.
// Korean: AppBar에 유지보수 정보를 표시하는 위젯입니다.
class MaintenanaceColumn extends StatelessWidget {
  const MaintenanaceColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.loc.maintenanceTitle,
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          context.loc.maintenanceAccess,
          style: Theme.of(context).textTheme.labelMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// English: A widget for the AppBar's title area, displaying a title and/or an image based on admin settings.
// Korean: 관리자 설정에 따라 제목 및/또는 이미지를 표시하는 AppBar의 제목 영역 위젯입니다.
class PostsAppBarRow extends StatelessWidget {
  const PostsAppBarRow({
    super.key,
    required this.homeBarTitle,
    required this.homeBarStyle,
    required this.homeBarImageUrl,
  });

  final String homeBarTitle;
  // English: Style of the home bar, determining layout of image and text.
  // (0: TextOnly, 1: ImageOnly, 2: ImageAndText)
  // Korean: 홈 바의 스타일로, 이미지와 텍스트의 레이아웃을 결정합니다.
  // (0: 텍스트만, 1: 이미지만, 2: 이미지와 텍스트)
  final int homeBarStyle;
  final String homeBarImageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // English: Display image if style is ImageOnly or ImageAndText.
        // Korean: 스타일이 이미지만(kHomeBarStyleImageOnly) 또는 이미지와 텍스트(kHomeBarStyleImageAndText)인 경우 이미지를 표시합니다.
        if (homeBarStyle == kHomeBarStyleImageOnly ||
            homeBarStyle == kHomeBarStyleImageAndText)
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: mainScreenAppBarPadding),
            child: SizedBox(
              height: mainScreenAppBarHeight - 2 * mainScreenAppBarPadding,
              child: homeBarImageUrl.startsWith('assets')
                  // English: Display image from local assets.
                  // Korean: 로컬 에셋에서 이미지를 표시합니다.
                  ? Image.asset(homeBarImageUrl)
                  // English: Display image from network.
                  // Korean: 네트워크에서 이미지를 표시합니다.
                  : PlatformNetworkImage(
                      imageUrl: homeBarImageUrl,
                      /*
                        cacheHeight: (mainScreenAppBarHeight -
                                2 * mainScreenAppBarPadding)
                            .round(),
                        */
                      errorWidget: const SizedBox
                          .shrink(), // English: Show nothing on error. Korean: 오류 시 아무것도 표시하지 않음.
                    ),
            ),
          ),
        // English: Add spacing if style is ImageAndText (which implies both image and text are present).
        // Korean: 스타일이 이미지와 텍스트(kHomeBarStyleImageAndText)인 경우 (이미지와 텍스트가 모두 있음을 의미) 간격을 추가합니다.
        if (homeBarStyle == kHomeBarStyleImageAndText) const SizedBox(width: 8),
        // English: Display text if style is TextOnly or ImageAndText.
        // Korean: 스타일이 텍스트만(kHomeBarStyleTextOnly) 또는 이미지와 텍스트(kHomeBarStyleImageAndText)인 경우 텍스트를 표시합니다.
        if (homeBarStyle == kHomeBarStyleTextOnly ||
            homeBarStyle == kHomeBarStyleImageAndText)
          Text(homeBarTitle),
      ],
    );
  }
}

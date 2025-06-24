// lib/src/routing/maintenance_screen.dart

// flutter
import 'package:flutter/material.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

// English: A screen displayed when the application is in maintenance mode.
// Korean: 애플리케이션이 유지보수 모드일 때 표시되는 화면입니다.
class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // English: Use a color from the current theme for visual consistency.
    // Korean: 시각적 일관성을 위해 현재 테마의 색상을 사용합니다.
    final mainColor = Theme.of(context).colorScheme.primaryFixedDim;
    return Scaffold(
      appBar: AppBar(
        // English: Localized title for the maintenance screen.
        // Korean: 유지보수 화면을 위한 현지화된 제목입니다.
        title: Text(context.loc.maintenanceTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // English: Icon indicating maintenance.
            // Korean: 유지보수를 나타내는 아이콘입니다.
            Icon(
              Icons.build_circle_outlined,
              size: 64,
              color: mainColor,
              // English: Semantic label for accessibility, describing the icon's purpose.
              // Korean: 접근성을 위한 시맨틱 레이블로, 아이콘의 목적을 설명합니다.
              semanticLabel: context.loc.maintenanceTitle,
            ),
            const SizedBox(height: 16),
            // English: Localized message explaining the maintenance status.
            // Korean: 유지보수 상태를 설명하는 현지화된 메시지입니다.
            Text(
              context.loc.maintenanceMessage,
              textAlign:
                  TextAlign.center, // Ensure text is centered if it wraps
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  // English: Apply the theme's text style and override the color.
                  // Korean: 테마의 텍스트 스타일을 적용하고 색상을 재정의합니다.
                  ?.copyWith(color: mainColor),
            ),
          ],
        ),
      ),
    );
  }
}

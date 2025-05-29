// lib/src/routing/app_startup_widget.dart

import 'package:applimode_app/src/app.dart';
import 'package:applimode_app/src/routing/app_startup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// English: Widget that handles the application's startup process.
// Korean: 애플리케이션의 시작 프로세스를 처리하는 위젯입니다.
class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // English: Watch the state of the app startup provider.
    // Korean: 앱 시작 프로바이더의 상태를 감시합니다.
    final appStartupState = ref.watch(appStartupProvider);
    // English: Handle the different states of app startup: data, error, and loading.
    // Korean: 앱 시작의 여러 상태(데이터, 오류, 로딩)를 처리합니다.
    return appStartupState.when(
        // English: When data is available (startup successful), show the main app.
        // Korean: 데이터가 준비되면(시작 성공 시) 메인 앱을 표시합니다.
        data: (_) => const MyApp(),
        // English: When an error occurs during startup, show the error widget.
        // Korean: 시작 중 오류 발생 시 오류 위젯을 표시합니다.
        error: (e, st) {
          // English: Log the error for debugging purposes.
          // Korean: 디버깅 목적으로 오류를 기록합니다.
          debugPrint('App startup error: $e\n$st');
          return AppStartupErrorWidget(
            // English: Provide a callback to retry the startup process.
            // Korean: 시작 프로세스를 재시도할 수 있는 콜백을 제공합니다.
            onRetry: () => ref.invalidate(appStartupProvider),
          );
        },
        loading: () => const AppStartupLoadingWidget());
  }
}

// English: Widget to display a loading indicator during app startup.
// Korean: 앱 시작 중 로딩 인디케이터를 표시하는 위젯입니다.
class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // English: When using Material widgets, the screen changes too much depending on the theme.
    // Korean: Material 위젯을 사용할 경우 테마별로 화면 변화가 너무 심함
    return Center(child: CupertinoActivityIndicator());
  }
}

class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget({
    super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    // English: Using Material widget to provide a proper canvas for Material Design widgets,
    // Korean: Material Design 위젯(Text, Icon, ElevatedButton)에 적절한 캔버스를 제공하기 위해 Material 위젯을 사용합니다.
    // English: ensuring they have correct styling, especially as this widget appears before the main MaterialApp.
    // Korean: 특히 이 위젯이 메인 MaterialApp보다 먼저 나타나므로 올바른 스타일을 갖도록 보장합니다.
    return Material(
      child: Center(
        // English: Ensures correct layout for text and icons based on text direction.
        // Korean: 텍스트 방향에 따라 텍스트와 아이콘의 올바른 레이아웃을 보장합니다.
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Consistent padding value
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 60,
                ),
                const SizedBox(height: 16.0),
                // English: User-friendly message indicating an error occurred.
                // Korean: 오류가 발생했음을 알리는 사용자 친화적인 메시지입니다.
                const Text(
                  'Oops! Something went wrong while starting the app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
                const SizedBox(height: 32.0),
                // English: Button to allow the user to retry the app startup.
                // Korean: 사용자가 앱 시작을 재시도할 수 있도록 하는 버튼입니다.
                ElevatedButton.icon(
                  onPressed:
                      onRetry, // Callback to execute when the button is pressed. / 버튼을 눌렀을 때 실행될 콜백입니다.
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/src/routing/app_startup.dart

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/persistence/shared_preferences.dart';

// features
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';

part 'app_startup.g.dart';

@Riverpod(keepAlive: true)
FutureOr<void> appStartup(Ref ref) async {
  // English: Register a callback to be executed when this provider is disposed.
  // Korean: 이 프로바이더가 폐기될 때 실행될 콜백을 등록합니다.
  ref.onDispose(() {
    // English: Invalidate the SharedPreferences provider when appStartupProvider is disposed.
    // This is crucial for the retry mechanism in AppStartupWidget. If appStartup fails
    // and is retried (by invalidating appStartupProvider), we also want to ensure
    // that SharedPreferences are re-initialized, as their initial loading might have
    // contributed to the failure or their state needs to be fresh for the new attempt.
    // Korean: appStartupProvider가 폐기될 때 SharedPreferences 프로바이더를 무효화합니다.
    // 이는 AppStartupWidget의 재시도 메커니즘에 중요합니다. 만약 appStartup이 실패하고
    // 재시도될 경우(appStartupProvider를 무효화함으로써), SharedPreferences 또한
    // 다시 초기화되도록 보장해야 합니다. 초기 로딩이 실패의 원인이었거나
    // 새로운 시도를 위해 상태가 최신이어야 할 수 있기 때문입니다.
    ref.invalidate(prefsWithCacheProvider);
  });
  // English: Await the initialization of SharedPreferences.
  // `ref.watch` is used here to establish a dependency. If `prefsWithCacheProvider`
  // were to re-evaluate (e.g., due to external invalidation, though less likely for a
  // keepAlive provider unless done explicitly), `appStartupProvider` would also re-evaluate.
  // Korean: SharedPreferences 초기화를 기다립니다.
  // 여기서 `ref.watch`를 사용하여 의존성을 설정합니다. 만약 `prefsWithCacheProvider`가
  // (예: 외부적인 무효화로 인해, 비록 keepAlive 프로바이더의 경우 명시적으로 수행되지 않는 한
  // 가능성은 낮지만) 재평가된다면, `appStartupProvider` 또한 재평가될 것입니다.
  await ref.watch(prefsWithCacheProvider.future);
  // English: Conditionally fetch admin settings if not configured for interval-based updates.
  // This typically handles a one-time fetch during the initial startup.
  // Korean: 인터벌 기반 업데이트로 설정되지 않은 경우 조건부로 관리자 설정을 가져옵니다.
  // 이는 일반적으로 초기 시작 시 일회성 가져오기를 처리합니다.
  if (!useAdminSettingsInterval) {
    // English: Use `ref.read` for a one-time action like fetching initial settings.
    // This does not establish a continuous watch on `adminSettingsServiceProvider`.
    // Korean: 초기 설정 가져오기와 같은 일회성 작업을 위해 `ref.read`를 사용합니다.
    // 이는 `adminSettingsServiceProvider`에 대한 지속적인 감시를 설정하지 않습니다.
    await ref.read(adminSettingsServiceProvider).fetch();
  }
  // When initializing multiple providers at the same time
  /*
  await Future.wait([
    ref.watch(prefsWithCacheProvider.future),
  ]);
  */
}

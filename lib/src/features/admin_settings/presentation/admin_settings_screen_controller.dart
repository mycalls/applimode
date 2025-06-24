// lib/src/features/admin_settings/presentation/admin_settings_screen_controller.dart

// flutter
import 'package:flutter/widgets.dart';

// external
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// features
import 'package:applimode_app/src/features/admin_settings/domain/admin_settings.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';

part 'admin_settings_screen_controller.g.dart';

// Controller for the Admin Settings screen.
// Handles the business logic for saving admin settings and manages the screen's state.
// 관리자 설정 화면의 컨트롤러입니다.
// 관리자 설정 저장과 관련된 비즈니스 로직을 처리하고 화면의 상태를 관리합니다.
@riverpod
class AdminSettingsScreenController extends _$AdminSettingsScreenController {
  // Key to track the mounted state of the notifier. Helps prevent state updates after disposal.
  // notifier의 마운트 상태를 추적하는 키입니다. dispose 후 상태 업데이트를 방지하는 데 도움이 됩니다.
  // ignore: avoid_public_notifier_properties
  Object? key;

  // Initializes the controller.
  // 컨트롤러를 초기화합니다.
  @override
  FutureOr<void> build() {
    key = Object();
    // Clears the key when the notifier is disposed.
    // notifier가 dispose될 때 키를 제거합니다.
    ref.onDispose(() => key = null);
  }

  // Saves the provided admin settings.
  // 제공된 관리자 설정을 저장합니다.
  Future<bool> saveAdminSettings({
    required AdminSettings settings,
    XFile? xFile,
    String? mediaType,
  }) async {
    // Ensure the user is authenticated.
    // 사용자가 인증되었는지 확인합니다.
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('user is null'), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    final appUser = await ref.read(appUserDataProvider(user.uid).future);
    // Ensure the user is an admin.
    // 사용자가 관리자인지 확인합니다.
    if (appUser == null || !appUser.isAdmin) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return false;
    }

    final key = this.key;
    final newState = await AsyncValue.guard(
      // Call the service to save the settings.
      // 서비스를 호출하여 설정을 저장합니다.
      () => ref.read(adminSettingsServiceProvider).saveAdminSettings(
            settings: settings,
            xFile: xFile,
            mediaType: mediaType,
          ),
    );

    // Only update state if the notifier is still mounted.
    // notifier가 여전히 마운트된 경우에만 상태를 업데이트합니다.
    if (key == this.key) {
      state = newState;
    }

    // If there was an error during saving, log it and return false.
    // 저장 중 오류가 발생하면 로그를 남기고 false를 반환합니다.
    if (state.hasError) {
      debugPrint('save admin settings error: ${state.error.toString()}');
      return false;
    }

    // After successful save, fetch the latest settings to update the local cache (SharedPreferences).
    // 성공적으로 저장한 후, 최신 설정을 가져와 로컬 캐시(SharedPreferences)를 업데이트합니다.
    try {
      await ref.read(adminSettingsServiceProvider).fetch();
    } catch (e) {
      debugPrint('adminSettings init error: ${e.toString()}');
    }

    // Invalidate the adminSettingsProvider to ensure UI components listening to it will rebuild with the new settings.
    // adminSettingsProvider를 무효화하여 이를 수신하는 UI 구성 요소가 새 설정으로 다시 빌드되도록 합니다.
    ref.invalidate(adminSettingsProvider);

    // Return true indicating successful save and update.
    // 성공적인 저장 및 업데이트를 나타내는 true를 반환합니다.
    return true;
  }
}

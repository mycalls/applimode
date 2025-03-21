import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_settings_screen_controller.g.dart';

@riverpod
class AdminSettingsScreenController extends _$AdminSettingsScreenController {
  // ignore: avoid_public_notifier_properties
  Object? key;
  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<bool> saveAdminSettings({
    required String homeBarTitle,
    required int homeBarStyle,
    required String homeBarTitleImageUrl,
    required Color mainColor,
    required List<MainCategory> mainCategory,
    XFile? xFile,
    String? mediaType,
    required bool showAppStyleOption,
    required PostsListType postsListType,
    required BoxColorType boxColorType,
    required double mediaMaxMBSize,
    required bool useRecommendation,
    required bool useRanking,
    required bool useCategory,
    required bool showLogoutOnDrawer,
    required bool showLikeCount,
    required bool showDislikeCount,
    required bool showCommentCount,
    required bool showSumCount,
    required bool showCommentPlusLikeCount,
    required bool isThumbUpToHeart,
    required bool showUserAdminLabel,
    required bool showUserLikeCount,
    required bool showUserDislikeCount,
    required bool showUserSumCount,
    required bool isMaintenance,
    required bool adminOnlyWrite,
    required bool isPostsItemVideoMute,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('user is null'), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    final appUser = await ref.read(appUserFutureProvider(user.uid).future);
    if (appUser == null || !appUser.isAdmin) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return false;
    }

    final key = this.key;
    final newState = await AsyncValue.guard(
      () => ref.read(adminSettingsServiceProvider).saveAdminSettings(
            homeBarTitle: homeBarTitle,
            homeBarStyle: homeBarStyle,
            homeBarTitleImageUrl: homeBarTitleImageUrl,
            mainColor: mainColor,
            mainCategory: mainCategory,
            xFile: xFile,
            mediaType: mediaType,
            showAppStyleOption: showAppStyleOption,
            postsListType: postsListType,
            boxColorType: boxColorType,
            mediaMaxMBSize: mediaMaxMBSize,
            useRecommendation: useRecommendation,
            useRanking: useRanking,
            useCategory: useCategory,
            showLogoutOnDrawer: showLogoutOnDrawer,
            showLikeCount: showLikeCount,
            showDislikeCount: showDislikeCount,
            showCommentCount: showCommentCount,
            showSumCount: showSumCount,
            showCommentPlusLikeCount: showCommentPlusLikeCount,
            isThumbUpToHeart: isThumbUpToHeart,
            showUserAdminLabel: showUserAdminLabel,
            showUserLikeCount: showUserLikeCount,
            showUserDislikeCount: showUserDislikeCount,
            showUserSumCount: showUserSumCount,
            isMaintenance: isMaintenance,
            adminOnlyWrite: adminOnlyWrite,
            isPostsItemVideoMute: isPostsItemVideoMute,
          ),
    );

    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('save admin settings error: ${state.error.toString()}');
      return false;
    }

    try {
      await ref.read(adminSettingsServiceProvider).fetch();
    } catch (e) {
      debugPrint('adminSettings init error: ${e.toString()}');
    }

    ref.invalidate(adminSettingsProvider);

    return true;
  }
}

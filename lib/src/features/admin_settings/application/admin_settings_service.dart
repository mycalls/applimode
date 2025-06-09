// lib/src/features/admin_settings/application/admin_settings_service.dart

import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/shared_preferences.dart';
import 'package:applimode_app/src/features/admin_settings/data/admin_settings_repository.dart';
import 'package:applimode_app/src/features/admin_settings/domain/admin_settings.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/features/firebase_storage/firebase_storage_repository.dart';

part 'admin_settings_service.g.dart';

// Service class for managing admin settings.
// 관리자 설정을 관리하는 서비스 클래스입니다.
class AdminSettingsService {
  const AdminSettingsService(this._ref);

  final Ref _ref;

  SharedPreferencesWithCache get sharedPreferences =>
      _ref.read(prefsWithCacheProvider).requireValue;
  AdminSettingsRepository get adminSettingsRepository =>
      _ref.read(adminSettingsRepositoryProvider);

  // Saves the admin settings to the repository.
  // 관리자 설정을 저장소에 저장합니다.
  Future<void> saveAdminSettings({
    required AdminSettings settings,
    XFile? xFile,
    String? mediaType,
  }) async {
    String finalHomeBarImageUrl = settings.homeBarImageUrl;
    if (xFile != null) {
      finalHomeBarImageUrl = await _ref
          .read(firebaseStorageRepositoryProvider)
          .uploadXFile(
              file: xFile,
              storagePathname: appBarTitlePath,
              filename: 'app-bar-logo',
              contentType: mediaType ?? contentTypeJpeg);
    }

    await _ref.read(adminSettingsRepositoryProvider).createAdminSettings(
          homeBarTitle: settings.homeBarTitle,
          homeBarImageUrl: finalHomeBarImageUrl,
          homeBarStyle: settings.homeBarStyle,
          mainColor: settings.mainColor,
          mainCategory: settings.mainCategory,
          showAppStyleOption: settings.showAppStyleOption,
          postsListType: settings.postsListType,
          boxColorType: settings.boxColorType,
          mediaMaxMBSize: settings.mediaMaxMBSize,
          useRecommendation: settings.useRecommendation,
          useRanking: settings.useRanking,
          useCategory: settings.useCategory,
          showLogoutOnDrawer: settings.showLogoutOnDrawer,
          showLikeCount: settings.showLikeCount,
          showDislikeCount: settings.showDislikeCount,
          showCommentCount: settings.showCommentCount,
          showSumCount: settings.showSumCount,
          showCommentPlusLikeCount: settings.showCommentPlusLikeCount,
          isThumbUpToHeart: settings.isThumbUpToHeart,
          showUserAdminLabel: settings.showUserAdminLabel,
          showUserLikeCount: settings.showUserLikeCount,
          showUserDislikeCount: settings.showUserDislikeCount,
          showUserSumCount: settings.showUserSumCount,
          isMaintenance: settings.isMaintenance,
          adminOnlyWrite: settings.adminOnlyWrite,
          isPostsItemVideoMute: settings.isPostsItemVideoMute,
        );
  }

  // Initializes admin settings.
  // Fetches settings from the repository if the cached data is older than the defined interval.
  // 관리자 설정을 초기화합니다. 캐시된 데이터가 정의된 간격보다 오래된 경우 저장소에서 설정을 가져옵니다.
  Future<void> initialize() async {
    // dev.log('adminSettings init starts : ${DateTime.now()}');
    final lastModified =
        sharedPreferences.getInt(adminSettingsModifiedTimeKey) ?? 0;
    final durationInSeconds = Duration(
            milliseconds: DateTime.now().millisecondsSinceEpoch - lastModified)
        .inSeconds;
    dev.log('duration: $durationInSeconds');
    if (durationInSeconds > adminSettingsInterval.inSeconds) {
      fetch();
    } else {
      dev.log('adminSettings timelimit');
    }
    // dev.log('adminSettings init ends : ${DateTime.now()}');
  }

  // Helper method to update SharedPreferences with new AdminSettings.
  // 새로운 AdminSettings로 SharedPreferences를 업데이트하는 헬퍼 메서드입니다.
  void _updateSharedPreferences(AdminSettings settings) {
    sharedPreferences.setString(homeBarTitleKey, settings.homeBarTitle);
    sharedPreferences.setString(homeBarImageUrlKey, settings.homeBarImageUrl);
    sharedPreferences.setInt(homeBarStyleKey, settings.homeBarStyle);
    sharedPreferences.setString(
        mainColorKey, Format.colorToHexString(settings.mainColor));
    sharedPreferences.setString(mainCategoryKey,
        json.encode(settings.mainCategory.map((e) => e.toMap()).toList()));
    sharedPreferences.setBool(
        showAppStyleOptionKey, settings.showAppStyleOption);
    sharedPreferences.setInt(postsListTypeKey, settings.postsListType.index);
    sharedPreferences.setInt(boxColorTypeKey, settings.boxColorType.index);
    sharedPreferences.setDouble(mediaMaxMBSizeKey, settings.mediaMaxMBSize);
    sharedPreferences.setBool(useRecommendationKey, settings.useRecommendation);
    sharedPreferences.setBool(useRankingKey, settings.useRanking);
    sharedPreferences.setBool(useCategoryKey, settings.useCategory);
    sharedPreferences.setBool(
        showLogoutOnDrawerKey, settings.showLogoutOnDrawer);
    sharedPreferences.setBool(showLikeCountKey, settings.showLikeCount);
    sharedPreferences.setBool(showDislikeCountKey, settings.showDislikeCount);
    sharedPreferences.setBool(showCommentCountKey, settings.showCommentCount);
    sharedPreferences.setBool(showSumCountKey, settings.showSumCount);
    sharedPreferences.setBool(
        showCommentPlusLikeCountKey, settings.showCommentPlusLikeCount);
    sharedPreferences.setBool(isThumbUpToHeartKey, settings.isThumbUpToHeart);
    sharedPreferences.setBool(
        showUserAdminLabelKey, settings.showUserAdminLabel);
    sharedPreferences.setBool(showUserLikeCountKey, settings.showUserLikeCount);
    sharedPreferences.setBool(
        showUserDislikeCountKey, settings.showUserDislikeCount);
    sharedPreferences.setBool(showUserSumCountKey, settings.showUserSumCount);
    sharedPreferences.setBool(isMaintenanceKey, settings.isMaintenance);
    sharedPreferences.setBool(adminOnlyWriteKey, settings.adminOnlyWrite);
    sharedPreferences.setBool(
        isPostsItemVideoMuteKey, settings.isPostsItemVideoMute);
    sharedPreferences.setInt(
        adminSettingsModifiedTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  // Fetches admin settings from the repository and updates them in SharedPreferences if they have changed.
  // 저장소에서 관리자 설정을 가져오고 변경된 경우 SharedPreferences에 업데이트합니다.
  Future<void> fetch() async {
    try {
      // dev.log('adminSettings fetch starts : ${DateTime.now()}');
      final adminSettings = await adminSettingsRepository.fetchAdminSettings();
      // dev.log('adminSettings: $adminSettings');
      // dev.log('adminSettings update starts : ${DateTime.now()}');
      if (adminSettings != null) {
        // Get current admin settings from the provider to compare.
        // 비교를 위해 프로바이더에서 현재 관리자 설정을 가져옵니다.
        final deviceAdminSettings = _ref.read(adminSettingsProvider);

        if (adminSettings != deviceAdminSettings) {
          dev.log('admin settings update');
          _updateSharedPreferences(adminSettings);
        } else {
          dev.log('admin setting same');
          // Even if settings are the same, update the timestamp to reset the interval.
          // This ensures that if the app was closed for longer than the interval,
          // a fetch is attempted on next launch, but if settings are truly unchanged,
          // we don't do a full update, just refresh the timestamp.
          // 설정이 동일하더라도 타임스탬프를 업데이트하여 간격을 재설정합니다.
          // 이렇게 하면 앱이 간격보다 오래 닫혀 있었던 경우 다음 실행 시 가져오기를 시도하지만,
          // 설정이 실제로 변경되지 않은 경우 전체 업데이트를 수행하지 않고 타임스탬프만 새로 고칩니다.
          sharedPreferences.setInt(adminSettingsModifiedTimeKey,
              DateTime.now().millisecondsSinceEpoch);
        }
      }
      // dev.log('adminSettings update ends : ${DateTime.now()}');
    } catch (e) {
      dev.log('Failed to fetch adminSettings');
      debugPrint('adminSettings Fetch Fail: ${e.toString()}');
    }
  }

  /*
  Color get mainColor => Format.hexStringToColorForCat(
      sharedPreferences.getString(mainColorKey) ?? spareMainColor);

  String get homeBarTitle =>
      sharedPreferences.getString(homeBarTitleKey) ?? spareHomeBarTitle;

  String get homeBarImageUrl =>
      sharedPreferences.getString(homeBarImageUrlKey) ?? spareHomeBarImageUrl;

  int get homeBarStyle =>
      sharedPreferences.getInt(homeBarStyleKey) ?? spareHomeBarStyle;

  List<MainCategory> get mainCategory {
    final rawCategory =
        sharedPreferences.getString(mainCategoryKey) ?? spareMainCategory;
    final decoded = json.decode(rawCategory) as List<dynamic>;
    return decoded
        .map((e) => MainCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  */
}

// Riverpod provider for AdminSettingsService.
// AdminSettingsService를 위한 Riverpod 프로바이더입니다.
@riverpod
AdminSettingsService adminSettingsService(Ref ref) {
  return AdminSettingsService(ref);
}

// Riverpod provider that provides the current AdminSettings.
// 현재 AdminSettings를 제공하는 Riverpod 프로바이더입니다.
@riverpod
AdminSettings adminSettings(Ref ref) {
  final sharedPreferences = ref.watch(prefsWithCacheProvider).requireValue;
  return AdminSettings(
    homeBarTitle:
        sharedPreferences.getString(homeBarTitleKey) ?? spareHomeBarTitle,
    homeBarImageUrl:
        sharedPreferences.getString(homeBarImageUrlKey) ?? spareHomeBarImageUrl,
    homeBarStyle:
        sharedPreferences.getInt(homeBarStyleKey) ?? spareHomeBarStyle,
    mainColor: Format.hexStringToColor(
        sharedPreferences.getString(mainColorKey) ?? spareMainColor),
    mainCategory: (json.decode(sharedPreferences.getString(mainCategoryKey) ??
            spareMainCategory) as List<dynamic>)
        .map((e) => MainCategory.fromJson(e as Map<String, dynamic>))
        .toList(),
    showAppStyleOption: sharedPreferences.getBool(showAppStyleOptionKey) ??
        spareShowAppStyleOption,
    postsListType: PostsListType.values[
        sharedPreferences.getInt(postsListTypeKey) ?? sparePostsListType.index],
    boxColorType: BoxColorType.values[
        sharedPreferences.getInt(boxColorTypeKey) ?? spareBoxColorType.index],
    mediaMaxMBSize:
        sharedPreferences.getDouble(mediaMaxMBSizeKey) ?? spareMediaMaxMBSize,
    useRecommendation: sharedPreferences.getBool(useRecommendationKey) ??
        spareUseRecommendation,
    useRanking: sharedPreferences.getBool(useRankingKey) ?? spareUseRanking,
    useCategory: sharedPreferences.getBool(useCategoryKey) ?? spareUseCategory,
    showLogoutOnDrawer: sharedPreferences.getBool(showLogoutOnDrawerKey) ??
        spareShowLogoutOnDrawer,
    showLikeCount:
        sharedPreferences.getBool(showLikeCountKey) ?? spareShowLikeCount,
    showDislikeCount:
        sharedPreferences.getBool(showDislikeCountKey) ?? spareShowDislikeCount,
    showCommentCount:
        sharedPreferences.getBool(showCommentCountKey) ?? spareShowCommentCount,
    showSumCount:
        sharedPreferences.getBool(showSumCountKey) ?? spareShowSumCount,
    showCommentPlusLikeCount:
        sharedPreferences.getBool(showCommentPlusLikeCountKey) ??
            spareShowCommentPlusLikeCount,
    isThumbUpToHeart:
        sharedPreferences.getBool(isThumbUpToHeartKey) ?? spareIsThumbUpToHeart,
    showUserAdminLabel: sharedPreferences.getBool(showUserAdminLabelKey) ??
        spareShowUserAdminLabel,
    showUserLikeCount: sharedPreferences.getBool(showUserLikeCountKey) ??
        spareShowUserLikeCount,
    showUserDislikeCount: sharedPreferences.getBool(showUserDislikeCountKey) ??
        spareShowUserDislikeCount,
    showUserSumCount:
        sharedPreferences.getBool(showUserSumCountKey) ?? spareShowUserSumCount,
    isMaintenance: sharedPreferences.getBool(isMaintenanceKey) ?? false,
    adminOnlyWrite:
        sharedPreferences.getBool(adminOnlyWriteKey) ?? spareAdminOnlyWrite,
    isPostsItemVideoMute: sharedPreferences.getBool(isPostsItemVideoMuteKey) ??
        spareIsPostsItemVideoMute,
  );
}

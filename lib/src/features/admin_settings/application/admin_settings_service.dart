import 'dart:convert';
import 'dart:developer' as dev;

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/data/admin_settings_repository.dart';
import 'package:applimode_app/src/features/admin_settings/domain/admin_settings.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/features/firebase_storage/firebase_storage_repository.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_settings_service.g.dart';

class AdminSettingsService {
  const AdminSettingsService(this._ref);

  final Ref _ref;

  SharedPreferencesWithCache get sharedPreferences =>
      _ref.read(prefsWithCacheProvider).requireValue;
  AdminSettingsRepository get adminSettingsRepository =>
      _ref.read(adminSettingsRepositoryProvider);

  Future<void> saveAdminSettings({
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
    String homeBarImageUrl = homeBarTitleImageUrl;
    if (xFile != null) {
      homeBarImageUrl = await _ref
          .read(firebaseStorageRepositoryProvider)
          .uploadXFile(
              file: xFile,
              storagePathname: appBarTitlePath,
              filename: 'app-bar-logo',
              contentType: mediaType ?? contentTypeJpeg);
    }
    await _ref.read(adminSettingsRepositoryProvider).createAdminSettings(
          homeBarTitle: homeBarTitle,
          homeBarImageUrl: homeBarImageUrl,
          homeBarStyle: homeBarStyle,
          mainColor: mainColor,
          mainCategory: mainCategory,
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
        );
  }

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

  Future<void> fetch() async {
    try {
      // dev.log('adminSettings fetch starts : ${DateTime.now()}');
      final adminSettings = await adminSettingsRepository.fetchAdminSettings();
      // dev.log('adminSettings: $adminSettings');
      // dev.log('adminSettings update starts : ${DateTime.now()}');
      if (adminSettings != null) {
        final deviceAdminSettings = _ref.read(adminSettingsProvider);

        if (adminSettings != deviceAdminSettings) {
          dev.log('admin settings update');
          sharedPreferences.setString(
              homeBarTitleKey, adminSettings.homeBarTitle);
          sharedPreferences.setString(
              homeBarImageUrlKey, adminSettings.homeBarImageUrl);
          sharedPreferences.setInt(homeBarStyleKey, adminSettings.homeBarStyle);
          sharedPreferences.setString(
              mainColorKey, Format.colorToHexString(adminSettings.mainColor));
          sharedPreferences.setString(
              mainCategoryKey,
              json.encode(
                  adminSettings.mainCategory.map((e) => e.toMap()).toList()));
          sharedPreferences.setBool(
              showAppStyleOptionKey, adminSettings.showAppStyleOption);
          sharedPreferences.setInt(
              postsListTypeKey, adminSettings.postsListType.index);
          sharedPreferences.setInt(
              boxColorTypeKey, adminSettings.boxColorType.index);
          sharedPreferences.setDouble(
              mediaMaxMBSizeKey, adminSettings.mediaMaxMBSize);
          sharedPreferences.setBool(
              useRecommendationKey, adminSettings.useRecommendation);
          sharedPreferences.setBool(useRankingKey, adminSettings.useRanking);
          sharedPreferences.setBool(useCategoryKey, adminSettings.useCategory);
          sharedPreferences.setBool(
              showLogoutOnDrawerKey, adminSettings.showLogoutOnDrawer);
          sharedPreferences.setBool(
              showLikeCountKey, adminSettings.showLikeCount);
          sharedPreferences.setBool(
              showDislikeCountKey, adminSettings.showDislikeCount);
          sharedPreferences.setBool(
              showCommentCountKey, adminSettings.showCommentCount);
          sharedPreferences.setBool(
              showSumCountKey, adminSettings.showSumCount);
          sharedPreferences.setBool(showCommentPlusLikeCountKey,
              adminSettings.showCommentPlusLikeCount);
          sharedPreferences.setBool(
              isThumbUpToHeartKey, adminSettings.isThumbUpToHeart);
          sharedPreferences.setBool(
              showUserAdminLabelKey, adminSettings.showUserAdminLabel);
          sharedPreferences.setBool(
              showUserLikeCountKey, adminSettings.showUserLikeCount);
          sharedPreferences.setBool(
              showUserDislikeCountKey, adminSettings.showUserDislikeCount);
          sharedPreferences.setBool(
              showUserSumCountKey, adminSettings.showUserSumCount);
          sharedPreferences.setBool(
              isMaintenanceKey, adminSettings.isMaintenance);
          sharedPreferences.setBool(
              adminOnlyWriteKey, adminSettings.adminOnlyWrite);
          sharedPreferences.setBool(
              isPostsItemVideoMuteKey, adminSettings.isPostsItemVideoMute);
          sharedPreferences.setInt(adminSettingsModifiedTimeKey,
              DateTime.now().millisecondsSinceEpoch);
        } else {
          dev.log('admin setting same');
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

@riverpod
AdminSettingsService adminSettingsService(Ref ref) {
  return AdminSettingsService(ref);
}

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

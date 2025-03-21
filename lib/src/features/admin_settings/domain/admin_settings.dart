import 'dart:convert';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class AdminSettings extends Equatable {
  const AdminSettings({
    required this.homeBarTitle,
    required this.homeBarImageUrl,
    required this.homeBarStyle,
    required this.mainColor,
    required this.mainCategory,
    required this.showAppStyleOption,
    required this.postsListType,
    required this.boxColorType,
    required this.mediaMaxMBSize,
    required this.useRecommendation,
    required this.useRanking,
    required this.useCategory,
    required this.showLogoutOnDrawer,
    required this.showLikeCount,
    required this.showDislikeCount,
    required this.showCommentCount,
    required this.showSumCount,
    required this.showCommentPlusLikeCount,
    required this.isThumbUpToHeart,
    required this.showUserAdminLabel,
    required this.showUserLikeCount,
    required this.showUserDislikeCount,
    required this.showUserSumCount,
    this.isMaintenance = false,
    required this.adminOnlyWrite,
    required this.isPostsItemVideoMute,
  });

  final String homeBarTitle;
  final String homeBarImageUrl;
  final int homeBarStyle;
  final Color mainColor;
  final List<MainCategory> mainCategory;
  final bool showAppStyleOption;
  final PostsListType postsListType;
  final BoxColorType boxColorType;
  final double mediaMaxMBSize;
  final bool useRecommendation;
  final bool useRanking;
  final bool useCategory;
  final bool showLogoutOnDrawer;
  final bool showLikeCount;
  final bool showDislikeCount;
  final bool showCommentCount;
  final bool showSumCount;
  final bool showCommentPlusLikeCount;
  final bool isThumbUpToHeart;
  final bool showUserAdminLabel;
  final bool showUserLikeCount;
  final bool showUserDislikeCount;
  final bool showUserSumCount;
  final bool isMaintenance;
  final bool adminOnlyWrite;
  final bool isPostsItemVideoMute;

  factory AdminSettings.fromMap(Map<String, dynamic> map) {
    final postsListTypeInt = List.generate(
                PostsListType.values.length, (int index) => index)
            .contains(map[postsListTypeKey] as int? ?? sparePostsListType.index)
        ? map[postsListTypeKey] as int? ?? sparePostsListType.index
        : 1;
    final boxColorTypeInt = List.generate(
                BoxColorType.values.length, (int index) => index)
            .contains(map[boxColorTypeKey] as int? ?? spareBoxColorType.index)
        ? map[boxColorTypeKey] as int? ?? spareBoxColorType.index
        : 1;
    return AdminSettings(
      homeBarTitle: map[homeBarTitleKey] as String? ?? spareHomeBarTitle,
      homeBarImageUrl:
          map[homeBarImageUrlKey] as String? ?? spareHomeBarImageUrl,
      homeBarStyle: map[homeBarStyleKey] as int? ?? spareHomeBarStyle,
      mainColor: Format.hexStringToColor(
          map[mainColorKey] as String? ?? spareMainColor),
      mainCategory:
          (json.decode((map[mainCategoryKey] as String?) ?? spareMainCategory)
                  as List<dynamic>)
              .map((e) => MainCategory.fromJson(e as Map<String, dynamic>))
              .toList(),
      showAppStyleOption:
          map[showAppStyleOptionKey] as bool? ?? spareShowAppStyleOption,
      postsListType: PostsListType.values[postsListTypeInt],
      boxColorType: BoxColorType.values[boxColorTypeInt],
      // for iOS type cast error
      /*
      mediaMaxMBSize: map[mediaMaxMBSizeKey] == null
          ? spareMediaMaxMBSize
          : double.tryParse(map[mediaMaxMBSizeKey].toString()) ??
              spareMediaMaxMBSize,
      */
      mediaMaxMBSize: map[mediaMaxMBSizeKey] == null
          ? spareMediaMaxMBSize
          : (map[mediaMaxMBSizeKey] as num).toDouble(),
      // mediaMaxMBSize: map[mediaMaxMBSizeKey] as double? ?? spareMediaMaxMBSize,
      useRecommendation:
          map[useRecommendationKey] as bool? ?? spareUseRecommendation,
      useRanking: map[useRankingKey] as bool? ?? spareUseRanking,
      useCategory: map[useCategoryKey] as bool? ?? spareUseCategory,
      showLogoutOnDrawer:
          map[showLogoutOnDrawerKey] as bool? ?? spareShowLogoutOnDrawer,
      showLikeCount: map[showLikeCountKey] as bool? ?? spareShowLikeCount,
      showDislikeCount:
          map[showDislikeCountKey] as bool? ?? spareShowDislikeCount,
      showCommentCount:
          map[showCommentCountKey] as bool? ?? spareShowCommentCount,
      showSumCount: map[showSumCountKey] as bool? ?? spareShowSumCount,
      showCommentPlusLikeCount: map[showCommentPlusLikeCountKey] as bool? ??
          spareShowCommentPlusLikeCount,
      isThumbUpToHeart:
          map[isThumbUpToHeartKey] as bool? ?? spareIsThumbUpToHeart,
      showUserAdminLabel:
          map[showUserAdminLabelKey] as bool? ?? spareShowUserAdminLabel,
      showUserLikeCount:
          map[showUserLikeCountKey] as bool? ?? spareShowUserLikeCount,
      showUserDislikeCount:
          map[showUserDislikeCountKey] as bool? ?? spareShowUserDislikeCount,
      showUserSumCount:
          map[showUserSumCountKey] as bool? ?? spareShowUserSumCount,
      isMaintenance: map[isMaintenanceKey] as bool? ?? false,
      adminOnlyWrite: map[adminOnlyWriteKey] as bool? ?? spareAdminOnlyWrite,
      isPostsItemVideoMute:
          map[isPostsItemVideoMuteKey] as bool? ?? spareIsPostsItemVideoMute,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'homeBarTitle': homeBarTitle,
      'homeBarImageUrl': homeBarImageUrl,
      'homeBarStyle': homeBarStyle,
      'mainColor': Format.colorToHexString(mainColor),
      'mainCategory': json.encode(mainCategory.map((e) => e.toMap()).toList()),
      'showAppStyleOption': showAppStyleOption,
      'postsListType': postsListType.index,
      'boxColorType': boxColorType.index,
      'mediaMaxMBSize': mediaMaxMBSize,
      'useRecommendation': useRecommendation,
      'useRanking': useRanking,
      'useCategory': useCategory,
      'showLogoutOnDrawer': showLogoutOnDrawer,
      'showLikeCount': showLikeCount,
      'showDislikeCount': showDislikeCount,
      'showCommentCount': showCommentCount,
      'showSumCount': showSumCount,
      'showCommentPlusLikeCount': showCommentPlusLikeCount,
      'isThumbUpToHeart': isThumbUpToHeart,
      'showUserAdminLabel': showUserAdminLabel,
      'showUserLikeCount': showUserLikeCount,
      'showUserDislikeCount': showUserDislikeCount,
      'showUserSumCount': showUserSumCount,
      'isMaintenance': isMaintenance,
      'adminOnlyWrite': adminOnlyWrite,
      'isPostsItemVideoMute': isPostsItemVideoMute,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        homeBarTitle,
        homeBarImageUrl,
        homeBarStyle,
        mainColor,
        mainCategory,
        showAppStyleOption,
        postsListType,
        boxColorType,
        mediaMaxMBSize,
        useRecommendation,
        useRanking,
        useCategory,
        showLogoutOnDrawer,
        showLikeCount,
        showDislikeCount,
        showCommentCount,
        showSumCount,
        showCommentPlusLikeCount,
        isThumbUpToHeart,
        showUserAdminLabel,
        showUserLikeCount,
        showUserDislikeCount,
        showUserSumCount,
        isMaintenance,
        adminOnlyWrite,
        isPostsItemVideoMute,
      ];
}

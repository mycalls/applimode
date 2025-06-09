// lib/src/features/admin_settings/domain/admin_settings.dart

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';

// Represents the administrative settings for the application.
// 애플리케이션의 관리자 설정을 나타냅니다.
class AdminSettings extends Equatable {
  // Constructs an [AdminSettings] instance.
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

  // Title text for the home screen app bar.
  // 홈 화면 앱 바의 제목 텍스트입니다.
  final String homeBarTitle;
  // URL for the image in the home screen app bar.
  // 홈 화면 앱 바 이미지의 URL입니다.
  final String homeBarImageUrl;
  // Style of the home screen app bar (0: text, 1: image, 2: text and image).
  // 홈 화면 앱 바 스타일 (0: 텍스트, 1: 이미지, 2: 텍스트 및 이미지).
  final int homeBarStyle;
  // Main theme color of the application.
  // 애플리케이션의 주요 테마 색상입니다.
  final Color mainColor;
  // List of main categories for the application.
  // 애플리케이션의 주요 카테고리 목록입니다.
  final List<MainCategory> mainCategory;
  // Whether to show the app style option.
  // 앱 스타일 옵션 표시 여부입니다.
  final bool showAppStyleOption;
  // Type of post list display.
  // 게시물 목록 표시 유형입니다.
  final PostsListType postsListType;
  // Color type for post item boxes.
  // 게시물 항목 상자의 색상 유형입니다.
  final BoxColorType boxColorType;
  // Maximum media file size in MB.
  // 최대 미디어 파일 크기 (MB)입니다.
  final double mediaMaxMBSize;
  // Whether to use the recommendation feature.
  // 추천 기능 사용 여부입니다.
  final bool useRecommendation;
  // Whether to use the ranking feature.
  // 랭킹 기능 사용 여부입니다.
  final bool useRanking;
  // Whether to use categories.
  // 카테고리 사용 여부입니다.
  final bool useCategory;
  // Whether to show the logout button in the drawer.
  // 드로어에 로그아웃 버튼 표시 여부입니다.
  final bool showLogoutOnDrawer;
  // Whether to show the like count for posts.
  // 게시물 좋아요 수 표시 여부입니다.
  final bool showLikeCount;
  // Whether to show the dislike count for posts.
  // 게시물 싫어요 수 표시 여부입니다.
  final bool showDislikeCount;
  // Whether to show the comment count for posts.
  // 게시물 댓글 수 표시 여부입니다.
  final bool showCommentCount;
  // Whether to show the sum of likes and dislikes for posts.
  // 게시물 좋아요와 싫어요 합계 표시 여부입니다.
  final bool showSumCount;
  // Whether to show the sum of comments and likes for posts.
  // 게시물 댓글과 좋아요 합계 표시 여부입니다.
  final bool showCommentPlusLikeCount;
  // Whether to change the thumb-up icon to a heart icon.
  // 좋아요 아이콘을 하트 아이콘으로 변경할지 여부입니다.
  final bool isThumbUpToHeart;
  // Whether to show the admin label for user profiles.
  // 사용자 프로필에 관리자 라벨 표시 여부입니다.
  final bool showUserAdminLabel;
  // Whether to show the like count for user profiles.
  // 사용자 프로필에 좋아요 수 표시 여부입니다.
  final bool showUserLikeCount;
  // Whether to show the dislike count for user profiles.
  // 사용자 프로필에 싫어요 수 표시 여부입니다.
  final bool showUserDislikeCount;
  // Whether to show the sum of likes and dislikes for user profiles.
  // 사용자 프로필에 좋아요와 싫어요 합계 표시 여부입니다.
  final bool showUserSumCount;
  // Whether the application is in maintenance mode.
  // 애플리케이션이 유지보수 모드인지 여부입니다.
  final bool isMaintenance;
  // Whether only admins can write posts.
  // 관리자만 게시물을 작성할 수 있는지 여부입니다.
  final bool adminOnlyWrite;
  // Whether videos in post items are muted by default.
  // 게시물 항목의 비디오가 기본적으로 음소거되는지 여부입니다.
  final bool isPostsItemVideoMute;

  // Creates an [AdminSettings] instance from a map (typically from Firestore).
  // 맵(일반적으로 Firestore에서 가져옴)으로부터 [AdminSettings] 인스턴스를 생성합니다.
  factory AdminSettings.fromMap(Map<String, dynamic> map) {
    // Helper function to safely parse an enum value from an integer.
    // 정수로부터 enum 값을 안전하게 파싱하는 헬퍼 함수입니다.
    T getEnumValue<T>(List<T> enumValues, dynamic rawValue, T defaultValue) {
      final value = rawValue as int?;
      if (value != null && value >= 0 && value < enumValues.length) {
        return enumValues[value];
      }
      return defaultValue;
    }

    return AdminSettings(
      homeBarTitle: map[homeBarTitleKey] as String? ?? spareHomeBarTitle,
      homeBarImageUrl:
          map[homeBarImageUrlKey] as String? ?? spareHomeBarImageUrl,
      homeBarStyle: map[homeBarStyleKey] as int? ?? spareHomeBarStyle,
      mainColor: Format.hexStringToColor(map[mainColorKey] as String? ??
          spareMainColor), // Main theme color. // 주요 테마 색상.
      mainCategory:
          (json.decode((map[mainCategoryKey] as String?) ?? spareMainCategory)
                  as List<dynamic>)
              .map((e) => MainCategory.fromJson(e as Map<String, dynamic>))
              .toList(), // List of main categories. // 주요 카테고리 목록.
      showAppStyleOption:
          map[showAppStyleOptionKey] as bool? ?? spareShowAppStyleOption,
      postsListType: getEnumValue(
          PostsListType.values, map[postsListTypeKey], sparePostsListType),
      boxColorType: getEnumValue(
          BoxColorType.values, map[boxColorTypeKey], spareBoxColorType),
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

  // Converts this [AdminSettings] instance to a map for Firestore.
  // 이 [AdminSettings] 인스턴스를 Firestore용 맵으로 변환합니다.
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

  // Enables string representation for debugging.
  // 디버깅을 위한 문자열 표현을 활성화합니다.
  @override
  bool? get stringify => true;

  // Properties used by Equatable for value comparison.
  // Equatable이 값 비교에 사용하는 속성들입니다.
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

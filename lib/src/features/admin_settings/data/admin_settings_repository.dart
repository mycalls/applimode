// lib/src/features/admin_settings/data/admin_settings_repository.dart

import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/domain/admin_settings.dart';

part 'admin_settings_repository.g.dart';

// Repository for managing admin settings in Firestore.
// Firestore에서 관리자 설정을 관리하는 저장소입니다.
class AdminSettingsRepository {
  const AdminSettingsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  // Path to the admin settings document in Firestore.
  // Firestore의 관리자 설정 문서 경로입니다.
  static const _adminSettingsPath = 'adminSettings/admin-settings';

  Future<void> createAdminSettings({
    required String homeBarTitle,
    required String homeBarImageUrl,
    required int homeBarStyle,
    required Color mainColor,
    required List<MainCategory> mainCategory,
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
    final settings = AdminSettings(
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
    await _firestore.doc(_adminSettingsPath).set(settings.toMap());
  }

  // Returns a typed DocumentReference for the admin settings document.
  // 관리자 설정 문서에 대한 형식화된 DocumentReference를 반환합니다.
  DocumentReference<AdminSettings> _docRef() =>
      _firestore.doc(_adminSettingsPath).withConverter(
          fromFirestore: (snapshot, _) =>
              AdminSettings.fromMap(snapshot.data()!),
          toFirestore: (value, _) => value.toMap());

  Future<AdminSettings?> fetchAdminSettings() async {
    // Fetches the admin settings from Firestore once.
    // Firestore에서 관리자 설정을 한 번 가져옵니다.
    final snapshot =
        await _docRef().get().timeout(const Duration(milliseconds: 1000));
    return snapshot.data();
  }

  // Provides a stream of admin settings from Firestore.
  // Firestore에서 관리자 설정 스트림을 제공합니다.
  Stream<AdminSettings?> watchAdminSettings() =>
      _docRef().snapshots().map((event) => event.data());
}

// Riverpod provider for AdminSettingsRepository.
// AdminSettingsRepository를 위한 Riverpod 프로바이더입니다.
@riverpod
AdminSettingsRepository adminSettingsRepository(Ref ref) {
  return AdminSettingsRepository(FirebaseFirestore.instance);
}

import 'dart:convert';

import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/domain/admin_settings.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_settings_repository.g.dart';

class AdminSettingsRepository {
  const AdminSettingsRepository(this._firestore);

  final FirebaseFirestore _firestore;

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
  }) =>
      _firestore.doc(_adminSettingsPath).set({
        'homeBarTitle': homeBarTitle,
        'homeBarImageUrl': homeBarImageUrl,
        'homeBarStyle': homeBarStyle,
        'mainColor': Format.colorToHexString(mainColor),
        'mainCategory':
            json.encode(mainCategory.map((e) => e.toMap()).toList()),
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
      });

  DocumentReference<AdminSettings> _docRef() =>
      _firestore.doc(_adminSettingsPath).withConverter(
          fromFirestore: (snapshot, _) =>
              AdminSettings.fromMap(snapshot.data()!),
          toFirestore: (value, _) => value.toMap());

  Future<AdminSettings?> fetchAdminSettings() async {
    final snapshot =
        await _docRef().get().timeout(const Duration(milliseconds: 1000));
    return snapshot.data();
  }

  Stream<AdminSettings?> watchAdminSettings() =>
      _docRef().snapshots().map((event) => event.data());
}

@riverpod
AdminSettingsRepository adminSettingsRepository(Ref ref) {
  return AdminSettingsRepository(FirebaseFirestore.instance);
}

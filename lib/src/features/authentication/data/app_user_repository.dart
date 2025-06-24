// external
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// features
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';

part 'app_user_repository.g.dart';

class AppUserRepository {
  const AppUserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  String _appUserPath(String uid) => 'users/$uid';
  // ignore: unused_element
  String _appUsersPath() => 'users';

  Future<void> createAppUser({
    required String uid,
    required String displayName,
    required bool isAdmin,
    required bool isBlock,
    required bool isHideInfo,
    String? photoUrl,
    String? storyUrl,
    String bio = '',
    required int gender,
    DateTime? birthday,
    required int likeCount,
    required int dislikeCount,
    required int sumCount,
    required bool verified,
    String? fcmToken,
  }) =>
      _firestore.doc(_appUserPath(uid)).set({
        'uid': uid,
        'displayName': displayName,
        'isAdmin': isAdmin,
        'isBlock': isBlock,
        'isHideInfo': isHideInfo,
        'photoUrl': photoUrl,
        'storyUrl': storyUrl,
        'bio': bio,
        'gender': gender,
        'birthday': birthday?.millisecondsSinceEpoch,
        'likeCount': likeCount,
        'dislikeCount': dislikeCount,
        'sumCount': sumCount,
        'verified': verified,
        'fcmToken': fcmToken,
      });

  Future<void> updateFcmToken({
    required String uid,
    required String token,
  }) =>
      _firestore.doc(_appUserPath(uid)).update({'fcmToken': token});

  Future<void> updateIsHideInfo({
    required String uid,
    required bool isHideInfo,
  }) =>
      _firestore.doc(_appUserPath(uid)).update({
        'isHideInfo': isHideInfo,
      });

  Future<void> updateDisplayName({
    required String uid,
    required String displayName,
  }) =>
      _firestore.doc(_appUserPath(uid)).update({
        'displayName': displayName,
      });

  Future<void> updatePhotoUrl({
    required String uid,
    String? photoUrl,
  }) =>
      _firestore.doc(_appUserPath(uid)).update({
        'photoUrl': photoUrl,
      });

  Future<void> updateStoryUrl({
    required String uid,
    String? storyUrl,
  }) =>
      _firestore.doc(_appUserPath(uid)).update({
        'storyUrl': storyUrl,
      });

  Future<void> updateBio({
    required String uid,
    String bio = '',
  }) =>
      _firestore.doc(_appUserPath(uid)).update({
        'bio': bio,
      });

  Future<void> updateGender({
    required String uid,
    required int gender,
  }) =>
      _firestore.doc(_appUserPath(uid)).update({
        'gender': gender,
      });

  Future<void> updateBirthday({
    required String uid,
    required DateTime birthday,
  }) =>
      _firestore.doc(_appUserPath(uid)).update({
        'birthday': birthday.millisecondsSinceEpoch,
      });

  Future<void> increaseLikeCount(String uid) =>
      _firestore.doc(_appUserPath(uid)).update({
        'likeCount': FieldValue.increment(1),
        'sumCount': FieldValue.increment(1),
      });

  Future<void> decreaseLikeCount(String uid) =>
      _firestore.doc(_appUserPath(uid)).update({
        'likeCount': FieldValue.increment(-1),
        'sumCount': FieldValue.increment(-1),
      });

  Future<void> increaseDislikeCount(String uid) =>
      _firestore.doc(_appUserPath(uid)).update({
        'dislikeCount': FieldValue.increment(1),
        'sumCount': FieldValue.increment(-1),
      });

  Future<void> decreaseDislikeCount(String uid) =>
      _firestore.doc(_appUserPath(uid)).update({
        'dislikeCount': FieldValue.increment(-1),
        'sumCount': FieldValue.increment(1),
      });

  Future<void> blockAppUser(String uid) =>
      _firestore.doc(_appUserPath(uid)).update({
        'isBlock': true,
      });

  Future<void> unblockAppUser(String uid) =>
      _firestore.doc(_appUserPath(uid)).update({
        'isBlock': false,
      });

  Future<void> deleteAppUser(String id) =>
      _firestore.doc(_appUserPath(id)).delete();

  Query<AppUser> usersRef() =>
      _firestore.collection(_appUsersPath()).withConverter(
            fromFirestore: (snapshot, _) => AppUser.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  DocumentReference<AppUser> _docRef(String uid) =>
      _firestore.doc(_appUserPath(uid)).withConverter(
          fromFirestore: (snapshot, _) => AppUser.fromMap(snapshot.data()!),
          toFirestore: (value, _) => value.toMap());

  Future<AppUser?> fetchAppUser(String uid) async {
    final snapshot = await _docRef(uid).get();
    return snapshot.data();
  }

  Stream<AppUser?> watchAppUser(String uid) =>
      _docRef(uid).snapshots().map((event) => event.data());
}

@Riverpod(keepAlive: true)
AppUserRepository appUserRepository(Ref ref) {
  return AppUserRepository(FirebaseFirestore.instance);
}

@Riverpod(keepAlive: true)
FutureOr<AppUser?> appUserFuture(Ref ref, String uid) {
  final appUserRepository = ref.watch(appUserRepositoryProvider);
  return appUserRepository.fetchAppUser(uid);
}

@riverpod
Stream<AppUser?> appUserStream(Ref ref, String uid) {
  final appUserRepository = ref.watch(appUserRepositoryProvider);
  return appUserRepository.watchAppUser(uid);
}

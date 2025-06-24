// external
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// features
import 'package:applimode_app/src/features/profile/domain/app_leaver.dart';

part 'app_leavers_repository.g.dart';

class AppLeaversRepository {
  const AppLeaversRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static String appLeaversPath() => 'appLeavers';
  static String appLeaverPath(String id) => 'appLeavers/$id';

  Future<void> createAppLeaver({
    required String id,
    required DateTime closedAt,
  }) =>
      _firestore.doc(appLeaverPath(id)).set({
        'id': id,
        'closedAt': closedAt.millisecondsSinceEpoch,
      });

  Future<void> deleteAppLeaver(String id) =>
      _firestore.doc(appLeaverPath(id)).delete();

  Query<AppLeaver> appLeaversRef() =>
      _firestore.collection(appLeaversPath()).withConverter(
            fromFirestore: (snapshot, _) =>
                AppLeaver.fromMap(snapshot.data() ?? {}),
            toFirestore: (value, _) => value.toMap(),
          );

  DocumentReference<AppLeaver> appLeaverRef(String id) =>
      _firestore.doc(appLeaverPath(id)).withConverter(
            fromFirestore: (snapshot, _) =>
                AppLeaver.fromMap(snapshot.data() ?? {}),
            toFirestore: (value, _) => value.toMap(),
          );

  Future<AppLeaver?> fetchAppLeaver(String id) async {
    final snapshot = await appLeaverRef(id).get();
    return snapshot.data();
  }
}

@riverpod
AppLeaversRepository appLeaversRepository(Ref ref) {
  return AppLeaversRepository(FirebaseFirestore.instance);
}

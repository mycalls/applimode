// external
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// features
import 'package:applimode_app/src/features/profile/domain/delete_error.dart';

part 'delete_errors_repository.g.dart';

class DeleteErrorsRepository {
  const DeleteErrorsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static String deleteErrorsPath() => 'deleteErrors';
  static String deleteErrorPath(String id) => 'deleteErrors/$id';

  Future<void> createDeleteError({
    required String id,
    required String uid,
    required String errorType,
    required String errorIdType,
    required String errorId,
  }) =>
      _firestore.doc(deleteErrorPath(id)).set({
        'id': id,
        'uid': uid,
        'errorType': errorType,
        'errorIdType': errorIdType,
        'errorId': errorId,
      });

  Future<void> deleteDeleteError(String id) =>
      _firestore.doc(deleteErrorPath(id)).delete();

  Query<DeleteError> deleteErrorsRef() =>
      _firestore.collection(deleteErrorsPath()).withConverter(
            fromFirestore: (snapshot, _) =>
                DeleteError.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  DocumentReference<DeleteError> deleteErrorRef(String id) =>
      _firestore.doc(deleteErrorPath(id)).withConverter(
            fromFirestore: (snapshot, _) =>
                DeleteError.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  Future<DeleteError?> fetchDeleteError(String id) async {
    final snapshot = await deleteErrorRef(id).get();
    return snapshot.data();
  }
}

@riverpod
DeleteErrorsRepository deleteErrorsRepository(Ref ref) {
  return DeleteErrorsRepository(FirebaseFirestore.instance);
}

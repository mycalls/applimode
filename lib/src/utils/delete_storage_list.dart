// external
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:applimode_app/src/core/storage/firebase_storage_repository.dart';

Future<void> deleteStorageList(Ref ref, String path) async {
  final listResult = await ref
      .read(firebaseStorageRepositoryProvider)
      .storageRef(path)
      .listAll();

  for (var item in listResult.items) {
    item.delete();
  }
}

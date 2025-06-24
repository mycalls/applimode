import 'dart:developer' as dev;

// flutter
import 'package:flutter/foundation.dart';

// external
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:applimode_app/src/core/constants/constants.dart';

part 'firebase_storage_repository.g.dart';

class FirebaseStorageRepository {
  const FirebaseStorageRepository(this._storage);

  final FirebaseStorage _storage;

  Reference storageRef(String path) => _storage.ref(path);
  Reference storageRefChild(String path) => _storage.ref().child(path);
  Reference storageRefFromUrl(String url) => _storage.refFromURL(url);

  Future<Uint8List> getBytes(XFile file) async {
    final bytes = await file.readAsBytes();
    dev.log('uploadXfile: Bytes done');
    return bytes;
  }

  UploadTask uploadTask({
    required Uint8List bytes,
    required String storagePathname,
    required String filename,
    String contentType = contentTypeJpeg,
  }) {
    final ref = _storage.ref('$storagePathname/$filename');
    return ref.putData(bytes, SettableMetadata(contentType: contentType));
  }

  Future<String> uploadXFile({
    required XFile file,
    required String storagePathname,
    required String filename,
    String contentType = contentTypeJpeg,
  }) async {
    final ref = _storage.ref('$storagePathname/$filename');
    final bytes = await file.readAsBytes();
    dev.log('uploadXfile: Bytes done');
    final result = await ref.putData(
      bytes,
      SettableMetadata(contentType: contentType),
    );
    return result.ref.getDownloadURL();
  }

  Future<String> uploadBytes({
    required Uint8List bytes,
    required String storagePathname,
    required String filename,
    String contentType = contentTypeJpeg,
  }) async {
    final ref = _storage.ref('$storagePathname/$filename');
    final result = await ref.putData(
      bytes,
      SettableMetadata(contentType: contentType),
    );
    return result.ref.getDownloadURL();
  }

  Future<void> deleteAsset(String assetUrl) =>
      _storage.refFromURL(assetUrl).delete();
}

@riverpod
FirebaseStorageRepository firebaseStorageRepository(Ref ref) {
  return FirebaseStorageRepository(FirebaseStorage.instance);
}

import 'dart:developer' as dev;

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/need_image_compree.dart';
import 'package:applimode_app/src/utils/web_image_compress/wic_stub.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/firebase_storage/firebase_storage_repository.dart';
import 'package:applimode_app/src/utils/delete_storage_list.dart';
import 'package:applimode_app/src/utils/nanoid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/utils/upload_progress_state.dart';

class ProfileService {
  const ProfileService(this.ref);

  final Ref ref;

  FirebaseStorageRepository get storageRepository =>
      ref.read(firebaseStorageRepositoryProvider);

  Future<void> editUsername({
    required String uid,
    required String displayName,
  }) async {
    await ref.read(authRepositoryProvider).updateDisplayName(displayName);
    await ref.read(appUserRepositoryProvider).updateDisplayName(
          uid: uid,
          displayName: displayName,
        );
  }

  Future<void> changeProfileImage({
    required String uid,
    XFile? xFile,
    String? mediaType,
  }) async {
    await deleteStorageList(ref, '$uid/$profilePath');
    String? remotePhotoUrl;
    if (xFile != null) {
      final fileExt =
          mediaType == null ? '.jpeg' : Format.mimeTypeToExtWithDot(mediaType);
      Uint8List bytes = await storageRepository.getBytes(xFile);
      dev.log('originSize: ${bytes.lengthInBytes}');
      // 이미지일 경우 압축
      bytes = kIsWeb
          ? await WicStub().changeImageQuality(
              imageUrl: xFile.path,
              maxWidthThreshold: profileImageMaxLength,
              quality: defaultImageQuality,
            )
          : await FlutterImageCompress.compressWithList(
              bytes,
              minWidth: profileImageMaxLength,
              minHeight: profileImageMaxLength,
              quality: defaultImageQuality,
            );
      dev.log('compressSize: ${bytes.lengthInBytes}');
      final uploadTask = storageRepository.uploadTask(
        bytes: bytes,
        storagePathname: '$uid/$profilePath',
        filename: '${nanoid()}$fileExt',
        contentType: mediaType ?? contentTypeJpeg,
      );

      uploadTask.snapshotEvents.listen(
        (taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              final percent = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              ref
                  .read(uploadProgressStateProvider.notifier)
                  .set(0, percent.toInt());
              break;
            case TaskState.error:
              break;
            case TaskState.success:
              break;
            default:
              break;
          }
        },
      );

      final takeSnapshot = await uploadTask;
      remotePhotoUrl = await takeSnapshot.ref.getDownloadURL();
    }

    // updatePhotoUrl 에서 빈칸을 넣어야 null로 들어감.
    await ref.read(authRepositoryProvider).updatePhotoUrl(remotePhotoUrl ?? '');
    await ref.read(appUserRepositoryProvider).updatePhotoUrl(
          uid: uid,
          photoUrl: remotePhotoUrl,
        );
  }

  Future<void> changeStoryImage({
    required String uid,
    XFile? xFile,
    String? mediaType,
  }) async {
    await deleteStorageList(ref, '$uid/$storyPath');
    String? remotePhotoUrl;
    if (xFile != null) {
      final fileExt =
          mediaType == null ? '.jpeg' : Format.mimeTypeToExtWithDot(mediaType);
      Uint8List bytes = await storageRepository.getBytes(xFile);
      dev.log('originSize: ${bytes.lengthInBytes}');
      // 이미지일 경우 압축
      if (needImageCompree(mediaType ?? contentTypeJpeg)) {
        bytes = kIsWeb
            ? await WicStub().changeImageQuality(
                imageUrl: xFile.path,
                maxWidthThreshold: defaultImageMaxWidth,
                quality: defaultImageQuality,
              )
            : await FlutterImageCompress.compressWithList(
                bytes,
                minWidth: defaultImageMaxWidth,
                quality: defaultImageQuality,
              );
      }
      dev.log('compressSize: ${bytes.lengthInBytes}');
      final uploadTask = storageRepository.uploadTask(
        bytes: bytes,
        storagePathname: '$uid/$storyPath',
        filename: '${nanoid()}$fileExt',
        contentType: mediaType ?? contentTypeJpeg,
      );

      uploadTask.snapshotEvents.listen(
        (taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              final percent = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              ref
                  .read(uploadProgressStateProvider.notifier)
                  .set(0, percent.toInt());
              break;
            case TaskState.error:
              break;
            case TaskState.success:
              break;
            default:
              break;
          }
        },
      );

      final takeSnapshot = await uploadTask;
      remotePhotoUrl = await takeSnapshot.ref.getDownloadURL();
    }
    await ref.read(appUserRepositoryProvider).updateStoryUrl(
          uid: uid,
          storyUrl: remotePhotoUrl,
        );
  }

  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    final AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await ref
        .read(authRepositoryProvider)
        .reauthenticateWithCredential(credential);

    await ref.read(authRepositoryProvider).updatePassword(newPassword);
  }

  Future<void> changeEmail({
    required String currentEmail,
    required String newEmail,
    required String password,
  }) async {
    final AuthCredential credential = EmailAuthProvider.credential(
      email: currentEmail,
      password: password,
    );
    await ref
        .read(authRepositoryProvider)
        .reauthenticateWithCredential(credential);

    await ref.read(authRepositoryProvider).updateEmail(newEmail);
  }
}

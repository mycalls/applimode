import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/exceptions/app_exception.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/firebase_storage/firebase_storage_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_contents_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/r_two_storage/r_two_storage_repository.dart';
import 'package:applimode_app/src/features/search/data/d_one_repository.dart';
import 'package:applimode_app/src/utils/build_remote_media.dart';
import 'package:applimode_app/src/utils/call_fcm_function.dart';
import 'package:applimode_app/src/utils/compare_lists.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/nanoid.dart';
import 'package:applimode_app/src/utils/need_image_compree.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/src/utils/string_converter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:applimode_app/src/utils/updated_post_ids_list.dart';
import 'package:applimode_app/src/utils/upload_progress_state.dart';
import 'package:applimode_app/src/utils/web_video_thumbnail/wvt_stub.dart';
import 'package:applimode_app/src/utils/web_image_compress/wic_stub.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
// import 'package:http/http.dart' as http;
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'editor_screen_controller.g.dart';

// useFirebaseStorage
@riverpod
class EditorScreenController extends _$EditorScreenController {
// ignore: avoid_public_notifier_properties
  Object? key;

  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() {
      key = null;
    });
  }

  Future<bool> publish({
    required String content,
    required int category,
    required bool hasPostContent,
    String? postId,
    List<String>? oldRemoteMedia,
    AppUser? writer,
    required String postNotiString,
  }) async {
    WakelockPlus.enable();
    final user = ref.read(authRepositoryProvider).currentUser;

    if (user == null) {
      WakelockPlus.disable();
      state = AsyncError(NeedLogInException(), StackTrace.current);
      return false;
    }

    /*
    if (user != null) {
      WakelockPlus.disable();
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }
    */

    if (postId != null && writer == null) {
      WakelockPlus.disable();
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    final appUser = await ref.read(appUserFutureProvider(user.uid).future);
    // If only the administrator can write, check permissions
    // 관리자만 글쓰기가 가능할 경우, 권한 체크
    final isAdminOnlyWrite = ref.read(adminSettingsProvider).adminOnlyWrite;
    dev.log('isAdminOnlyWrite: $isAdminOnlyWrite');
    if (isAdminOnlyWrite) {
      if (appUser == null || !appUser.isAdmin) {
        WakelockPlus.disable();
        state = AsyncError(NeedPermissionException(), StackTrace.current);
        return false;
      }
    }

    // If only the verified users can write, check permissions
    // 인증된 사용자만 글쓰기가 가능할 경우, 권한 체크
    if (verifiedOnlyWrite) {
      if (appUser == null || !appUser.verified) {
        WakelockPlus.disable();
        state = AsyncError(NeedPermissionException(), StackTrace.current);
        return false;
      }
    }

    if (appUser == null || appUser.isBlock) {
      WakelockPlus.disable();
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }

    if (postId != null &&
        writer != null &&
        user.uid != writer.uid &&
        !appUser.isAdmin) {
      // auth user and writer user are different
      // Auth 와 작성자가 다를 경우
      // 팝업창 작성하고 팝
      WakelockPlus.disable();
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }

    final id = postId ?? nanoid();
    String newContent = content;
    final postWriterId = writer?.uid ?? user.uid;

    String? mainImageUrl;
    String? mainVideoUrl;
    final List<String> hashtags = [];

    final storageRepository = ref.read(firebaseStorageRepositoryProvider);
    final rTwoRepository = ref.read(rTwoStorageRepositoryProvider);

    final key = this.key;

    try {
      // when updating, media is deleted
      // 업데이트시 미디어가 삭제되었을 경우, 미디어 삭제
      if (postId != null &&
          oldRemoteMedia != null &&
          oldRemoteMedia.isNotEmpty) {
        final newRemoteMedia = buildRemoteMedia(content);
        final deletedMedia = compareLists(oldRemoteMedia, newRemoteMedia);
        for (final mediaUrl in deletedMedia) {
          final isFbStorage = mediaUrl.startsWith(firebaseStorageUrlHead) ||
              mediaUrl.startsWith(gcpStorageUrlHead);
          try {
            if (isFbStorage) {
              storageRepository.deleteAsset(mediaUrl);
            } else {
              rTwoRepository.deleteAsset(mediaUrl);
            }
            /*
            if (useRTwoStorage) {
              rTwoRepository.deleteAsset(mediaUrl);
            } else {
              storageRepository.deleteAsset(mediaUrl);
            }
            */
          } catch (e) {
            debugPrint('oldMediaDeleteError: ${e.toString()}');
          }
        }
      }

      // media upload
      // 이미지, 비디오 통합 업로드
      final localVideoMatches =
          Regex.localVideoRegex.allMatches(content).toList();
      final localImageMatches =
          Regex.localImageRegex.allMatches(content).toList();

      final userMediaMatches = [...localVideoMatches, ...localImageMatches];

      if (userMediaMatches.isNotEmpty) {
        List<String> localMediaUrls = [];
        List<String> remoteMediaUrls = [];
        for (int i = 0; i < userMediaMatches.length; i++) {
          final match = userMediaMatches[i];
          localMediaUrls.add(match[0]!);
          final filename = nanoid();
          final isVideo = Regex.localVideoRegex.hasMatch(match[0]!);
          String? videoThumbnailUrl = '';

          // media type check
          final String mediaType = isVideo
              ? Format.extToMimeType(
                  Regex.mediaWithExtRegex.firstMatch(match[2]!)![2]!)
              : Format.extToMimeType(
                  Regex.mediaWithExtRegex.firstMatch(match[1]!)![2]!);

          dev.log('mediaType: $mediaType');

          final ext = Format.mimeTypeToExtWithDot(mediaType);

          // Convert media file to bytes
          // 미디어 파일을 bytes로 변경
          Uint8List? bytes;
          try {
            bytes = isVideo
                ? await storageRepository
                    .getBytes(XFile(Format.fixMediaWithExt(match[2]!)))
                : await storageRepository
                    .getBytes(XFile(Format.fixMediaWithExt(match[1]!)));
            dev.log('originSize: ${bytes.lengthInBytes}');
            // 이미지일 경우 압축
            if (!isVideo && needImageCompree(mediaType)) {
              bytes = kIsWeb
                  ? await WicStub().changeImageQuality(
                      imageUrl: Format.fixMediaWithExt(match[1]!),
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
          } catch (e) {
            debugPrint('FailedMediaFileException: $e');
            state = AsyncError(FailedMediaFileException(), StackTrace.current);
            return false;
          }

          // generate video thumbnail
          if (isVideo) {
            String thumbnailFilename = '$filename-thumbnail.jpeg';
            if (match[1] != null && match[1]!.isNotEmpty) {
              // when receiving a thumbnail image file directly
              // 썸네일 이미지 파일을 직접 받을 경우
              try {
                final thumbnailMediaType = Format.extToMimeType(
                    Regex.mediaWithExtRegex.firstMatch(match[1]!)![2]!);

                final thumbnailExt =
                    Format.mimeTypeToExtWithDot(thumbnailMediaType);
                thumbnailFilename = '$filename-thumbnail$thumbnailExt';
                Uint8List videoThumbnail = await storageRepository
                    .getBytes(XFile(Format.fixMediaWithExt(match[1]!)));
                if (needImageCompree(thumbnailMediaType)) {
                  videoThumbnail = kIsWeb
                      ? await WicStub().changeImageQuality(
                          imageUrl: Format.fixMediaWithExt(match[1]!),
                          maxWidthThreshold: defaultImageMaxWidth,
                          quality: defaultImageQuality,
                        )
                      : await FlutterImageCompress.compressWithList(
                          videoThumbnail,
                          minWidth: defaultImageMaxWidth,
                          quality: defaultImageQuality,
                        );
                }
                if (useRTwoStorage) {
                  final url = await rTwoRepository.uploadBytes(
                    bytes: videoThumbnail,
                    storagePathname: '$postWriterId/$postsPath/$id',
                    filename: thumbnailFilename,
                    contentType: thumbnailMediaType,
                    showPercentage: false,
                  );
                  videoThumbnailUrl = url;
                } else {
                  final url = await storageRepository.uploadBytes(
                    bytes: videoThumbnail,
                    storagePathname: '$postWriterId/$postsPath/$id',
                    filename: thumbnailFilename,
                    contentType: thumbnailMediaType,
                  );
                  videoThumbnailUrl = url;
                }
                dev.log('upload custom thumbnail');
              } catch (e) {
                debugPrint('customThumbnailUploadError: ${e.toString()}');
              }
            } else {
              // When extracting a thumbnail from videos
              // 비디오에서 썸네일 추출할 경우
              try {
                if (kIsWeb) {
                  // upload thumbnail on web
                  final videoThumbnail = await WvtStub().getThumbnailData(
                    video: Format.fixMediaWithExt(match[2]!),
                    maxWidth: videoThumbnailMaxWidth,
                    maxHeight: videoThumbnailMaxHeight,
                    quality: videoThumbnailQuality,
                  );
                  // ignore: unnecessary_null_comparison
                  if (videoThumbnail != null) {
                    if (useRTwoStorage) {
                      final url = await rTwoRepository.uploadBytes(
                        bytes: videoThumbnail,
                        storagePathname: '$postWriterId/$postsPath/$id',
                        filename: thumbnailFilename,
                        showPercentage: false,
                      );
                      videoThumbnailUrl = url;
                    } else {
                      final url = await storageRepository.uploadBytes(
                        bytes: videoThumbnail,
                        storagePathname: '$postWriterId/$postsPath/$id',
                        filename: thumbnailFilename,
                      );
                      videoThumbnailUrl = url;
                    }
                  }
                  dev.log('upload thumbnail on web');
                } else {
                  // upload thumbnail on native
                  final tempDir = await getTemporaryDirectory();
                  final destFile = p.join(tempDir.path, thumbnailFilename);
                  await FcNativeVideoThumbnail().getVideoThumbnail(
                    srcFile: Format.fixMediaWithExt(match[2]!),
                    destFile: destFile,
                    width: videoThumbnailMaxWidth,
                    height: videoThumbnailMaxHeight,
                    format: 'jpeg',
                    quality: videoThumbnailQuality,
                  );
                  if (await File(destFile).exists()) {
                    final destFileBytes = await File(destFile).readAsBytes();
                    if (useRTwoStorage) {
                      final url = await rTwoRepository.uploadBytes(
                        bytes: destFileBytes,
                        storagePathname: '$postWriterId/$postsPath/$id',
                        filename: thumbnailFilename,
                        showPercentage: false,
                      );
                      videoThumbnailUrl = url;
                    } else {
                      final url = await storageRepository.uploadBytes(
                        bytes: destFileBytes,
                        storagePathname: '$postWriterId/$postsPath/$id',
                        filename: thumbnailFilename,
                      );
                      videoThumbnailUrl = url;
                    }
                  } else {
                    dev.log('failed to create thumbnail with fc_native');
                  }
                  /*
                  final videoThumbnail = await VideoThumbnail.thumbnailData(
                    video: Format.fixMediaWithExt(match[2]!),
                    imageFormat: ImageFormat.JPEG,
                    maxWidth: videoThumbnailMaxWidth,
                    maxHeight: videoThumbnailMaxHeight,
                    quality: videoThumbnailQuality,
                  );
                  if (videoThumbnail != null) {
                    if (useRTwoStorage) {
                      final url = await rTwoRepository.uploadBytes(
                        bytes: videoThumbnail,
                        storagePathname: '$postWriterId/$postsPath/$id',
                        filename: thumbnailFilename,
                        showPercentage: false,
                      );
                      videoThumbnailUrl = url;
                    } else {
                      final url = await storageRepository.uploadBytes(
                        bytes: videoThumbnail,
                        storagePathname: '$postWriterId/$postsPath/$id',
                        filename: thumbnailFilename,
                      );
                      videoThumbnailUrl = url;
                    }
                  }
                  */
                  dev.log('upload thumbnail on native');
                }
              } catch (e) {
                debugPrint('ThumbnailUploadError: ${e.toString()}');
              }
            }
          }

          TaskSnapshot? takeSnapshot;

          // upload media
          try {
            if (!useRTwoStorage) {
              // firebase storage
              final uploadTask = storageRepository.uploadTask(
                bytes: bytes,
                storagePathname: '$postWriterId/$postsPath/$id',
                filename: '$filename$ext',
                contentType: mediaType,
              );

              uploadTask.snapshotEvents.listen(
                (taskSnapshot) {
                  switch (taskSnapshot.state) {
                    case TaskState.running:
                      final percent = 100.0 *
                          (taskSnapshot.bytesTransferred /
                              taskSnapshot.totalBytes);
                      ref
                          .read(uploadProgressStateProvider.notifier)
                          .set(i, percent.toInt());
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

              takeSnapshot = await uploadTask;
            }

            // get media url
            final remoteMediaUrl = useRTwoStorage
                ? await rTwoRepository.uploadBytes(
                    bytes: bytes,
                    storagePathname: '$postWriterId/$postsPath/$id',
                    filename: '$filename$ext',
                    contentType: mediaType,
                    index: i,
                  )
                : await takeSnapshot?.ref.getDownloadURL() ?? '';

            isVideo
                ? remoteMediaUrls
                    .add('[remoteVideo][$videoThumbnailUrl][$remoteMediaUrl]')
                : remoteMediaUrls.add('[remoteImage][$remoteMediaUrl][]');
          } catch (e) {
            debugPrint('FailedMediaFileUploadException: $e');
            state = AsyncError(
                FailedMediaFileUploadException(), StackTrace.current);
            return false;
          }
        }

        // replace media local media url with remote media url
        for (int i = 0; i < localMediaUrls.length; i++) {
          newContent =
              newContent.replaceFirst(localMediaUrls[i], remoteMediaUrls[i]);
        }
        // dev.log(newContent);
      }

      // when editing a post
      // 포스트를 수정할 때
      // when changing a thumbnail on a existing remote media
      // 리모트 미디어에서 썸네일만 변경했을 경우
      try {
        if (postId != null) {
          final remoteVideoMatches =
              Regex.remoteVideoRegex.allMatches(content).toList();
          if (remoteVideoMatches.isNotEmpty) {
            for (final match in remoteVideoMatches) {
              if (match[1] != null &&
                  match[1]!.isNotEmpty &&
                  (oldRemoteMedia == null ||
                      !oldRemoteMedia.contains(match[1]))) {
                final thumbnailMediaType = Format.extToMimeType(
                    Regex.mediaWithExtRegex.firstMatch(match[1]!)![2]!);

                final thumbnailExt =
                    Format.mimeTypeToExtWithDot(thumbnailMediaType);
                String thumbnailFilename = '${nanoid()}-thumbnail$thumbnailExt';
                Uint8List videoThumbnail = await storageRepository
                    .getBytes(XFile(Format.fixMediaWithExt(match[1]!)));
                if (needImageCompree(thumbnailMediaType)) {
                  videoThumbnail = kIsWeb
                      ? await WicStub().changeImageQuality(
                          imageUrl: Format.fixMediaWithExt(match[1]!),
                          maxWidthThreshold: defaultImageMaxWidth,
                          quality: defaultImageQuality,
                        )
                      : await FlutterImageCompress.compressWithList(
                          videoThumbnail,
                          minWidth: defaultImageMaxWidth,
                          quality: defaultImageQuality,
                        );
                }

                String newUrl = '';
                // upload new thumbnail
                if (useRTwoStorage) {
                  newUrl = await rTwoRepository.uploadBytes(
                    bytes: videoThumbnail,
                    storagePathname: '$postWriterId/$postsPath/$id',
                    filename: thumbnailFilename,
                    contentType: thumbnailMediaType,
                    showPercentage: false,
                  );
                } else {
                  newUrl = await storageRepository.uploadBytes(
                    bytes: videoThumbnail,
                    storagePathname: '$postWriterId/$postsPath/$id',
                    filename: thumbnailFilename,
                    contentType: thumbnailMediaType,
                  );
                }
                // replace old thumbnail url with new thumbnail url
                newContent = newContent.replaceFirst(match[1]!, newUrl);
                dev.log('replaceVideoThumbnail done');
              }
            }
          }
        }
      } catch (e) {
        debugPrint('replaceVideoThumbnailError: ${e.toString()}');
      }

      // parse hashtags
      try {
        final hashtagMatches = Regex.hashtagLinkRegex.allMatches(newContent);
        if (hashtagMatches.isNotEmpty) {
          for (final tag in hashtagMatches) {
            if (tag[1] != null && tag[1]!.trim().isNotEmpty) {
              hashtags.add(tag[1]!.trim());
              if (tag[1]!.contains('_')) {
                if (tag[1]!.replaceAll('_', '').trim().isNotEmpty) {
                  hashtags.add(tag[1]!.replaceAll('_', '').trim());
                }
                final splits = tag[1]!.split('_');
                for (final split in splits) {
                  if (split.trim().isNotEmpty) {
                    hashtags.add(split.trim());
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        debugPrint('parseHashtagError: ${e.toString()}');
      }

      // d1 search (full text search)
      try {
        if (useDOneForSearch &&
            StringConverter.toSearch(newContent).trim().isNotEmpty) {
          if (postId == null) {
            ref
                .read(dOneRepositoryProvider)
                .postPostsSearch(id, StringConverter.toSearch(newContent));
          } else {
            ref
                .read(dOneRepositoryProvider)
                .putPostsSearch(id, StringConverter.toSearch(newContent));
          }
        }
      } catch (e) {
        debugPrint('d1PostError: ${e.toString()}');
      }

      // get mainImageUrl
      // no need to try-catch
      final firstRemoteImage = Regex.remoteImageRegex.firstMatch(newContent);
      final firstWebImage = Regex.webImageRegex.firstMatch(newContent);
      final firstWebUrlImage = Regex.webImageUrlRegex.firstMatch(newContent);
      final firstYtImage = Regex.ytRegexB.firstMatch(newContent);
      if (firstRemoteImage != null) {
        mainImageUrl = firstRemoteImage[1];
      } else if (firstWebImage != null) {
        mainImageUrl = firstWebImage[1];
      } else if (firstWebUrlImage != null) {
        mainImageUrl = firstWebUrlImage[0];
      } else if (firstYtImage != null) {
        /*
        try {
          final ytThumbUrl =
              StringConverter.buildYtProxyThumbnail(firstYtImage[1]!);
          final response = await http.get(Uri.parse(ytThumbUrl));
          final bytes = response.bodyBytes;
          const ytThumbName = youtubeThumbnailName;
          if (useRTwoStorage) {
            final url = await rTwoRepository.uploadBytes(
              bytes: bytes,
              storagePathname: '$postWriterId/$postsPath/$id',
              filename: ytThumbName,
              showPercentage: false,
            );
            mainImageUrl = url;
          } else {
            final url = await storageRepository.uploadBytes(
              bytes: bytes,
              storagePathname: '$postWriterId/$postsPath/$id',
              filename: ytThumbName,
            );
            mainImageUrl = url;
          }
        } catch (e) {
          mainImageUrl = StringConverter.buildYtThumbnail(firstYtImage[1]!);
        }
        */

        mainImageUrl = StringConverter.buildYtThumbnail(firstYtImage[1]!);
      }

      // get mainVideoUrl
      // no need to try-catch
      final firstRemoteVideo = Regex.remoteVideoRegex.firstMatch(newContent);
      final firstWebVideo = Regex.webVideoRegex.firstMatch(newContent);
      final firstWebUrlVideo = Regex.webVideoUrlRegex.firstMatch(newContent);
      if (firstRemoteVideo != null) {
        mainVideoUrl = firstRemoteVideo[2];
      } else if (firstWebVideo != null) {
        mainVideoUrl = firstWebVideo[2];
      } else if (firstWebUrlVideo != null) {
        mainVideoUrl = firstWebUrlVideo[0];
      }

      // when post content is too long
      // 포스트의 길이가 너무 길 경우 사용
      final contentForLong = newContent;

      // get post title
      final preContentTitle = StringConverter.toTitle(newContent);
      // to shorten post title length
      final contentTitle = preContentTitle.length > contentTitleSize
          ? preContentTitle.substring(0, contentTitleSize)
          : preContentTitle;

      // when post content is very long
      final isLongContent = utf8.encode(newContent).length > longContentSize;
      if (isLongContent) {
        // to shorten post content length when saving on firestore
        // firestore의 posts에 저장될 content 길이를 줄이기 위해
        // use title instead of conent
        // 길이를 최대한 줄이기 위해 content에 title을 그대로 저장
        newContent = preContentTitle.length > contentTitleSize
            ? preContentTitle.substring(0, contentTitleSize)
            : preContentTitle;
      }

      // posting
      if (postId == null) {
        // new post
        await ref.read(postsRepositoryProvider).createPost(
              id: id,
              uid: postWriterId,
              content: newContent,
              title: contentTitle,
              isLongContent: isLongContent,
              isNoTitle: newContent.contains(noTitleTag),
              isNoWriter: newContent.contains(noWriterTag),
              category: category,
              mainImageUrl: mainImageUrl,
              mainVideoUrl: mainVideoUrl,
              mainVideoImageUrl: firstRemoteVideo?[1] ?? firstWebVideo?[1],
              tags: hashtags,
              createdAt: DateTime.now(),
            );
      } else {
        // update post
        await ref.read(postsRepositoryProvider).updatePost(
              id: id,
              // uid: postWriterId,
              content: newContent,
              title: contentTitle,
              isLongContent: isLongContent,
              isNoTitle: newContent.contains(noTitleTag),
              isNoWriter: newContent.contains(noWriterTag),
              category: category,
              mainImageUrl: mainImageUrl,
              mainVideoUrl: mainVideoUrl,
              mainVideoImageUrl: firstRemoteVideo?[1] ?? firstWebVideo?[1],
              tags: hashtags,
              updatedAt: DateTime.now(),
            );
      }

      // create long content
      try {
        if (isLongContent) {
          await ref.read(postContentsRepositoryProvider).createPostContent(
                id: id,
                uid: postWriterId,
                content: contentForLong,
                category: category,
              );
          dev.log('this is long content');
        }
      } catch (e) {
        debugPrint('postLongContentError: ${e.toString()}');
      }

      // delete long content
      try {
        if (!isLongContent && hasPostContent) {
          await ref.read(postContentsRepositoryProvider).deletePostContent(id);
        }
      } catch (e) {
        dev.log('already deleted');
        debugPrint('deletePostContent: ${e.toString()}');
      }
    } catch (e, st) {
      WakelockPlus.disable();
      debugPrint('editorScreenPublishError: ${e.toString()}');
      state = AsyncError(FailedPostSubmitException(), st);
      return false;
    }

    const newState = AsyncData(null);
    if (key == this.key) {
      state = newState;
    }

    if (postId == null && useFcmMessage) {
      try {
        final writerName = writer?.displayName ?? user.displayName;

        FcmFunctions.callSendMessage(
            content: '${writerName ?? 'Unknown'} $postNotiString',
            isTopic: true,
            topic: 'newPost');
      } catch (e) {
        debugPrint('fcmError: ${e.toString()}');
      }
    }

    WakelockPlus.disable();

    // when success
    // refresh posts list
    // 기존 포스트 리스트 새로고침
    try {
      // ref.invalidate(mainPostsListControllerProvider);
      // ref.invalidate(subPostsListControllerProvider);
      // use SimplePageListView
      if (postId == null) {
        ref.read(postsListStateProvider.notifier).set(nowToInt());
      } else {
        ref.read(updatedPostIdsListProvider.notifier).set(postId);
      }

      // ref.invalidate(mainPostsFutureProvider);
      ref.invalidate(uploadProgressStateProvider);
      ref.invalidate(postContentFutureProvider);
    } catch (e) {
      debugPrint('refreshListError: ${e.toString()}');
    }

    return true;

    /*
    if (postId == null) {
      if (ref.read(goRouterProvider).canPop()) {
        ref.read(goRouterProvider).pop();
      }
    } else {
      // refresh post
      // 기존 포스트 새로고침
      ref.invalidate(postFutureProvider);
      if (ref.read(goRouterProvider).canPop()) {
        ref.read(goRouterProvider).pop();
      }
      if (ref.read(goRouterProvider).canPop()) {
        ref.read(goRouterProvider).replace(
              ScreenPaths.post(id),
            );
      }
    }
    */
  }
}

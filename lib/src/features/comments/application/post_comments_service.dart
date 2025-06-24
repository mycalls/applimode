import 'dart:developer' as dev;

// flutter
import 'package:flutter/foundation.dart';

// external
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/constants/constants.dart';
import 'package:applimode_app/src/core/storage/firebase_storage_repository.dart';

// utils
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/nanoid.dart';
import 'package:applimode_app/src/utils/need_image_compree.dart';
import 'package:applimode_app/src/utils/web_image_compress/wic_stub.dart';

// features
import 'package:applimode_app/src/features/comments/data/post_comment_likes_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comment_report_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comments_repository.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';

class PostCommentsService {
  const PostCommentsService(this.ref);

  final Ref ref;

  Future<void> leavePostComment({
    required String id,
    required String uid,
    required String postId,
    required String parentCommentId,
    required String postWriterId,
    required bool isReply,
    String? content,
    XFile? xFile,
    String? mediaType,
  }) async {
    final storageRepository = ref.read(firebaseStorageRepositoryProvider);
    // update comment count for post
    // when there is no post, function must stop
    await ref
        .read(postsRepositoryProvider)
        .updatePostCommentCount(id: postId, number: 1);

    // update replies count for comment
    // when there is no comment, function must stop
    if (isReply) {
      await ref
          .read(postCommentsRepositoryProvider)
          .updateReplyCount(id: parentCommentId, number: 1);
    }

    // upload a image for comment
    String? remoteImageUrl;
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
      remoteImageUrl = await storageRepository.uploadBytes(
        bytes: bytes,
        storagePathname: '$commentsPath/$postId',
        filename: '${nanoid()}$fileExt',
        contentType: mediaType ?? contentTypeJpeg,
      );
      /*
      remoteImageUrl =
          await ref.read(firebaseStorageRepositoryProvider).uploadXFile(
                file: xFile,
                storagePathname: '$commentsPath/$postId',
                filename: '${nanoid()}$fileExt',
                contentType: mediaType ?? contentTypeJpeg,
              );
      */
    }

    // create comment
    await ref.read(postCommentsRepositoryProvider).createPostComment(
          id: id,
          uid: uid,
          postId: postId,
          parentCommentId: parentCommentId,
          postWriterId: postWriterId,
          isReply: isReply,
          content: content,
          imageUrl: remoteImageUrl,
        );
  }

  Future<void> deletePostComment({
    required String id,
    required String postId,
    required String parentCommentId,
    bool isReply = false,
    String? imageUrl,
  }) async {
    // delete image
    /*
    if (imageUrl != null) {
      await ref.read(firebaseStorageRepositoryProvider).deleteAsset(imageUrl);
    }
    */
    Future<void> deleteImage() async {
      if (imageUrl != null) {
        await ref.read(firebaseStorageRepositoryProvider).deleteAsset(imageUrl);
      }
    }

    // update comments count for post
    /*
    try {
      await ref
          .read(postsRepositoryProvider)
          .updatePostCommentCount(id: postId, number: -1);
    } catch (e) {
      debugPrint('post already deleted');
      debugPrint('failed updatePostCommentCount: ${e.toString()}');
    }
    */
    Future<void> updatePostCommentCount() async {
      try {
        await ref
            .read(postsRepositoryProvider)
            .updatePostCommentCount(id: postId, number: -1);
      } catch (e) {
        debugPrint('post already deleted');
        debugPrint('failed updatePostCommentCount: ${e.toString()}');
      }
    }

    /*
    // update replies count for comment
    if (isReply) {
      try {
        await ref
            .read(postCommentsRepositoryProvider)
            .updateReplyCount(id: parentCommentId, number: -1);
      } catch (e) {
        debugPrint('comment already deleted');
        debugPrint('failed updateReplyCount: ${e.toString()}');
      }
    }
    */

    // delete comment reports
    Future<void> deletePostCommentReports() async {
      final reportIds = await ref
          .read(postCommentReportsRepositoryProvider)
          .getPostCommentReportIdsForComment(id);

      await Future.wait(reportIds.map((reportId) => ref
          .read(postCommentReportsRepositoryProvider)
          .deletePostCommentReport(reportId)));
    }

    // delete comment likes
    /*
    final likeIds = await ref
        .read(postCommentLikesRepositoryProvider)
        .getPostCommentLikeIdsForComment(id);
    for (final likeId in likeIds) {
      await ref
          .read(postCommentLikesRepositoryProvider)
          .deletePostCommentLike(likeId);
    }
    */
    Future<void> deletePostCommentLikes() async {
      final likeIds = await ref
          .read(postCommentLikesRepositoryProvider)
          .getPostCommentLikeIdsForComment(id);

      await Future.wait(likeIds.map((likeId) => ref
          .read(postCommentLikesRepositoryProvider)
          .deletePostCommentLike(likeId)));
    }

    await Future.wait([
      deleteImage(),
      updatePostCommentCount(),
      deletePostCommentReports(),
      deletePostCommentLikes(),
    ]);

    // delete comment
    await ref.read(postCommentsRepositoryProvider).deletePostComment(id);
  }

  Future<void> increasePostCommentLike({
    required String id,
    required String uid,
    required String postId,
    required String commentId,
    required String commentWriterId,
    required String postWriterId,
    required String parentCommentId,
  }) async {
    // there is no comment, function must stop
    // update likes count for comment
    await ref.read(postCommentsRepositoryProvider).increaseLikeCount(commentId);
    // there is no comment writer, function must stop
    // update likes count for comment writer
    await ref
        .read(appUserRepositoryProvider)
        .increaseLikeCount(commentWriterId);
    // create comment like
    await ref.read(postCommentLikesRepositoryProvider).createPostCommentLike(
          id: id,
          uid: uid,
          postId: postId,
          commentId: commentId,
          commentWriterId: commentWriterId,
          postWriterId: postWriterId,
          parentCommentId: parentCommentId,
          createdAt: DateTime.now(),
        );
  }

  Future<void> decreasePostCommentLike({
    required String id,
    required String commentId,
    required String commentWriterId,
  }) async {
    // update likes count for comment
    try {
      await ref
          .read(postCommentsRepositoryProvider)
          .decreaseLikeCount(commentId);
    } catch (e) {
      debugPrint('comment already deleted');
      debugPrint('failed decreaseLikeCount: ${e.toString()}');
    }

    // update likes count for comment writer
    try {
      await ref
          .read(appUserRepositoryProvider)
          .decreaseLikeCount(commentWriterId);
    } catch (e) {
      debugPrint('comment writer already deleted');
      debugPrint('failed decreaseLikeCount: ${e.toString()}');
    }

    // delete comment like
    await ref
        .read(postCommentLikesRepositoryProvider)
        .deletePostCommentLike(id);
  }

  Future<void> increasePostCommentDislike({
    required String id,
    required String uid,
    required String postId,
    required String commentId,
    required String commentWriterId,
    required String postWriterId,
    required String parentCommentId,
  }) async {
    // update dislikes count for comment
    // there is no comment, function must stop
    await ref
        .read(postCommentsRepositoryProvider)
        .increaseDislikeCount(commentId);
    // update dislikes count for comment writer
    // there is no comment writer, function must stop
    await ref
        .read(appUserRepositoryProvider)
        .increaseDislikeCount(commentWriterId);
    // create comment dislike
    await ref.read(postCommentLikesRepositoryProvider).createPostCommentLike(
          id: id,
          uid: uid,
          postId: postId,
          commentId: commentId,
          commentWriterId: commentWriterId,
          postWriterId: postWriterId,
          parentCommentId: parentCommentId,
          isDislike: true,
          createdAt: DateTime.now(),
        );
  }

  Future<void> decreasePostCommentDislike({
    required String id,
    required String commentId,
    required String commentWriterId,
  }) async {
    // update dislikes count for comment
    try {
      await ref
          .read(postCommentsRepositoryProvider)
          .decreaseDislikeCount(commentId);
    } catch (e) {
      debugPrint('comment already deleted');
      debugPrint('failed decreaseDislikeCount: ${e.toString()}');
    }
    // update dislikes count for comment writer
    try {
      await ref
          .read(appUserRepositoryProvider)
          .decreaseDislikeCount(commentWriterId);
    } catch (e) {
      debugPrint('comment writer already deleted');
      debugPrint('failed decreaseDislikeCount: ${e.toString()}');
    }
    // delete comment dislike
    await ref
        .read(postCommentLikesRepositoryProvider)
        .deletePostCommentLike(id);
  }
}

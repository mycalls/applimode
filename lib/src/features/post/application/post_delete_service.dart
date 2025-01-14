import 'dart:developer' as dev;

import 'package:applimode_app/src/features/comments/data/post_comment_report_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_reports_repository.dart';
import 'package:applimode_app/src/features/profile/data/delete_errors_repository.dart';
import 'package:applimode_app/src/features/profile/domain/delete_error.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/comments/data/post_comment_likes_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comments_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_contents_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
// ignore: unused_import
import 'package:applimode_app/src/features/r_two_storage/r_two_storage_repository.dart';
import 'package:applimode_app/src/features/search/data/d_one_repository.dart';
import 'package:applimode_app/src/utils/delete_storage_list.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class PostDeleteService {
  const PostDeleteService(this.ref);

  final Ref ref;

  Future<void> deletePost({
    required String uid,
    required String postId,
    required bool isLongContent,
  }) async {
    final starts = DateTime.now();
    // delete comment likes
    Future<void> deleteCommentLikes() async {
      final commentLikeIds = await ref
          .read(postCommentLikesRepositoryProvider)
          .getPostCommentLikeIdsForPost(postId);
      for (var commentLikeId in commentLikeIds) {
        await ref
            .read(postCommentLikesRepositoryProvider)
            .deletePostCommentLike(commentLikeId);
      }
    }

    // delete comment reports
    Future<void> deleteCommentReports() async {
      final commentReportIds = await ref
          .read(postCommentReportsRepositoryProvider)
          .getPostCommentReportIdsForPost(postId);
      for (var commentReportId in commentReportIds) {
        await ref
            .read(postCommentReportsRepositoryProvider)
            .deletePostCommentReport(commentReportId);
      }
    }

    // delete post comments
    Future<void> deleteComments() async {
      final commentIds = await ref
          .read(postCommentsRepositoryProvider)
          .getPostCommentIdsForPost(postId);
      for (var commentId in commentIds) {
        await ref
            .read(postCommentsRepositoryProvider)
            .deletePostComment(commentId);
      }
    }

    // delete post likes
    Future<void> deletePostLikes() async {
      final postLikeIds = await ref
          .read(postLikesRepositoryProvider)
          .getPostLikeIdsForPost(postId);

      for (var postLikeId in postLikeIds) {
        await ref.read(postLikesRepositoryProvider).deletePostLike(postLikeId);
      }
    }

    // delete post reports
    Future<void> deletePostReports() async {
      final postReportIds = await ref
          .read(postReportsRepositoryProvider)
          .getPostReportIdsForPost(postId);

      for (var postReportId in postReportIds) {
        await ref
            .read(postReportsRepositoryProvider)
            .deletePostReport(postReportId);
      }
    }

    // delete postContent
    Future<void> deleteLongContent() async {
      if (isLongContent) {
        await ref
            .read(postContentsRepositoryProvider)
            .deletePostContent(postId);
      }
    }

    // delete comment medias
    Future<void> deleteCommentMedia() async {
      try {
        await deleteStorageList(ref, '$commentsPath/$postId');
      } catch (e) {
        final id = const Uuid().v7();
        try {
          await ref.read(deleteErrorsRepositoryProvider).createDeleteError(
                id: id,
                uid: uid,
                errorType: DeleteErrorType.postCommentMedia.name,
                errorIdType: DeleteErrorIdType.postId.name,
                errorId: postId,
              );
        } catch (e) {
          debugPrint('failed createDeleteError: ${e.toString()}');
        }
        debugPrint('filed deleteCommentMedia: ${e.toString()}');
      }
    }

    // delete media for firebase storage
    Future<void> deleteFBPostMedia() async {
      await deleteStorageList(ref, '$uid/$postsPath/$postId');
    }

    // delete media for cloudflare r2 storage
    Future<void> deleteCFPostMedia() async {
      if (useRTwoStorage) {
        try {
          await ref
              .read(rTwoStorageRepositoryProvider)
              .deleteAssetsList('$uid/$postsPath/$postId');
        } catch (e) {
          final id = const Uuid().v7();
          try {
            await ref.read(deleteErrorsRepositoryProvider).createDeleteError(
                  id: id,
                  uid: uid,
                  errorType: DeleteErrorType.postMediaFromCloudflare.name,
                  errorIdType: DeleteErrorIdType.postId.name,
                  errorId: postId,
                );
          } catch (e) {
            debugPrint('failed createDeleteError: ${e.toString()}');
          }

          debugPrint('failed deleteCFPostMedia: ${e.toString()}');
        }
      }
    }

    // delete cloudflare d1 search index
    Future<void> deleteDOne() async {
      if (useDOneForSearch) {
        try {
          ref.read(dOneRepositoryProvider).deletePostsSearch(postId);
        } catch (e) {
          final id = const Uuid().v7();
          try {
            await ref.read(deleteErrorsRepositoryProvider).createDeleteError(
                  id: id,
                  uid: uid,
                  errorType: DeleteErrorType.postDOne.name,
                  errorIdType: DeleteErrorIdType.postId.name,
                  errorId: postId,
                );
          } catch (e) {
            debugPrint('failed createDeleteError: ${e.toString()}');
          }

          debugPrint('failed deleteDOne: ${e.toString()}');
        }
      }
    }

    await Future.wait([
      deleteCommentLikes(),
      deleteCommentReports(),
      deleteComments(),
      deletePostLikes(),
      deletePostReports(),
      deleteLongContent(),
      deleteCommentMedia(),
      deleteFBPostMedia(),
      deleteCFPostMedia(),
      deleteDOne(),
    ]);

    // delete post
    await ref.read(postsRepositoryProvider).deletePost(postId);

    /*
    // delete comment likes
    final commentLikeIds = await ref
        .read(postCommentLikesRepositoryProvider)
        .getPostCommentLikeIdsForPost(postId);
    for (var commentLikeId in commentLikeIds) {
      await ref
          .read(postCommentLikesRepositoryProvider)
          .deletePostCommentLike(commentLikeId);
    }

    // delete post comments
    final commentIds = await ref
        .read(postCommentsRepositoryProvider)
        .getPostCommentIdsForPost(postId);
    for (var commentId in commentIds) {
      await ref
          .read(postCommentsRepositoryProvider)
          .deletePostComment(commentId);
    }

    // delete post likes
    final postLikeIds = await ref
        .read(postLikesRepositoryProvider)
        .getPostLikeIdsForPost(postId);

    for (var postLikeId in postLikeIds) {
      await ref.read(postLikesRepositoryProvider).deletePostLike(postLikeId);
    }

    // delete comment medias
    try {
      await deleteStorageList(ref, '$commentsPath/$postId');
    } catch (e) {
      debugPrint('already delete');
      debugPrint('deleteStorageList: ${e.toString()}');
    }

    // delete post medias
    // for firebase storage
    try {
      await deleteStorageList(ref, '$uid/$postsPath/$postId');
    } catch (e) {
      debugPrint('already delete');
      debugPrint('deleteStorageList: ${e.toString()}');
    }
    // useFirebaseStorage
    if (useRTwoStorage) {
      try {
        await ref
            .read(rTwoStorageRepositoryProvider)
            .deleteAssetsList('$uid/$postsPath/$postId');
      } catch (e) {
        debugPrint('already delete');
        debugPrint('deleteAssetsList: ${e.toString()}');
      }
    }

    // delete d1 search index
    if (useDOneForSearch) {
      try {
        ref.read(dOneRepositoryProvider).deletePostsSearch(postId);
      } catch (e) {
        debugPrint('already delete');
        debugPrint('deletePostsSearch: ${e.toString()}');
      }
    }

    // delete postContent
    if (isLongContent) {
      try {
        await ref
            .read(postContentsRepositoryProvider)
            .deletePostContent(postId);
      } catch (e) {
        debugPrint('already delete');
        debugPrint('deletePostContent: ${e.toString()}');
      }
    }

    // delete post
    await ref.read(postsRepositoryProvider).deletePost(postId);
    */

    final ends = DateTime.now();
    dev.log(
        'delete duration: ${Duration(milliseconds: ends.millisecondsSinceEpoch - starts.millisecondsSinceEpoch)}');
  }
}

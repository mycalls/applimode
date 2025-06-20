// lib/src/features/authentication/application/delete_account_service.dart

import 'dart:developer' as dev;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:applimode_app/src/features/firebase_storage/firebase_storage_repository.dart';
import 'package:applimode_app/src/features/r_two_storage/r_two_storage_repository.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comment_likes_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comment_report_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comments_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_contents_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_reports_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/profile/data/delete_errors_repository.dart';
import 'package:applimode_app/src/features/profile/domain/delete_error.dart';
import 'package:applimode_app/src/features/prompts/data/user_prompts_repository.dart';

part 'delete_account_service.g.dart';

class DeleteAccountService {
  const DeleteAccountService(this._ref);

  final Ref _ref;

  Future<void> deleteAccount({
    required String uid,
  }) async {
    final starts = DateTime.now();
    // delete posts for user
    Future<void> deletePostsForUser() async {
      final postIds =
          await _ref.read(postsRepositoryProvider).getPostIdsForUser(uid);
      for (var postId in postIds) {
        await _ref.read(postsRepositoryProvider).deletePost(postId);
      }
    }

    // delete longPostContents for user
    Future<void> deleteLongPostContentsForUser() async {
      final postContentIds = await _ref
          .read(postContentsRepositoryProvider)
          .getPostContentIdsForUser(uid);
      for (var postContentId in postContentIds) {
        await _ref
            .read(postContentsRepositoryProvider)
            .deletePostContent(postContentId);
      }
    }

    // delete post media and profile media from firebase
    Future<void> deleteUserPostsAndProfileMediaFromFB() async {
      final storage = _ref.read(firebaseStorageRepositoryProvider);
      final userMediaRef = storage.storageRef(uid);
      final userMediaList = await userMediaRef.listAll();
      for (var prefix in userMediaList.prefixes) {
        // posts, profile, story
        final firstBucketRef = storage.storageRef(prefix.fullPath);
        final firstBucketList = await firstBucketRef.listAll();
        // delete post media
        for (var firstBucketPrefix in firstBucketList.prefixes) {
          final secondBucketRef =
              storage.storageRef(firstBucketPrefix.fullPath);
          final secondBucketList = await secondBucketRef.listAll();
          for (var item in secondBucketList.items) {
            await item.delete();
          }
        }
        // delete profile media
        for (var item in firstBucketList.items) {
          await item.delete();
        }
      }
    }

    // delete post media form r2
    Future<void> deleteUserPostsMediaFromCF() async {
      if (useRTwoStorage) {
        try {
          await _ref.read(rTwoStorageRepositoryProvider).deleteAssetsList(uid);
        } catch (e) {
          final id = const Uuid().v7();
          try {
            await _ref.read(deleteErrorsRepositoryProvider).createDeleteError(
                  id: id,
                  uid: uid,
                  errorType: DeleteErrorType.userPostMediaFromCloudflare.name,
                  errorIdType: DeleteErrorIdType.uid.name,
                  errorId: uid,
                );
          } catch (e) {
            debugPrint('failed createDeleteError: ${e.toString()}');
          }

          debugPrint('failed deleteUserPostsMediaFromCF: ${e.toString()}');
        }
      }
    }

    // delete comments and comment media for close
    Future<void> deleteCommentsAndCommentsMediaForClose() async {
      final postCommentsForClose = await _ref
          .read(postCommentsRepositoryProvider)
          .getPostCommentsForClose(uid);
      for (var postComment in postCommentsForClose) {
        if (postComment.imageUrl != null) {
          await _ref
              .read(firebaseStorageRepositoryProvider)
              .deleteAsset(postComment.imageUrl!);
        }
        await _ref
            .read(postCommentsRepositoryProvider)
            .deletePostComment(postComment.id);
      }
    }

    // delete postLikes for close
    Future<void> deletePostLikesForClose() async {
      final postLikeIdsForClose = await _ref
          .read(postLikesRepositoryProvider)
          .getPostLikeIdsForClose(uid);
      for (var postLikeId in postLikeIdsForClose) {
        await _ref.read(postLikesRepositoryProvider).deletePostLike(postLikeId);
      }
    }

    // delete postReports for close
    Future<void> deletePostReportsForClose() async {
      final postReportIdsForClose = await _ref
          .read(postReportsRepositoryProvider)
          .getPostReportIdsForClose(uid);
      for (var postReportId in postReportIdsForClose) {
        await _ref
            .read(postReportsRepositoryProvider)
            .deletePostReport(postReportId);
      }
    }

    // delete postCommentLikes for close
    Future<void> deletePostCommentLikesForClose() async {
      final postCommentLikeIdsForClose = await _ref
          .read(postCommentLikesRepositoryProvider)
          .getPostCommentLikeIdsForClose(uid);
      for (var postCommentLikeId in postCommentLikeIdsForClose) {
        await _ref
            .read(postCommentLikesRepositoryProvider)
            .deletePostCommentLike(postCommentLikeId);
      }
    }

    // delete postCommentReports for close
    Future<void> deletePostCommentReportsForClose() async {
      final postCommentReportIdsForClose = await _ref
          .read(postCommentReportsRepositoryProvider)
          .getPostCommentReportIdsForClose(uid);
      for (var postCommentReportId in postCommentReportIdsForClose) {
        await _ref
            .read(postCommentReportsRepositoryProvider)
            .deletePostCommentReport(postCommentReportId);
      }
    }

    // delete prompts from user
    Future<void> deleteUserPrompt() async {
      final userPromptIdsForUser = await _ref
          .read(userPromptsRepositoryProvider)
          .getUserPromptIdsForUser(uid);
      for (var userPromptId in userPromptIdsForUser) {
        await _ref
            .read(userPromptsRepositoryProvider)
            .deleteUserPrompt(userPromptId);
      }
    }

    await Future.wait([
      deletePostsForUser(),
      deleteLongPostContentsForUser(),
      deleteUserPostsAndProfileMediaFromFB(),
      deleteUserPostsMediaFromCF(),
      deleteCommentsAndCommentsMediaForClose(),
      deletePostLikesForClose(),
      deletePostReportsForClose(),
      deletePostCommentLikesForClose(),
      deletePostCommentReportsForClose(),
      deleteUserPrompt(),
    ]);

    // delete app user
    await _ref.read(appUserRepositoryProvider).deleteAppUser(uid);

    /*
    // create appLeaver
    await _ref.read(appLeaversRepositoryProvider).createAppLeaver(
          id: uid,
          closedAt: DateTime.now(),
        );
    */

    // delete auth user
    await _ref.read(authRepositoryProvider).currentUser!.delete();
    final ends = DateTime.now();
    dev.log(
        'userCloser duration: ${Duration(milliseconds: ends.millisecondsSinceEpoch - starts.millisecondsSinceEpoch)}');
  }
}

@riverpod
DeleteAccountService deleteAccountService(Ref ref) {
  return DeleteAccountService(ref);
}

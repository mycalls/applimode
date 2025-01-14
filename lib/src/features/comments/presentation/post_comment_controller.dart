import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/exceptions/app_exception.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/comments/application/post_comments_service.dart';
import 'package:applimode_app/src/features/comments/data/post_comment_likes_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comment_report_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comments_repository.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_list_state.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/utils/call_fcm_function.dart';
import 'package:applimode_app/src/utils/is_firestore_not_found.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/nanoid.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';
import 'package:applimode_app/src/utils/updated_comment_ids_list.dart';
import 'package:applimode_app/src/utils/updated_post_ids_list.dart';
import 'package:applimode_app/src/utils/updated_user_ids_list.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'post_comment_controller.g.dart';

@riverpod
class PostCommentController extends _$PostCommentController {
// ignore: avoid_public_notifier_properties
  Object? key;

  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<bool> leaveComment({
    String? postId,
    String? parentCommentId,
    required bool isReply,
    String? content,
    XFile? xFile,
    String? mediaType,
    AppUser? postWriter,
    required String commentNotiString,
    required String replyNotiString,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    final listState = ref.read(postCommentsListStateControllerProvider);
    if (user == null) {
      state = AsyncError(NeedLogInException(), StackTrace.current);
      return false;
    }
    if (postId == null) {
      state = AsyncError(PageNotFoundException(), StackTrace.current);
      return false;
    }

    if (content == null && xFile == null) {
      state = AsyncError(EmptyContentException(), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    try {
      if (postWriter == null) {
        final post = await ref.read(postsRepositoryProvider).fetchPost(postId);
        if (post != null) {
          postWriter = await ref.read(appUserFutureProvider(post.uid).future);
        }
      }
    } catch (e) {
      state = AsyncError(PageNotFoundException(), StackTrace.current);
      return false;
    }

    if (postWriter == null) {
      state = AsyncError(PostWriterNotFoundException(), StackTrace.current);
      return false;
    }

    final key = this.key;
    final id = nanoid();
    final newState = await AsyncValue.guard(
      () => PostCommentsService(ref).leavePostComment(
        id: id,
        uid: user.uid,
        postId: postId,
        parentCommentId: parentCommentId ?? id,
        postWriterId: postWriter!.uid,
        isReply: isReply,
        content: content,
        xFile: xFile,
        mediaType: mediaType,
      ),
    );

    if (key == this.key) {
      if (newState.hasError && isFirestoreNotFound(newState.error.toString())) {
        state = AsyncError(PageNotFoundException(), StackTrace.current);
        ref.read(updatedPostIdsListProvider.notifier).set(postId);
        return false;
      } else {
        state = newState;
      }
    }

    if (state.hasError) {
      debugPrint('leaveComment: ${state.error.toString()}');
      return false;
    }

    if (useFcmMessage) {
      try {
        if (postWriter.fcmToken != null && postWriter.fcmToken!.isNotEmpty) {
          FcmFunctions.callSendMessage(
            type: isReply ? 'replies' : 'comments',
            content: isReply
                ? '${user.displayName ?? 'Unknown'} $replyNotiString'
                : '${user.displayName ?? 'Unknown'} $commentNotiString',
            postId: postId,
            commentId: parentCommentId,
            token: postWriter.fcmToken,
          );
        }
      } catch (e) {
        debugPrint('fcmError: ${e.toString()}');
      }
    }

    // update posts list
    ref.read(updatedPostIdsListProvider.notifier).set(postId);
    // support live updage when only byCreatedAt
    // refresh comments list menually
    if (!listState.byCreatedAt) {
      ref.read(commentsListStateProvider.notifier).set(nowToInt());
    }

    return true;
  }

  Future<bool> deleteComment({
    required String id,
    required String parentCommentId,
    required String postId,
    required bool isReply,
    required String commentWriterId,
    required bool isAdmin,
    String? imageUrl,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null || user.uid != commentWriterId && isAdmin == false) {
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final newState =
        await AsyncValue.guard(() => PostCommentsService(ref).deletePostComment(
              id: id,
              postId: postId,
              parentCommentId: parentCommentId,
              isReply: isReply,
              imageUrl: imageUrl,
            ));

    if (key == this.key) {
      if (newState.hasError && isFirestoreNotFound(newState.error.toString())) {
        state = AsyncError(PageNotFoundException(), StackTrace.current);
        ref.read(updatedPostIdsListProvider.notifier).set(postId);
        ref.read(updatedCommentIdsListProvider.notifier).set(id);
        return false;
      } else {
        state = newState;
      }
    }

    if (state.hasError) {
      debugPrint('deleteComment: ${state.error.toString()}');
      return false;
    }

    // update posts list
    ref.read(updatedPostIdsListProvider.notifier).set(postId);
    // update comments list
    ref.read(updatedCommentIdsListProvider.notifier).set(id);

    return true;
  }

  Future<bool> increasePostCommentLike({
    required String commentId,
    required String postId,
    required String commentWriterId,
    required String postWriterId,
    required String parentCommentId,
    AppUser? commentWriter,
    required String commentLikeNotiString,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(NeedLogInException(), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final id = const Uuid().v7();
    final newState = await AsyncValue.guard(
      () => PostCommentsService(ref).increasePostCommentLike(
        id: id,
        uid: user.uid,
        postId: postId,
        commentId: commentId,
        commentWriterId: commentWriterId,
        postWriterId: postWriterId,
        parentCommentId: parentCommentId,
      ),
    );

    if (key == this.key) {
      if (newState.hasError && isFirestoreNotFound(newState.error.toString())) {
        state = AsyncError(PageNotFoundException(), StackTrace.current);
        ref.read(updatedCommentIdsListProvider.notifier).set(commentId);
        return false;
      } else {
        state = newState;
      }
    }

    if (state.hasError) {
      debugPrint('increasePostCommentLike: ${state.error.toString()}');
      return false;
    }

    if (useFcmMessage) {
      try {
        commentWriter ??=
            await ref.read(appUserFutureProvider(commentWriterId).future);

        if (commentWriter != null &&
            commentWriter.fcmToken != null &&
            commentWriter.fcmToken!.isNotEmpty) {
          FcmFunctions.callSendMessage(
            type: 'commentLikes',
            content: '${user.displayName ?? 'Unknown'} $commentLikeNotiString',
            postId: postId,
            token: commentWriter.fcmToken,
          );
        }
      } catch (e) {
        debugPrint('fcmError: ${e.toString()}');
      }
    }

    ref.invalidate(postCommentLikesByUserFutureProvider);
    ref.invalidate(writerFutureProvider);
    // update comments list
    ref.read(updatedCommentIdsListProvider.notifier).set(commentId);
    // update users list
    ref.read(updatedUserIdsListProvider.notifier).set(commentWriterId);
    // refresh likes list
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    return true;
  }

  Future<bool> decreasePostCommentLike({
    required String id,
    required String commentId,
    required String commentWriterId,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(NeedLogInException(), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final newState = await AsyncValue.guard(
      () => PostCommentsService(ref).decreasePostCommentLike(
        id: id,
        commentId: commentId,
        commentWriterId: commentWriterId,
      ),
    );

    if (key == this.key) {
      if (newState.hasError && isFirestoreNotFound(newState.error.toString())) {
        state = AsyncError(PageNotFoundException(), StackTrace.current);
        ref.read(updatedCommentIdsListProvider.notifier).set(commentId);
        return false;
      } else {
        state = newState;
      }
    }

    if (state.hasError) {
      debugPrint('decreasePostCommentLike: ${state.error.toString()}');
      return false;
    }

    ref.invalidate(postCommentLikesByUserFutureProvider);
    ref.invalidate(writerFutureProvider);
    // update comments list
    ref.read(updatedCommentIdsListProvider.notifier).set(commentId);
    // update users list
    ref.read(updatedUserIdsListProvider.notifier).set(commentWriterId);
    // refresh likes list
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    return true;
  }

  Future<bool> increasePostCommentDislike({
    required String commentId,
    required String postId,
    required String commentWriterId,
    required String postWriterId,
    required String parentCommentId,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(NeedLogInException(), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final id = const Uuid().v7();
    final newState = await AsyncValue.guard(
      () => PostCommentsService(ref).increasePostCommentDislike(
        id: id,
        uid: user.uid,
        postId: postId,
        commentId: commentId,
        commentWriterId: commentWriterId,
        postWriterId: postWriterId,
        parentCommentId: parentCommentId,
      ),
    );

    if (key == this.key) {
      if (newState.hasError && isFirestoreNotFound(newState.error.toString())) {
        state = AsyncError(PageNotFoundException(), StackTrace.current);
        ref.read(updatedCommentIdsListProvider.notifier).set(commentId);
        return false;
      } else {
        state = newState;
      }
    }

    if (state.hasError) {
      debugPrint('increasePostCommentDislike: ${state.error.toString()}');
      return false;
    }

    ref.invalidate(postCommentLikesByUserFutureProvider);
    ref.invalidate(writerFutureProvider);
    // update comments list
    ref.read(updatedCommentIdsListProvider.notifier).set(commentId);
    // update users list
    ref.read(updatedUserIdsListProvider.notifier).set(commentWriterId);
    // refresh likes list
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    return true;
  }

  Future<bool> decreasePostCommentDislike({
    required String id,
    required String commentId,
    required String commentWriterId,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(NeedLogInException(), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final newState = await AsyncValue.guard(
      () => PostCommentsService(ref).decreasePostCommentDislike(
        id: id,
        commentId: commentId,
        commentWriterId: commentWriterId,
      ),
    );

    if (key == this.key) {
      if (newState.hasError && isFirestoreNotFound(newState.error.toString())) {
        state = AsyncError(PageNotFoundException(), StackTrace.current);
        ref.read(updatedCommentIdsListProvider.notifier).set(commentId);
        return false;
      } else {
        state = newState;
      }
    }

    if (state.hasError) {
      debugPrint('decreasePostCommentDislike: ${state.error.toString()}');
      return false;
    }

    ref.invalidate(postCommentLikesByUserFutureProvider);
    ref.invalidate(writerFutureProvider);
    // update comments list
    ref.read(updatedCommentIdsListProvider.notifier).set(commentId);
    // update users list
    ref.read(updatedUserIdsListProvider.notifier).set(commentWriterId);
    // refresh likes list
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    return true;
  }

  Future<bool> reportCommentIssue({
    required String commentId,
    required String postId,
    required String commentWriterId,
    required String postWriterId,
    required int reportType,
    String? custom,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }

    final postCommentsRepository = ref.read(postCommentsRepositoryProvider);
    final postCommentReportsRepository =
        ref.read(postCommentReportsRepositoryProvider);
    final id = '${user.uid}-$commentId';
    state = const AsyncLoading();
    try {
      final userReport =
          await postCommentReportsRepository.fetchPostCommentReport(id);
      if (userReport != null) {
        state = AsyncError(AlreadyReportException(), StackTrace.current);
        return false;
      }
    } catch (e) {
      debugPrint('FailedreportPostIssue: $e');
      state = AsyncError(Exception('Try later'), StackTrace.current);
      return false;
    }

    final key = this.key;
    final newState = await AsyncValue.guard(() async {
      postCommentsRepository.increaseReportCount(commentId);
      postCommentReportsRepository.createPostCommentReport(
        id: id,
        uid: user.uid,
        postId: postId,
        commentId: commentId,
        commentWriterId: commentWriterId,
        postWriterId: postWriterId,
        reportType: reportType,
        custom: custom,
        createdAt: DateTime.now(),
      );
    });
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('reportCommentIssueError: ${state.error.toString()}');
      return false;
    }

    return true;
  }
}

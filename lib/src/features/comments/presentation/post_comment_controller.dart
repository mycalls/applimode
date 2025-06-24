// flutter
import 'package:flutter/widgets.dart';

// external
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/app_states/list_state.dart';
import 'package:applimode_app/src/core/app_states/updated_comment_id.dart';
import 'package:applimode_app/src/core/app_states/updated_post_id.dart';
import 'package:applimode_app/src/core/app_states/updated_user_id.dart';
import 'package:applimode_app/src/core/exceptions/app_exception.dart';
import 'package:applimode_app/src/core/fcm/call_fcm_function.dart';

// utils
import 'package:applimode_app/src/utils/is_firestore_not_found.dart';
import 'package:applimode_app/src/utils/nanoid.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';

// features
import 'package:applimode_app/src/features/comments/data/post_comment_report_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comments_repository.dart';
import 'package:applimode_app/src/features/comments/application/post_comments_service.dart';
import 'package:applimode_app/src/features/comments/application/user_post_comment_dislike_data_provider.dart';
import 'package:applimode_app/src/features/comments/application/user_post_comment_like_data_provider.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_list_state.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/application/providers/post_data_provider.dart';

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
    required String postId,
    String? parentCommentId,
    required bool isReply,
    String? content,
    XFile? xFile,
    String? mediaType,
    required String commentNotiString,
    required String replyNotiString,
  }) async {
    if (content == null && xFile == null) {
      state = AsyncError(EmptyContentException(), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    // on WASM, sometimes state changes AsycLoading and not work
    final postNotifier = ref.read(postDataProvider(PostArgs(postId)).notifier);

    final user = ref.read(authRepositoryProvider).currentUser;

    if (user == null) {
      state = AsyncError(NeedLogInException(), StackTrace.current);
      return false;
    }

    Post? currentPost;
    try {
      currentPost = await ref.read(postDataProvider(PostArgs(postId)).future);
    } catch (e) {
      state = AsyncError(PageNotFoundException(), StackTrace.current);
      return false;
    }

    if (currentPost == null) {
      state = AsyncError(PageNotFoundException(), StackTrace.current);
      return false;
    }

    AppUser? postWriter;
    try {
      postWriter = await ref.read(appUserDataProvider(currentPost.uid).future);
    } catch (e) {
      state = AsyncError(PostWriterNotFoundException(), StackTrace.current);
      return false;
    }

    if (postWriter == null) {
      state = AsyncError(PostWriterNotFoundException(), StackTrace.current);
      return false;
    }

    final listState = ref.read(postCommentsListStateControllerProvider);

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
        ref.read(updatedPostIdProvider.notifier).set(postId);
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
    ref.read(updatedPostIdProvider.notifier).set(postId);
    postNotifier.optimisticIncreaseComment();
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

    // on WASM, sometimes state changes AsycLoading and not work
    final postNotifier = ref.read(postDataProvider(PostArgs(postId)).notifier);

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
        ref.read(updatedPostIdProvider.notifier).set(postId);
        ref.read(updatedCommentIdProvider.notifier).set(id);
        return false;
      } else {
        state = newState;
      }
    }

    if (state.hasError) {
      debugPrint('deleteComment: ${state.error.toString()}');
      return false;
    }

    postNotifier.optimisticDecreaseComment();

    // update posts list
    ref.read(updatedPostIdProvider.notifier).set(postId);
    // update comments list
    ref.read(updatedCommentIdProvider.notifier).set(id);

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

    // on WASM, sometimes state changes AsycLoading and not work
    final appUserNotifier =
        ref.read(appUserDataProvider(commentWriterId).notifier);
    final commentLikeNotifier = ref.read(
        userPostCommentLikeDataProvider(commentId: commentId, uid: user.uid)
            .notifier);

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
        ref.read(updatedCommentIdProvider.notifier).set(commentId);
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
            await ref.read(appUserDataProvider(commentWriterId).future);

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

    // update comments list
    ref.read(updatedCommentIdProvider.notifier).set(commentId);
    // update users list
    ref.read(updatedUserIdProvider.notifier).set(commentWriterId);
    // refresh likes list
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    appUserNotifier.increaseOptimisticLike();
    commentLikeNotifier.increaseOptimisticLike(
      id: id,
      postId: postId,
      commentWriterId: commentWriterId,
      postWriterId: postWriterId,
      parentCommentId: parentCommentId,
    );

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

    // on WASM, sometimes state changes AsycLoading and not work
    final appUserNotifier =
        ref.read(appUserDataProvider(commentWriterId).notifier);
    final commentLikeNotifier = ref.read(
        userPostCommentLikeDataProvider(commentId: commentId, uid: user.uid)
            .notifier);

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
        ref.read(updatedCommentIdProvider.notifier).set(commentId);
        return false;
      } else {
        state = newState;
      }
    }

    if (state.hasError) {
      debugPrint('decreasePostCommentLike: ${state.error.toString()}');
      return false;
    }

    // update comments list
    ref.read(updatedCommentIdProvider.notifier).set(commentId);
    // update users list
    ref.read(updatedUserIdProvider.notifier).set(commentWriterId);
    // refresh likes list
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    appUserNotifier.decreaseOptimisticLike();
    commentLikeNotifier.decreaseOptimisticLike();

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

    // on WASM, sometimes state changes AsycLoading and not work
    final appUserNotifier =
        ref.read(appUserDataProvider(commentWriterId).notifier);
    final commentLikeNotifier = ref.read(
        userPostCommentDislikeDataProvider(commentId: commentId, uid: user.uid)
            .notifier);

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
        ref.read(updatedCommentIdProvider.notifier).set(commentId);
        return false;
      } else {
        state = newState;
      }
    }

    if (state.hasError) {
      debugPrint('increasePostCommentDislike: ${state.error.toString()}');
      return false;
    }

    // update comments list
    ref.read(updatedCommentIdProvider.notifier).set(commentId);
    // update users list
    ref.read(updatedUserIdProvider.notifier).set(commentWriterId);
    // refresh likes list
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    appUserNotifier.increaseOptimisticDislike();
    commentLikeNotifier.increaseOptimisticDislike(
      id: id,
      postId: postId,
      commentWriterId: commentWriterId,
      postWriterId: postWriterId,
      parentCommentId: parentCommentId,
    );

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

    // on WASM, sometimes state changes AsycLoading and not work
    final appUserNotifier =
        ref.read(appUserDataProvider(commentWriterId).notifier);
    final commentLikeNotifier = ref.read(
        userPostCommentDislikeDataProvider(commentId: commentId, uid: user.uid)
            .notifier);

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
        ref.read(updatedCommentIdProvider.notifier).set(commentId);
        return false;
      } else {
        state = newState;
      }
    }

    if (state.hasError) {
      debugPrint('decreasePostCommentDislike: ${state.error.toString()}');
      return false;
    }

    // update comments list
    ref.read(updatedCommentIdProvider.notifier).set(commentId);
    // update users list
    ref.read(updatedUserIdProvider.notifier).set(commentWriterId);
    // refresh likes list
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    appUserNotifier.decreaseOptimisticDislike();
    commentLikeNotifier.decreaseOptimisticDislike();

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

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/exceptions/app_exception.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/post/application/post_likes_service.dart';
import 'package:applimode_app/src/features/posts/application/post_data_provider.dart';
import 'package:applimode_app/src/features/posts/application/user_post_dislike_data_provider.dart';
import 'package:applimode_app/src/features/posts/application/user_post_like_data_provider.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/utils/app_states/updated_post_id.dart';
import 'package:applimode_app/src/utils/app_states/updated_user_id.dart';
import 'package:applimode_app/src/utils/call_fcm_function.dart';
import 'package:applimode_app/src/utils/is_firestore_not_found.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'post_likes_controller.g.dart';

@riverpod
class PostLikesController extends _$PostLikesController {
// ignore: avoid_public_notifier_properties
  Object? key;
  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<bool> increasePostLikeCount({
    required String postId,
    required String postWriterId,
    AppUser? postWriter,
    required String postLikeNotiString,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(NeedLogInException(), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    // on WASM, sometimes state changes AsycLoading and not work
    final appUserNotifier =
        ref.read(appUserDataProvider(postWriterId).notifier);
    final postLikeNotifier = ref
        .read(userPostLikeDataProvider(postId: postId, uid: user.uid).notifier);
    final postNotifier = ref.read(postDataProvider(PostArgs(postId)).notifier);

    final key = this.key;
    final id = const Uuid().v7();
    final newState = await AsyncValue.guard(
      () => PostLikesService(ref).increasePostLikeCount(
        id: id,
        uid: user.uid,
        postId: postId,
        postWriterId: postWriterId,
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
      debugPrint('failed increasePostLikeCount: ${state.error.toString()}');
      return false;
    }

    if (useFcmMessage) {
      try {
        postWriter ??= await ref.read(appUserDataProvider(postWriterId).future);

        if (postWriter != null &&
            postWriter.fcmToken != null &&
            postWriter.fcmToken!.isNotEmpty) {
          FcmFunctions.callSendMessage(
            type: 'postLikes',
            content: '${user.displayName ?? 'Unknown'} $postLikeNotiString',
            postId: postId,
            token: postWriter.fcmToken,
          );
        }
      } catch (e) {
        debugPrint('fcmError: ${e.toString()}');
      }
    }

    ref.read(updatedPostIdProvider.notifier).set(postId);
    ref.read(updatedUserIdProvider.notifier).set(postWriterId);
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    appUserNotifier.increaseOptimisticLike();
    postLikeNotifier.increaseOptimisticLike(id, postWriterId);
    postNotifier.optimisticIncreaseLike();

    return true;
  }

  Future<bool> decreasePostLikeCount({
    required String id,
    required String postId,
    required String postWriterId,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(NeedLogInException(), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    // on WASM, sometimes state changes AsycLoading and not work
    final appUserNotifier =
        ref.read(appUserDataProvider(postWriterId).notifier);
    final postLikeNotifier = ref
        .read(userPostLikeDataProvider(postId: postId, uid: user.uid).notifier);
    final postNotifier = ref.read(postDataProvider(PostArgs(postId)).notifier);

    final key = this.key;
    final newState = await AsyncValue.guard(
      () => PostLikesService(ref).decreasePostLikeCount(
        id: id,
        postId: postId,
        postWriterId: postWriterId,
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
      debugPrint('failed decreasePostLikeCount: ${state.error.toString()}');
      return false;
    }

    ref.read(updatedPostIdProvider.notifier).set(postId);
    ref.read(updatedUserIdProvider.notifier).set(postWriterId);
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    appUserNotifier.decreaseOptimisticLike();
    postLikeNotifier.decreaseOptimisticLike();
    postNotifier.optimisticDecreaseLike();

    return true;
  }

  Future<bool> increasePostDislikeCount({
    required String postId,
    required String postWriterId,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(NeedLogInException(), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    // on WASM, sometimes state changes AsycLoading and not work
    final appUserNotifier =
        ref.read(appUserDataProvider(postWriterId).notifier);
    final postLikeNotifier = ref.read(
        userPostDislikeDataProvider(postId: postId, uid: user.uid).notifier);
    final postNotifier = ref.read(postDataProvider(PostArgs(postId)).notifier);

    final key = this.key;
    final id = const Uuid().v7();
    final newState = await AsyncValue.guard(
      () => PostLikesService(ref).increasePostDislikeCount(
        id: id,
        uid: user.uid,
        postId: postId,
        postWriterId: postWriterId,
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
      debugPrint('failed increasePostDislikeCount: ${state.error.toString()}');
      return false;
    }

    ref.read(updatedPostIdProvider.notifier).set(postId);
    ref.read(updatedUserIdProvider.notifier).set(postWriterId);
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    appUserNotifier.increaseOptimisticDislike();
    postLikeNotifier.increaseOptimisticDislike(id, postWriterId);
    postNotifier.optimisticIncreaseDislike();

    return true;
  }

  Future<bool> decreasePostDislikeCount({
    required String id,
    required String postId,
    required String postWriterId,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(NeedLogInException(), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    // on WASM, sometimes state changes AsycLoading and not work
    final appUserNotifier =
        ref.read(appUserDataProvider(postWriterId).notifier);
    final postLikeNotifier = ref.read(
        userPostDislikeDataProvider(postId: postId, uid: user.uid).notifier);
    final postNotifier = ref.read(postDataProvider(PostArgs(postId)).notifier);

    final key = this.key;
    final newState = await AsyncValue.guard(
      () => PostLikesService(ref).decreasePostDislikeCount(
        id: id,
        postId: postId,
        postWriterId: postWriterId,
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
      debugPrint('failed decreasePostDislikeCount: ${state.error.toString()}');
      return false;
    }

    ref.read(updatedPostIdProvider.notifier).set(postId);
    ref.read(updatedUserIdProvider.notifier).set(postWriterId);
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    appUserNotifier.decreaseOptimisticDislike();
    postLikeNotifier.decreaseOptimisticDislike();
    postNotifier.optimisticDecreaseDislike();

    return true;
  }
}

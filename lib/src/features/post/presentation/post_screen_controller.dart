import 'package:applimode_app/src/exceptions/app_exception.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/post/application/post_delete_service.dart';
import 'package:applimode_app/src/features/posts/application/post_data_provider.dart';
import 'package:applimode_app/src/features/posts/data/post_reports_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/utils/app_states/updated_post_id.dart';
import 'package:applimode_app/src/utils/is_firestore_not_found.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_screen_controller.g.dart';

@riverpod
class PostScreenController extends _$PostScreenController {
// ignore: avoid_public_notifier_properties
  Object? key;
  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<bool> deletePost({
    required String postId,
    required Post post,
    required bool isAdmin,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null || post.uid != user.uid && isAdmin == false) {
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final newState = await AsyncValue.guard(() => PostDeleteService(ref)
        .deletePost(
            uid: post.uid, postId: post.id, isLongContent: post.isLongContent));
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('deletePostError: ${state.error.toString()}');
      return false;
    }

    ref.read(updatedPostIdProvider.notifier).set(postId);
    // ref.read(postsListStateProvider.notifier).set(nowToInt());

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }

  Future<bool> blockPost({
    required String postId,
    required bool isAdmin,
  }) async {
    if (isAdmin == false) {
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }
    final postsRepository = ref.read(postsRepositoryProvider);
    state = const AsyncLoading();

    // on WASM, sometimes state changes AsycLoading and not work
    final postNotifier = ref.read(postDataProvider(PostArgs(postId)).notifier);

    final key = this.key;
    final newState =
        await AsyncValue.guard(() => postsRepository.blockPost(postId));
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
      debugPrint('failed blockPost: ${state.error.toString()}');
      return false;
    }

    ref.read(updatedPostIdProvider.notifier).set(postId);
    postNotifier.optimisticBlock();

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }

  Future<bool> unblockPost({
    required String postId,
    required bool isAdmin,
  }) async {
    if (isAdmin == false) {
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }
    final postsRepository = ref.read(postsRepositoryProvider);
    state = const AsyncLoading();

    // on WASM, sometimes state changes AsycLoading and not work
    final postNotifier = ref.read(postDataProvider(PostArgs(postId)).notifier);

    final key = this.key;
    final newState =
        await AsyncValue.guard(() => postsRepository.unblockPost(postId));
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
      debugPrint('failed unblockPost: ${state.error.toString()}');
      return false;
    }

    ref.read(updatedPostIdProvider.notifier).set(postId);
    postNotifier.optimisticUnblock();

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }

  Future<bool> recommendPost({
    required String postId,
    required bool isAdmin,
  }) async {
    if (isAdmin == false) {
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }
    final postsRepository = ref.read(postsRepositoryProvider);
    state = const AsyncLoading();

    // on WASM, sometimes state changes AsycLoading and not work
    final postNotifier = ref.read(postDataProvider(PostArgs(postId)).notifier);

    final key = this.key;
    final newState =
        await AsyncValue.guard(() => postsRepository.recommendPost(postId));
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
      debugPrint('failed recommendPost: ${state.error.toString()}');
      return false;
    }

    ref.read(updatedPostIdProvider.notifier).set(postId);
    postNotifier.optimisticRecommend();

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }

  Future<bool> unrecommendPost({
    required String postId,
    required bool isAdmin,
  }) async {
    if (isAdmin == false) {
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }
    final postsRepository = ref.read(postsRepositoryProvider);
    state = const AsyncLoading();

    // on WASM, sometimes state changes AsycLoading and not work
    final postNotifier = ref.read(postDataProvider(PostArgs(postId)).notifier);

    final key = this.key;
    final newState =
        await AsyncValue.guard(() => postsRepository.unrecommendPost(postId));
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
      debugPrint('failed unrecommendPost: ${state.error.toString()}');
      return false;
    }

    ref.read(updatedPostIdProvider.notifier).set(postId);
    postNotifier.optimisticUnrecommend();

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }

  Future<bool> toMainPost({
    required String postId,
    required bool isAdmin,
  }) async {
    if (isAdmin == false) {
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }
    final postsRepository = ref.read(postsRepositoryProvider);
    state = const AsyncLoading();

    // on WASM, sometimes state changes AsycLoading and not work
    final postNotifier = ref.read(postDataProvider(PostArgs(postId)).notifier);

    final key = this.key;
    final newState =
        await AsyncValue.guard(() => postsRepository.toMainPost(postId));
    if (key == this.key) {
      if (newState.hasError && isFirestoreNotFound(newState.error.toString())) {
        state = AsyncError(PageNotFoundException(), StackTrace.current);
        ref.read(postsListStateProvider.notifier).set(nowToInt());
        return false;
      } else {
        state = newState;
      }
    }

    if (state.hasError) {
      debugPrint('failed toMainPost: ${state.error.toString()}');
      return false;
    }

    ref.read(postsListStateProvider.notifier).set(nowToInt());
    postNotifier.optimisticMain();

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }

  Future<bool> toGeneralPost({
    required String postId,
    required bool isAdmin,
  }) async {
    if (isAdmin == false) {
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }
    final postsRepository = ref.read(postsRepositoryProvider);
    state = const AsyncLoading();

    // on WASM, sometimes state changes AsycLoading and not work
    final postNotifier = ref.read(postDataProvider(PostArgs(postId)).notifier);

    final key = this.key;
    final newState =
        await AsyncValue.guard(() => postsRepository.toGeneralPost(postId));
    if (key == this.key) {
      if (newState.hasError && isFirestoreNotFound(newState.error.toString())) {
        state = AsyncError(PageNotFoundException(), StackTrace.current);
        ref.read(postsListStateProvider.notifier).set(nowToInt());
        return false;
      } else {
        state = newState;
      }
    }

    if (state.hasError) {
      debugPrint('failed toGeneralPost: ${state.error.toString()}');
      return false;
    }

    ref.read(postsListStateProvider.notifier).set(nowToInt());
    postNotifier.optimisticGeneral();

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }

  Future<bool> reportPostIssue({
    required String postId,
    required String postWriterId,
    required int reportType,
    String? custom,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return false;
    }

    final postsRepository = ref.read(postsRepositoryProvider);
    final postReportsRepository = ref.read(postReportsRepositoryProvider);
    final id = '${user.uid}-$postId';
    state = const AsyncLoading();
    try {
      final userReport = await postReportsRepository.fetchPostReport(id);
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
      postsRepository.increaseReportCount(postId);
      postReportsRepository.createPostReport(
        id: id,
        uid: user.uid,
        postId: postId,
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
      debugPrint('reportPostIssueError: ${state.error.toString()}');
      return false;
    }

    return true;
  }
}

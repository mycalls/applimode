// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:applimode_app/src/core/app_states/updated_comment_id.dart';
import 'package:applimode_app/src/core/app_states/list_state.dart';
import 'package:applimode_app/src/core/exceptions/app_exception.dart';

// utils
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/center_circular_indicator.dart';
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';

// features
import 'package:applimode_app/src/features/comments/data/post_comments_repository.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comment_controller.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_item.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_list_state.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_screen_app_bar.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_screen_bottom_bar.dart';

class PostCommentsScreen extends ConsumerWidget {
  const PostCommentsScreen({
    super.key,
    required this.postId,
    this.parentCommentId,
    // this.postWriter,
  });

  final String postId;
  final String? parentCommentId;
  // final AppUser? postWriter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(postCommentControllerProvider, (_, state) {
      if (state.error is NeedPermissionException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.needPermission);
      } else if (state.error is NeedLogInException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.needLogin);
      } else if (state.error is PageNotFoundException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.pageNotFound);
      } else if (state.error is EmptyContentException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.emptyContent);
      } else if (state.error is PostWriterNotFoundException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.postWriterNotFound);
      } else if (state.error is AlreadyReportException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.alreadyReport);
      } else {
        state.showAlertDialogOnError(context, content: state.error.toString());
      }
      // state.showAlertDialogOnError(context);
    });
    final isLoading = ref.watch(postCommentControllerProvider).isLoading;
    final listState = ref.watch(postCommentsListStateControllerProvider);
    final commentsQuery = parentCommentId == null
        ? ref.watch(postCommentsQueryProvider(
            postId: postId,
            byCreatedAt: listState.byCreatedAt,
            byCommentCount: listState.byCommentCount,
            byLikeCount: listState.byLikeCount,
            byDislikeCount: listState.byDislikeCount,
            bySumCount: listState.bySumCount,
          ))
        : ref.watch(postCommentRepliesQueryProvider(parentCommentId!));
    final updatedCommentQuery =
        ref.watch(postCommentsRepositoryProvider).postCommentsRef();

    return Scaffold(
      appBar: PostCommentsScreenAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: SimplePageListView(
                isLiveUpdate: listState.byCreatedAt ? true : false,
                query: commentsQuery,
                listState: commentsListStateProvider,
                isNoGridView: true,
                itemBuilder: (context, index, doc) {
                  final comment = doc.data();
                  return PostCommentsItem(
                    comment: comment,
                    parentCommentId: parentCommentId,
                  );
                },
                refreshUpdatedDoc: true,
                updatedDocQuery: updatedCommentQuery,
                updatedDocState: updatedCommentIdProvider,
                useDidUpdateWidget: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
              ),
            ),
          ),
          PostCommentsScreenBottomBar(
            postId: postId,
            parentCommentId: parentCommentId,
          ),
        ],
      ),
      floatingActionButton: isLoading ? const CenterCircularIndicator() : null,
    );
  }
}

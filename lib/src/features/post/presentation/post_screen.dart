import 'package:applimode_app/src/common_widgets/center_circular_indicator.dart';
import 'package:applimode_app/src/common_widgets/error_widgets/error_message_button.dart';
import 'package:applimode_app/src/exceptions/app_exception.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/post/presentation/post_app_bar.dart';
import 'package:applimode_app/src/features/post/presentation/post_screen_bottom_bar.dart';
import 'package:applimode_app/src/features/post/presentation/post_screen_controller.dart';
import 'package:applimode_app/src/features/posts/data/post_contents_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/domain/post_and_writer.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/adaptive_back.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/string_converter.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/utils/updated_post_ids_list.dart';
import 'package:go_router/go_router.dart';

// Use SliverList to make the AppBar scrollable, maximizing content space.
// Performance issues can occur on the parent page (main list) if content is too long.
// To solve this, if the content is too long, store it in a separate collection and load it when needed.
// Consider the following 3 cases for loading content in PostScreen:
// 1. When the item object is passed from the parent page.
// 2. When the page is refreshed in Flutter Web and the item needs to be fetched again from the DB.
// 3. When the item's content is long and the content data needs to be fetched again from the DB.

// Implements a feature that navigates to the comment section when scrolling to the bottom of the post section and attempting to scroll further.
// Designed to function seamlessly as a single integrated screen through scrolling.

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({
    super.key,
    required this.postId,
    this.postAndWriter,
  });

  final String postId;
  // Because GoRouter's extra property can only pass one object, combine Post and Writer objects into one for passing.
  final PostAndWriter? postAndWriter;

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  // Use AsyncValue to manage state, considering cases where data is received directly from the parent page and cases where data needs to be fetched again from the remote DB.
  AsyncValue<Post?> postAsync = AsyncData(null);
  AsyncValue<AppUser?> writerAsync = AsyncData(null);

  final ScrollController _controller = ScrollController();
  // Activation flag for the "Jump to CommentScreen" feature.
  bool _isRefreshing = false;
  // Additional scroll range required for the pullToCommentScreen functionality.
  final double pushThreshold = -140;

  @override
  void initState() {
    final postAndWriter = widget.postAndWriter;
    super.initState();
    // Distinguish between cases where data is passed from the parent page and cases where it needs to be fetched again.
    postAsync = postAndWriter != null
        ? AsyncData(widget.postAndWriter?.post)
        : const AsyncData(null);
    writerAsync = postAndWriter != null
        ? AsyncData(widget.postAndWriter?.writer)
        : const AsyncData(null);
    _controller.addListener(_scrollListenerCallback);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListenerCallback);
    _controller.dispose();
    super.dispose();
  }

  void _scrollListenerCallback() {
    final position = _controller.position;
    debugPrint('isRefreshing: $_isRefreshing');
    // Calls _handlePushComment when scrolling exceeds a certain threshold.
    if (position.outOfRange &&
        (position.maxScrollExtent - position.pixels) < pushThreshold &&
        !_isRefreshing) {
      _handlePushComment();
    }
    // Reactivates _isRefreshing when returning from the comment section to the post section.
    if (!position.outOfRange && _isRefreshing) {
      // if we should use setState
      _isRefreshing = false;
    }
  }

  void _handlePushComment() {
    if (postAsync.value != null && writerAsync.value != null) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        context
            .push(
          ScreenPaths.comments(postAsync.value!.id),
          extra: writerAsync.value,
        )
            .then((_) {
          if (_isRefreshing) {
            // if we should use setState
            _isRefreshing = false;
          }
        });
      }
    }
  }

  Widget _buildContent(
    BuildContext context,
    Post post,
    double sidePadding,
    List<Widget> itemsList,
  ) {
    return CustomScrollView(
      controller: _controller,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        PostAppBar(
          post: post,
          writerAsync: writerAsync,
        ),
        SliverSafeArea(
          // for iOS
          top: false,
          bottom: false,
          sliver: SliverPadding(
            padding: kIsWeb
                ? EdgeInsets.only(
                    left: sidePadding, right: sidePadding, bottom: 16)
                : const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
            sliver: SliverList.builder(
              // shrinkWrap: true,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              itemCount: itemsList.length,
              itemBuilder: (context, index) {
                return itemsList[index];
              },
              // children: itemsList,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // dev.log('build post screen');
    // loading data
    final isLoading = ref.watch(postScreenControllerProvider).isLoading;

    // Handle state when an error occurs.
    ref.listen(postScreenControllerProvider, (_, state) {
      if (state.error is NeedPermissionException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.needPermission);
      } else if (state.error is PageNotFoundException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.pageNotFound);
        adaptiveBack(context);
      } else if (state.error is AlreadyReportException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.alreadyReport);
      } else {
        state.showAlertDialogOnError(context, content: state.error.toString());
      }
    });

    // If an item is modified in a child screen, update the state to trigger a reload.
    ref.listen(updatedPostIdsListProvider, (_, state) {
      if (state.contains(widget.postId)) {
        //Only reload postAsync, writerAsync will be reloaded automatically based on postAsync
        postAsync = const AsyncData(null);
        // writerAsync = const AsyncData(null);
      }
    });

    // If postAsync is null (web refresh, item changed), reload the document from the remote DB.
    if (postAsync.value == null) {
      postAsync = ref.watch(postFutureProvider(widget.postId));
    }

    // If writerAsync is null (web refresh, item changed), reload the document from remote DB.
    // If postAsync is null, writerAsync cannot be loaded, so handle it as null.
    // writerAsync's value changes depending on the changes of postAsync value.
    if (writerAsync.value == null && postAsync.value != null) {
      writerAsync = ref.watch(writerFutureProvider(postAsync.value!.uid));
    }

    // Track screen width to change the layout for wider screens like desktops or tablets.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final sidePadding = screenWidth > pcWidthBreakpoint
        ? (screenWidth - pcWidthBreakpoint) / 2
        : 16.0;

    return Scaffold(
      body: postAsync.when(
        data: (post) {
          if (post == null) {
            return ErrorMessageButton(
              errorMessage: context.loc.pageNotFound,
            );
          }

          // content is too long so load another collection
          if (post.isLongContent) {
            final postContentAsync =
                ref.watch(postContentFutureProvider(widget.postId));
            return postContentAsync.when(
              data: (postContent) {
                final itemsList = StringConverter.stringToElements(
                  content: postContent?.content ?? '',
                  postId: widget.postId,
                );
                // LazyLoadingWidget
                // loadingWidget: const Center(child: CupertinoActivityIndicator(),),
                return _buildContent(context, post, sidePadding, itemsList);
              },
              error: (error, stackTrace) => Center(
                child: Text(context.loc.tryLater),
              ),
              loading: () => const Center(child: CupertinoActivityIndicator()),
            );
          }
          final itemsList = StringConverter.stringToElements(
            content: post.content,
            postId: widget.postId,
          );
          return _buildContent(context, post, sidePadding, itemsList);
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(child: CupertinoActivityIndicator()),
      ),
      floatingActionButton: isLoading ? const CenterCircularIndicator() : null,
      bottomNavigationBar: postAsync.when(
        data: (post) {
          if (post == null) {
            return const SizedBox.shrink();
          }
          return PostScreenBottomBar(
            post: post,
            postWriter: writerAsync.value,
          );
        },
        error: (error, stackTrace) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
      ),
    );
  }
}

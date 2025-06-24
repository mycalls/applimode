import 'dart:developer' as dev;

// flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/exceptions/app_exception.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/adaptive_back.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/string_converter.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/center_circular_indicator.dart';
import 'package:applimode_app/src/common_widgets/error_widgets/error_message_button.dart';

// features
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/data/post_contents_repository.dart';
import 'package:applimode_app/src/features/posts/application/providers/post_data_provider.dart';
import 'package:applimode_app/src/features/posts/presentation/post_screen/post_app_bar.dart';
import 'package:applimode_app/src/features/posts/presentation/post_screen/post_screen_bottom_bar.dart';
import 'package:applimode_app/src/features/posts/presentation/post_screen/post_screen_controller.dart';

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
    this.post,
  });

  final String postId;
  // Because GoRouter's extra property can only pass one object, combine Post and Writer objects into one for passing.
  final Post? post;

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  // Use AsyncValue to manage state, considering cases where data is received directly from the parent page and cases where data needs to be fetched again from the remote DB.

  final ScrollController _controller = ScrollController();
  // Activation flag for the "Jump to CommentScreen" feature.
  bool _isRefreshing = false;
  // Additional scroll range required for the pullToCommentScreen functionality.
  final double _pushThreshold = -140;

  @override
  void initState() {
    super.initState();
    // Distinguish between cases where data is passed from the parent page and cases where it needs to be fetched again.
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
        (position.maxScrollExtent - position.pixels) < _pushThreshold &&
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
    final currentPost =
        ref.read(postDataProvider(PostArgs(widget.postId))).value;
    if (currentPost != null) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        context
            .push(
          ScreenPaths.comments(currentPost.id),
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

    // Track screen width to change the layout for wider screens like desktops or tablets.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final sidePadding = screenWidth > pcWidthBreakpoint
        ? (screenWidth - pcWidthBreakpoint) / 2
        : 16.0;

    final postAsync =
        ref.watch(postDataProvider(PostArgs(widget.postId, widget.post)));

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
            dev.log('${post.id} isLongContent: ${post.isLongContent}');
            final postContentAsync =
                ref.watch(postContentFutureProvider(widget.postId));
            return postContentAsync.when(
              data: (postContent) {
                final itemsList = StringConverter.stringToElements(
                  content: postContent?.content ?? '',
                  postId: widget.postId,
                );
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
          );
        },
        error: (error, stackTrace) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
      ),
    );
  }
}

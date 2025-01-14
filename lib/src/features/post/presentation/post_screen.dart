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

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({
    super.key,
    required this.postId,
    this.postAndWriter,
  });

  final String postId;
  final PostAndWriter? postAndWriter;

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  AsyncValue<Post?> postAsync = AsyncData(null);
  AsyncValue<AppUser?> writerAsync = AsyncData(null);

  @override
  void initState() {
    final postAndWriter = widget.postAndWriter;
    super.initState();
    postAsync = postAndWriter != null
        ? AsyncData(widget.postAndWriter?.post)
        : const AsyncData(null);
    writerAsync = postAndWriter != null
        ? AsyncData(widget.postAndWriter?.writer)
        : const AsyncData(null);
  }

  @override
  Widget build(BuildContext context) {
    // dev.log('build post screen');
    final isLoading = ref.watch(postScreenControllerProvider).isLoading;

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

    ref.listen(updatedPostIdsListProvider, (_, state) {
      if (state.contains(widget.postId)) {
        postAsync = const AsyncData(null);
        // writerAsync = const AsyncData(null);
      }
    });

    if (postAsync.value == null) {
      postAsync = ref.watch(postFutureProvider(widget.postId));
    }

    if (writerAsync.value == null) {
      writerAsync = postAsync.value == null
          ? const AsyncData(null)
          : ref.watch(writerFutureProvider(postAsync.value!.uid));
    }

    /*
    final postAsync = widget.postAndWriter != null
        ? AsyncData(widget.postAndWriter!.post)
        : ref.watch(postFutureProvider(widget.postId));
    final writerAsync = widget.postAndWriter != null
        ? AsyncData(widget.postAndWriter!.writer)
        : postAsync.value == null
            ? const AsyncData(null)
            : ref.watch(writerFutureProvider(postAsync.value!.uid));
            */

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
                return CustomScrollView(
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
                                left: sidePadding,
                                right: sidePadding,
                                bottom: 16)
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
                          //children: itemsList,
                        ),
                      ),
                    ),
                  ],
                );
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
          return CustomScrollView(
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
                    /*
                    padding: kIsWeb
                        ? EdgeInsets.only(
                            left: sidePadding, right: sidePadding, bottom: 16)
                        : const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          */
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
            return SizedBox.shrink();
          }
          return PostScreenBottomBar(
            post: post,
            postWriter: writerAsync.value,
          );
        },
        error: (error, stackTrace) => SizedBox.shrink(),
        loading: () => SizedBox.shrink(),
      ),
    );
  }
}

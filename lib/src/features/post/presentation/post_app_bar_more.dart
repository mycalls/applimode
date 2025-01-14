import 'dart:developer' as dev;

import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/utils/show_message_snack_bar.dart';
import 'package:applimode_app/src/utils/show_report_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/post/presentation/post_screen_controller.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/domain/post_and_writer.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

class PostAppBarMore extends ConsumerWidget {
  const PostAppBarMore({
    super.key,
    required this.post,
    required this.writerAsync,
  });

  final Post post;
  final AsyncValue<AppUser?> writerAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final postId = post.id;
    final appUser = user != null
        ? ref.watch(appUserFutureProvider(user.uid))
        : const AsyncData(null);
    final postAndWriter = PostAndWriter(post: post, writer: writerAsync.value!);
    final useRecommendation =
        ref.watch(adminSettingsProvider).useRecommendation;
    return AsyncValueWidget(
      value: appUser,
      data: (appUser) {
        return PopupMenuButton(
          tooltip: 'Edit or delete post',
          position: PopupMenuPosition.under,
          itemBuilder: (context) {
            return [
              if ((user != null && user.uid == writerAsync.value?.uid) ||
                  (appUser != null && appUser.isAdmin))
                PopupMenuItem(
                  onTap: () {
                    context.push(
                      ScreenPaths.edit(postId),
                      extra: postAndWriter,
                    );
                  },
                  child: Text(context.loc.editPost),
                ),
              if (appUser != null && appUser.isAdmin == true) ...[
                if (useRecommendation)
                  PopupMenuItem(
                    onTap: () async {
                      final result = post.isRecommended
                          ? await ref
                              .read(postScreenControllerProvider.notifier)
                              .unrecommendPost(
                                postId: postId,
                                isAdmin: appUser.isAdmin,
                              )
                          : await ref
                              .read(postScreenControllerProvider.notifier)
                              .recommendPost(
                                postId: postId,
                                isAdmin: appUser.isAdmin,
                              );
                      if (context.mounted && result) {
                        if (kIsWeb) {
                          WebBackStub().back();
                        } else {
                          if (context.canPop()) {
                            context.pop();
                          }
                        }
                      }
                    },
                    child: Text(
                      post.isRecommended
                          ? context.loc.unrecommendPost
                          : context.loc.recommendPost,
                    ),
                  ),
                PopupMenuItem(
                  onTap: () async {
                    final result = post.isHeader
                        ? await ref
                            .read(postScreenControllerProvider.notifier)
                            .toGeneralPost(
                              postId: postId,
                              isAdmin: appUser.isAdmin,
                            )
                        : await ref
                            .read(postScreenControllerProvider.notifier)
                            .toMainPost(
                              postId: postId,
                              isAdmin: appUser.isAdmin,
                            );
                    if (context.mounted && result) {
                      if (kIsWeb) {
                        WebBackStub().back();
                      } else {
                        if (context.canPop()) {
                          context.pop();
                        }
                      }
                    }
                  },
                  child: Text(
                    post.isHeader
                        ? context.loc.specifyGeneralPost
                        : context.loc.specifyMainPost,
                  ),
                ),
                PopupMenuItem(
                  onTap: () async {
                    final result = post.isBlock
                        ? await ref
                            .read(postScreenControllerProvider.notifier)
                            .unblockPost(
                              postId: postId,
                              isAdmin: appUser.isAdmin,
                            )
                        : await ref
                            .read(postScreenControllerProvider.notifier)
                            .blockPost(
                              postId: postId,
                              isAdmin: appUser.isAdmin,
                            );
                    if (context.mounted && result) {
                      if (kIsWeb) {
                        WebBackStub().back();
                      } else {
                        if (context.canPop()) {
                          context.pop();
                        }
                      }
                    }
                  },
                  child: Text(
                    post.isBlock
                        ? context.loc.unblockPost
                        : context.loc.blockPost,
                  ),
                ),
              ],
              if (user != null && user.uid != writerAsync.value?.uid)
                PopupMenuItem(
                  onTap: () async {
                    final report = await showReportDialog(context: context);
                    dev.log('report: $report');
                    if (report is IssueReport) {
                      final result = await ref
                          .read(postScreenControllerProvider.notifier)
                          .reportPostIssue(
                            postId: postId,
                            postWriterId: post.uid,
                            reportType: report.reportType,
                            custom: report.message,
                          );
                      if (context.mounted) {
                        if (result) {
                          showMessageSnackBar(
                              context, context.loc.reportProcessed);
                        }
                      }
                    }
                  },
                  child: Text(context.loc.report),
                ),
              if ((user != null && user.uid == writerAsync.value?.uid) ||
                  (appUser != null && appUser.isAdmin == true))
                PopupMenuItem(
                  onTap: () async {
                    final result = await ref
                        .read(postScreenControllerProvider.notifier)
                        .deletePost(
                          postId: postId,
                          post: post,
                          isAdmin: appUser?.isAdmin ?? false,
                        );
                    if (context.mounted && result) {
                      if (kIsWeb) {
                        WebBackStub().back();
                      } else {
                        if (context.canPop()) {
                          context.pop();
                        }
                      }
                    }
                  },
                  child: Text(context.loc.deletePost),
                ),
            ];
          },
        );
      },
    );
  }
}

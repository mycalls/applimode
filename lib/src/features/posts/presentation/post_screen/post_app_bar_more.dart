import 'dart:developer' as dev;

// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/show_message_snack_bar.dart';
import 'package:applimode_app/src/utils/show_report_dialog.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/async_value_widget.dart';

// features
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/post_screen/post_screen_controller.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';

class PostAppBarMore extends ConsumerWidget {
  const PostAppBarMore({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final writerAsyc = ref.watch(appUserDataProvider(post.uid));
    final appUserAsync = user == null
        ? AsyncData(null)
        : ref.watch(appUserDataProvider(user.uid));
    final postId = post.id;

    final useRecommendation =
        ref.watch(adminSettingsProvider).useRecommendation;

    return AsyncValueWidget(
      value: appUserAsync,
      data: (appUser) {
        if (appUser == null) {
          return const SizedBox.shrink();
        }
        return AsyncValueWidget(
          value: writerAsyc,
          data: (writer) {
            return PopupMenuButton(
              tooltip: 'Edit or delete post',
              position: PopupMenuPosition.under,
              itemBuilder: (context) {
                final isWriter = writer != null && writer.uid == appUser.uid;
                final isAdminOrWriter = appUser.isAdmin || isWriter;

                return [
                  if (isAdminOrWriter)
                    PopupMenuItem(
                      onTap: () {
                        context.push(
                          ScreenPaths.edit(postId),
                          extra: post,
                        );
                      },
                      child: Text(context.loc.editPost),
                    ),
                  if (appUser.isAdmin) ...[
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
                  if (appUser.uid != writer?.uid)
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
                  if (isAdminOrWriter)
                    PopupMenuItem(
                      onTap: () async {
                        final result = await ref
                            .read(postScreenControllerProvider.notifier)
                            .deletePost(
                              postId: postId,
                              post: post,
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
                      child: Text(context.loc.deletePost),
                    ),
                ];
              },
            );
          },
        );
      },
    );
  }
}

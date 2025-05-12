import 'package:applimode_app/src/common_widgets/title_text_widget.dart';
import 'package:applimode_app/src/features/authentication/application/app_user_data_provider.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SmallBlockItem extends ConsumerWidget {
  const SmallBlockItem({
    super.key,
    this.postId,
    this.post,
  });

  final String? postId;
  final Post? post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final appUser =
        user != null ? ref.watch(appUserDataProvider(user.uid)).value : null;
    final titleTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: smallPostsItemTitleSize,
        );

    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth > pcWidthBreakpoint
        ? ((screenWidth - pcWidthBreakpoint) / 2) + defaultHorizontalPadding
        : defaultHorizontalPadding;

    return InkWell(
      onTap:
          (appUser != null && appUser.isAdmin && postId != null && post != null)
              ? () => context.push(
                    ScreenPaths.post(postId!),
                    extra: post,
                  )
              : null,
      child: Column(
        children: [
          SizedBox(
            height: listSmallItemHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: TitleTextWidget(
                        title: context.loc.blockedPost,
                        textStyle: titleTextStyle,
                        maxLines: smallPostsItemTitleMaxLines,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            height: 0,
            thickness: 0,
            indent: horizontalPadding,
            endIndent: horizontalPadding,
          ),
        ],
      ),
    );
  }
}

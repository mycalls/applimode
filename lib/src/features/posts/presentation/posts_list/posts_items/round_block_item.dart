import 'package:applimode_app/src/common_widgets/gradient_color_box.dart';
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

class RoundBlockItem extends ConsumerWidget {
  const RoundBlockItem({
    super.key,
    this.aspectRatio,
    this.isPage = false,
    this.index,
    this.postId,
    this.post,
    this.needTopMargin = false,
    this.needBottomMargin = true,
  });

  final double? aspectRatio;
  final bool isPage;
  final int? index;
  final String? postId;
  final Post? post;
  final bool needTopMargin;
  final bool needBottomMargin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final appUser =
        user != null ? ref.watch(appUserDataProvider(user.uid)).value : null;
    final postTitleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontSize: roundPostsItemTitleFontsize,
        );
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalMargin = screenWidth > pcWidthBreakpoint
        ? ((screenWidth - pcWidthBreakpoint) / 2) + roundCardPadding
        : roundCardPadding;

    return InkWell(
      onTap:
          (appUser != null && appUser.isAdmin && postId != null && post != null)
              ? () => context.push(
                    ScreenPaths.post(postId!),
                    extra: post,
                  )
              : null,
      child: Container(
        margin: EdgeInsets.only(
          left: horizontalMargin,
          right: horizontalMargin,
          top: needTopMargin ? roundCardPadding : 0,
          bottom: needBottomMargin ? roundCardPadding : 0,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: AspectRatio(
          aspectRatio: aspectRatio ?? 16 / 9,
          child: GradientColorBox(
            index: index,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: TitleTextWidget(
                title: context.loc.blockedPost,
                textStyle: postTitleStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

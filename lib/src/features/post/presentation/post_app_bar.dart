import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/user_items/writer_item.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/post/presentation/post_app_bar_more.dart';
import 'package:applimode_app/src/features/post/presentation/post_screen_controller.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const PostAppBar({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Size get preferredSize => const Size.fromHeight(postScreenAppBarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      floating: true,
      centerTitle: false,
      toolbarHeight: postScreenAppBarHeight,
      automaticallyImplyLeading: kIsWeb ? false : true,
      leading: kIsWeb ? const WebBackButton() : null,
      title: WriterItem(
        isAppBar: true,
        writerId: post.uid,
        post: post,
        showSubtitle: true,
        profileImagesize: profileSizeBig,
        nameColor: Theme.of(context).colorScheme.primary,
        onTap: () => context.push(
          ScreenPaths.profile(post.uid),
        ),
      ),
      actions: [
        Consumer(
          builder: (context, ref, child) {
            final user = ref.watch(authStateChangesProvider).value;
            final isLoading = ref.watch(postScreenControllerProvider).isLoading;
            return user != null
                ? IgnorePointer(
                    ignoring: isLoading,
                    child: PostAppBarMore(
                      post: post,
                    ),
                  )
                : const SizedBox.shrink();
          },
        )
      ],
    );
  }
}

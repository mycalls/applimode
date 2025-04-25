import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/common_widgets/user_items/writer_item.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
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
    required this.writerAsync,
  });

  final Post post;
  final AsyncValue<AppUser?> writerAsync;

  @override
  Size get preferredSize => const Size.fromHeight(postScreenAppBarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;

    return SliverAppBar(
      floating: true,
      centerTitle: false,
      toolbarHeight: postScreenAppBarHeight,
      automaticallyImplyLeading: kIsWeb ? false : true,
      leading: kIsWeb ? const WebBackButton() : null,
      title: AsyncValueWidget(
        value: writerAsync,
        data: (writer) {
          return writer == null
              ? const SizedBox.shrink()
              : Consumer(
                  builder: (context, ref, child) {
                    final appUser = user != null
                        ? ref.watch(appUserStreamProvider(user.uid)).value
                        : null;
                    final isAppUser =
                        appUser != null && writer.uid == appUser.uid;
                    return WriterItem(
                      isAppBar: true,
                      writer: isAppUser ? appUser : writer,
                      post: post,
                      showSubtitle: true,
                      profileImagesize: profileSizeBig,
                      nameColor: Theme.of(context).colorScheme.primary,
                      onTap: () => context.push(
                        ScreenPaths.profile(writer.uid),
                      ),
                    );
                  },
                );
        },
      ),
      actions: [
        if (writerAsync.value != null && user != null)
          Consumer(
            builder: (context, ref, child) {
              final isLoading =
                  ref.watch(postScreenControllerProvider).isLoading;
              return IgnorePointer(
                ignoring: isLoading,
                child: PostAppBarMore(
                  post: post,
                  writerAsync: writerAsync,
                ),
              );
            },
          ),
      ],
    );
  }
}

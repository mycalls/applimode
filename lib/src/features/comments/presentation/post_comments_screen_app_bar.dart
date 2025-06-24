// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:applimode_app/custom_settings.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/buttons/web_back_button.dart';

// features
import 'package:applimode_app/src/features/comments/presentation/post_comments_list_state.dart';

class PostCommentsScreenAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const PostCommentsScreenAppBar({super.key, this.isRepliesScreen = false});

  final bool isRepliesScreen;

  @override
  Size get preferredSize => const Size.fromHeight(commentScreenAppBarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(postCommentsListStateControllerProvider);
    final listStateController =
        ref.watch(postCommentsListStateControllerProvider.notifier);

    return AppBar(
      toolbarHeight: commentScreenAppBarHeight,
      title: Text(isRepliesScreen
          ? context.loc.replies
          : context.loc.commentsAppBarTitle),
      automaticallyImplyLeading: kIsWeb ? false : true,
      leading: kIsWeb ? const WebBackButton() : null,
      actions: isRepliesScreen
          ? null
          : [
              MenuAnchor(
                style: const MenuStyle(
                    padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 24))),
                builder: (context, controller, child) => TextButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      FocusScope.of(context).unfocus();
                      controller.open();
                    }
                  },
                  child: Text(getMenuAnchorString(context, listState)),
                ),
                menuChildren: [
                  MenuItemButton(
                    onPressed: () {
                      listStateController.byCreatedAt();
                    },
                    child: Text(context.loc.byCreatedAt),
                  ),
                  MenuItemButton(
                    onPressed: () {
                      listStateController.bySumCount();
                    },
                    child: Text(context.loc.bySumCount),
                  ),
                ],
              ),
            ],
    );
  }

  String getMenuAnchorString(
      BuildContext context, PostCommentsListState state) {
    if (state.byCreatedAt) {
      return context.loc.byCreatedAt;
    }
    if (state.byCommentCount) {
      return context.loc.byCommentCount;
    }
    if (state.byLikeCount) {
      return context.loc.byLikeCount;
    }
    if (state.byDislikeCount) {
      return context.loc.byDislikeCount;
    }
    if (state.bySumCount) {
      return context.loc.bySumCount;
    }
    return context.loc.byCreatedAt;
  }
}

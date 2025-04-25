import 'package:applimode_app/src/common_widgets/title_text_widget.dart';
import 'package:applimode_app/src/common_widgets/user_items/writer_item.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/domain/post_and_writer.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/get_max_width.dart';
import 'package:applimode_app/src/utils/string_converter.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class VideoContents extends ConsumerWidget {
  const VideoContents({
    super.key,
    required this.controller,
    required this.post,
    required this.writer,
    this.index,
    this.isPage = false,
    this.showVideoTitle = true,
  });

  final VideoPlayerController controller;
  final Post post;
  final AppUser writer;
  final int? index;
  final bool isPage;
  final bool showVideoTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminSettings = ref.watch(adminSettingsProvider);
    final postTitleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontSize: basicPostsItemTitleFontsize,
        );
    final maxWidth =
        getMaxWidth(context, postsListType: adminSettings.postsListType);
    return Positioned(
      bottom: 24,
      left: 16,
      child: SafeArea(
        top: false,
        bottom: isPage ? true : false,
        left: isPage ? true : false,
        right: isPage ? true : false,
        child: InkWell(
          onTap: () {
            controller.pause();
            context.push(
              ScreenPaths.post(post.id),
              extra: PostAndWriter(
                post: post,
                writer: writer,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WriterItem(
                writer: writer,
                post: post,
                width: maxWidth,
                profileImagesize: basicPostsItemProfileSize,
                nameColor: Colors.white,
                showSubtitle: true,
                captionColor: Colors.white,
                countColor: Colors.white,
                index: index,
                categoryColor: Colors.white,
                nameSize: basicPostsItemNameSize,
                subInfoFontSize: basicPostsItemSubInfoSize,
                subInfoIconSize: basicPostsItemSubInfoSize + 2,
                writerLabelFontSize: basicPostsItemNameSize - 6,
              ),
              if (showVideoTitle) ...[
                const SizedBox(height: 12),
                if (StringConverter.toTitle(post.content).isNotEmpty)
                  SizedBox(
                    width: maxWidth,
                    child: TitleTextWidget(
                      title: post.title,
                      textStyle: postTitleStyle,
                      maxLines: basicPostsItemVideoTitleMaxLines,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

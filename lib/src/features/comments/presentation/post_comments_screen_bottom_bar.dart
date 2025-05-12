import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_image.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comment_controller.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/show_adaptive_alert_dialog.dart';
import 'package:applimode_app/src/utils/show_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class PostCommentsScreenBottomBar extends ConsumerStatefulWidget {
  const PostCommentsScreenBottomBar({
    super.key,
    required this.postId,
    this.parentCommentId,
  });

  final String postId;
  final String? parentCommentId;

  @override
  ConsumerState<PostCommentsScreenBottomBar> createState() =>
      _PostCommentsScreenBottomBarState();
}

class _PostCommentsScreenBottomBarState
    extends ConsumerState<PostCommentsScreenBottomBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  XFile? _pickedFile;
  String? _mediaType;

  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _isCancelled = true;
    super.dispose();
  }

  void _safeSetState([VoidCallback? callback]) {
    if (_isCancelled) return;
    if (mounted) {
      safeBuildCall(() => setState(() {
            callback?.call();
          }));
    }
  }

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty && _pickedFile == null) {
      showAdaptiveAlertDialog(
        context: context,
        title: context.loc.ooops,
        content: context.loc.emptyContent,
      );
      return;
    }
    final success =
        await ref.read(postCommentControllerProvider.notifier).leaveComment(
              postId: widget.postId,
              parentCommentId: widget.parentCommentId,
              isReply: widget.parentCommentId != null,
              content: _controller.text,
              xFile: _pickedFile,
              mediaType: _mediaType,
              commentNotiString: context.loc.commentNoti,
              replyNotiString: context.loc.replyNoti,
            );
    if (success == true) {
      _controller.clear();
      _safeSetState(() => _pickedFile = null);
      /*
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
      */
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaMaxMBSize = ref.watch(adminSettingsProvider).mediaMaxMBSize;
    final user = ref.watch(authStateChangesProvider).value;
    final isLoading = ref.watch(postCommentControllerProvider).isLoading;
    final isIosWeb = kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    return InkWell(
      /// If the user is not signed in, go to the sign in screen
      /// 로그인하지 않았을 경우 로그인창으로
      onTap:
          user == null ? () => context.push(ScreenPaths.firebaseSignIn) : () {},
      child: IgnorePointer(
        ignoring: user == null || isLoading,
        child: Container(
          padding: EdgeInsets.only(
            top: 12,
            left: 16,
            right: 16,
            bottom: isIosWeb ? iosWebBottomSafeArea : 12,
          ),
          color: Theme.of(context).colorScheme.onInverseSurface,
          child: SafeArea(
            child: Row(
              children: [
                if (_pickedFile != null)
                  Expanded(
                    child: Row(
                      children: [
                        FlatformImage(
                          xFile: _pickedFile!,
                          height: 96,
                        ),
                        IconButton(
                          onPressed: () {
                            _safeSetState(() => _pickedFile = null);
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_pickedFile == null)
                  IconButton(
                    onPressed: () async {
                      _pickedFile = await showImagePicker(
                        isImage: true,
                        mediaMaxMBSize: mediaMaxMBSize,
                      );
                      if (_pickedFile != null) {
                        _mediaType = _pickedFile!.mimeType;

                        if (_mediaType == null) {
                          final fileExt =
                              _pickedFile!.name.split('.').last.toLowerCase();
                          if (imageExts.contains(fileExt)) {
                            _mediaType = Format.extToMimeType(fileExt);
                          } else {
                            debugPrint('ext is unsupported mediaType');
                            return;
                          }
                        } else {
                          if (!imageContentTypes.contains(_mediaType)) {
                            debugPrint('unsupported mediaType');
                            return;
                          }
                        }
                      }
                      _safeSetState();
                    },
                    icon: const Icon(Icons.image_outlined),
                  ),
                if (_pickedFile == null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          hintText: context.loc.leaveComment,
                          // hintStyle: TextStyle(color: Colors.grey.shade400),
                        ),
                        onEditingComplete: _submit,
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: _submit,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

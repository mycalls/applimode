import 'dart:async';
import 'dart:developer' as dev;

import 'package:applimode_app/src/exceptions/app_exception.dart';
import 'package:applimode_app/src/features/editor/presentation/editor_screen_ai_controller.dart';
import 'package:applimode_app/src/features/prompts/show_ai_dialog.dart';
import 'package:applimode_app/src/utils/adaptive_back.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';
import 'package:applimode_app/src/utils/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/percent_circular_indicator.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/editor/presentation/editor_bottom_bar.dart';
import 'package:applimode_app/src/features/editor/presentation/editor_field.dart';
import 'package:applimode_app/src/features/editor/presentation/editor_screen_controller.dart';
import 'package:applimode_app/src/features/editor/presentation/markdown_field.dart';
import 'package:applimode_app/src/features/posts/data/post_contents_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post_and_writer.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/build_remote_media.dart';
import 'package:applimode_app/src/utils/show_adaptive_alert_dialog.dart';
import 'package:applimode_app/src/utils/show_image_picker.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:applimode_app/src/utils/upload_progress_state.dart';

// tabBar comp
class TabTitle {
  const TabTitle({
    this.icon,
    this.title,
  });

  final Icon? icon;
  final String? title;
}

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({
    super.key,
    this.postId,
    this.postAndWriter,
  });

  final String? postId;
  final PostAndWriter? postAndWriter;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int currentCategory = 0;
  // when post content is very long
  bool hasPostContent = false;
  List<String>? _remoteMedia;

  static const bottomBarHeight = 80.0;

  // for auto save when writing a new post
  Timer? _debounceSaveTempTimer;

  bool _isCancelled = false;

  @override
  void initState() {
    if (widget.postId != null) {
      // when editing a existing post
      if (widget.postAndWriter != null) {
        // when postAndWriter is not null
        // postAndWriter가 null이 아닐 경우
        if (widget.postAndWriter!.post.isLongContent) {
          // when post content is very long
          // 포스트의 컨테츠 길이가 긴 경우
          // If the post content length is too long, it is saved separately due to performance issues.
          // 성능 문제로 인해 포스트의 컨텐츠 길이가 너무 길 경우 따로 저장했음
          _buildLongContent();
        } else {
          // normal content
          // 일반적인 컨텐츠의 경우
          _controller.text = widget.postAndWriter?.post.content ?? '';
          currentCategory = widget.postAndWriter?.post.category ?? 0;
          _remoteMedia = buildRemoteMedia(_controller.text);
        }
      } else {
        // postAndWriter is null
        // postAndWriter가 null일 경우
        // When refreshing the page in a web browser or accessing the link directly, postAndWriter becomes null.
        // 웹브라우저에서 페이지 세로고침을 하거나 해당 링크로 바로 접근시 postAndWriter는 null이 됨.
        _buildCurrentPost();
      }
    } else {
      // when writing a new post
      final tempNewPost = ref
          .read(prefsWithCacheProvider)
          .requireValue
          .getString('tempNewPost');
      if (tempNewPost != null && tempNewPost.trim().isNotEmpty) {
        _controller.text = tempNewPost;
      }
      _controller.addListener(_saveTemp);
    }
    super.initState();
  }

  @override
  void dispose() {
    _isCancelled = true;
    _debounceSaveTempTimer?.cancel();
    if (widget.postId == null) {
      _controller.removeListener(_saveTemp);
    }
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _debounceSaveTemp(VoidCallback callback) {
    _debounceSaveTempTimer?.cancel();
    _debounceSaveTempTimer = Timer(Duration(milliseconds: 1000), callback);
  }

  void _saveTemp() {
    _debounceSaveTemp(() {
      try {
        final sharedPreferences = ref.read(prefsWithCacheProvider).requireValue;
        // because the files selected in the image picker are temporarily saved
        final onlyText = _controller.text
            .replaceAll(Regex.localImageRegex, '')
            .replaceAll(Regex.localVideoRegex, '');
        sharedPreferences.setString('tempNewPost', onlyText);
      } catch (e) {
        debugPrint('failed _debounceSaveTemp');
      }
    });
  }

  Future<void> _buildLongContent() async {
    try {
      hasPostContent = true;
      final postContent =
          await ref.read(postContentFutureProvider(widget.postId!).future);
      _controller.text = postContent?.content ?? '';
      currentCategory = postContent?.category ?? 0;
      if (_isCancelled) return;
      if (mounted) {
        safeBuildCall(() => setState(() {}));
      }
      _remoteMedia = buildRemoteMedia(_controller.text);
    } catch (e) {
      debugPrint('failed _buildLongContent: ${e.toString()}');
    }
  }

  Future<void> _buildCurrentPost() async {
    try {
      final currentPost =
          await ref.read(postFutureProvider(widget.postId!).future);
      if (currentPost != null && currentPost.isLongContent) {
        _buildLongContent();
      } else {
        _controller.text = currentPost?.content ?? '';
        currentCategory = currentPost?.category ?? 0;
        if (_isCancelled) return;
        if (mounted) {
          safeBuildCall(() => setState(() {}));
        }
        _remoteMedia = buildRemoteMedia(_controller.text);
      }
    } catch (e) {
      debugPrint('failed _buildCurrentPost: ${e.toString()}');
    }
  }

  String _buildAppBarTitle(BuildContext context) => widget.postId == null
      ? context.loc.writeAppBarTitle
      : context.loc.editAppBarTitle;

  List<TabTitle> _buildTabTitles(BuildContext context) {
    return [
      TabTitle(title: context.loc.editor),
      TabTitle(title: context.loc.preview),
    ];
  }

  Future<void> _getMedia(double mediaMaxMBSize) async {
    final text = _controller.text;
    final selection = _controller.selection;
    final start = selection.start;
    final end = selection.end;

    bool isVideo = false;

    final isThumbnail = start > 1 &&
        end + 1 < text.length &&
        text[start - 1] == r'[' &&
        text[start - 2] == r']' &&
        text[end] == r']' &&
        text[end + 1] == r'[';

    final XFile? pickedFile = await showImagePicker(
      isImage: isThumbnail,
      mediaMaxMBSize: mediaMaxMBSize,
    ).catchError((error) {
      debugPrint('showImagePicker: ${error.toString()}');
      if (mounted) {
        showAdaptiveAlertDialog(
            context: context,
            title: context.loc.maxFileSizeErrorTitle,
            content:
                '${context.loc.maxFileSizedErrorContent} (${mediaMaxMBSize}MB)');
      }
      return null;
    });

    if (pickedFile != null) {
      try {
        // This can only be confirmed when checking the file directly imported from the image picker.
        String? mediaType = pickedFile.mimeType;
        dev.log('media type from picker: $mediaType');

        if (mediaType == null) {
          // If pickedFile's mediaType is null
          // get the mediaType from pickedFile's ext
          final fileExt = pickedFile.name.split('.').last.toLowerCase();
          dev.log('pickedFile\'s ext: $fileExt');
          dev.log('is this video: ${videoExts.contains(fileExt)}');
          if (videoExts.contains(fileExt)) {
            // video file
            mediaType = Format.extToMimeType(fileExt);
            isVideo = true;
          } else if (imageExts.contains(fileExt)) {
            // image file
            mediaType = Format.extToMimeType(fileExt);
            isVideo = false;
          } else {
            // Cancel getMedia if media type is incompatible
            debugPrint('ext is unsupported mediaType');
            return;
          }
        } else {
          // If pickedFile's mediaType is not null
          if (imageContentTypes.contains(mediaType)) {
            // video file
            isVideo = false;
          } else if (videoConetntTypes.contains(mediaType)) {
            // image file
            isVideo = true;
          } else {
            // Cancel getMedia if media type is incompatible
            debugPrint('mediaType is unsupported mediaType');
            return;
          }
        }

        // Add a question mark to the end of filePath and add a media type
        final filePath =
            '${pickedFile.path}?${Format.mimeTypeToExt(mediaType)}';

        final inserted = isThumbnail
            ? filePath
            : isVideo
                ? '\n[localVideo][][$filePath]\n'
                : '\n[localImage][$filePath][]\n';

        final newText = text.replaceRange(
          start,
          end,
          inserted,
        );

        final newSelection = TextSelection.collapsed(
            offset: selection.baseOffset + inserted.length);

        if (_isCancelled) return;
        if (mounted) {
          safeBuildCall(() {
            setState(() {
              _controller.value = TextEditingValue(
                text: newText,
                selection: newSelection,
              );
            });
          });
        }

        _focusNode.requestFocus();
      } catch (e) {
        debugPrint('failed _getMedia: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(editorScreenControllerProvider, (_, state) {
      if (state.error is NeedLogInException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.needLogin);
        adaptiveBack(context);
      } else if (state.error is NeedPermissionException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.needPermission);
        adaptiveBack(context);
      } else if (state.error is FailedMediaFileException) {
        state.showAlertDialogOnError(context,
            content: context.loc.failedMediaFile);
      } else if (state.error is FailedMediaFileUploadException) {
        state.showAlertDialogOnError(context,
            content: context.loc.failedUploadMediaFile);
      } else if (state.error is FailedPostSubmitException) {
        state.showAlertDialogOnError(context,
            content: context.loc.failedPostSubmit);
      } else {
        state.showAlertDialogOnError(context, content: state.error.toString());
      }
    });

    if (useAiAssistant) {
      ref.listen(editorScreenAiControllerProvider, (_, state) {
        state.showAlertDialogOnError(context, content: state.error.toString());
      });
    }

    final isLoading = ref.watch(editorScreenControllerProvider).isLoading;
    final uploadState = ref.watch(uploadProgressStateProvider);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final tabTitles = _buildTabTitles(context);

    return DefaultTabController(
      length: tabTitles.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: kIsWeb ? false : true,
          leading: kIsWeb ? const WebBackButton() : null,
          title: Text(_buildAppBarTitle(context)),
          actions: [
            if (useAiAssistant)
              InkWell(
                onTap: () async {
                  // when using ai assistant, upload images together
                  final imageMatchs =
                      Regex.localImageRegex.allMatches(_controller.text);
                  final List<String> imagePaths = [];
                  for (final match in imageMatchs) {
                    if (match[1] != null) {
                      imagePaths.add(match[1]!);
                    }
                  }

                  // debugPrint('imagePaths: $imagePaths');
                  final result = await showAiDialog(
                    context: context,
                    imagePaths: imagePaths.isNotEmpty ? imagePaths : null,
                    contentString: _controller.text.trim(),
                  );
                  if (result != null && result.isNotEmpty) {
                    _controller.text = result;
                    _focusNode.requestFocus();
                  }
                  // debugPrint('result: $result');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    context.loc.withAiButton,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            if (screenWidth < pcWidthBreakpoint) ...[
              TabBar(
                physics: const NeverScrollableScrollPhysics(),
                tabs: tabTitles
                    .map((e) => Tab(
                          text: e.title,
                          height: 32,
                        ))
                    .toList(),
                onTap: (value) {
                  if (value == 1) {
                    FocusScope.of(context).unfocus();
                  }
                },
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    EditorField(
                      controller: _controller,
                      focusNode: _focusNode,
                    ),
                    MarkdownField(
                      controller: _controller,
                    ),
                  ],
                ),
              ),
            ] else
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            child: EditorField(
                              controller: _controller,
                              focusNode: _focusNode,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      flex: 1,
                      child: MarkdownField(
                        controller: _controller,
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(),
            EditorBottomBar(
              bottomBarHeight: bottomBarHeight,
              getMedia: _getMedia,
              controller: _controller,
              postId: widget.postId,
              catetory: currentCategory,
              hasPostContent: hasPostContent,
              remoteMedia: _remoteMedia,
              writer: widget.postAndWriter?.writer,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: isLoading
            ? Center(
                child: PercentCircularIndicator(
                  strokeWidth: 8,
                  percentage: uploadState.percentage,
                  index: uploadState.index,
                ),
              )
            : null,
      ),
    );
  }
}

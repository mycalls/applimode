// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/persistence/shared_preferences.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/check_category.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';
import 'package:applimode_app/src/utils/show_adaptive_alert_dialog.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

// features
import 'package:applimode_app/src/features/editor/presentation/editor_screen_controller.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';

class EditorBottomBar extends ConsumerStatefulWidget {
  const EditorBottomBar({
    super.key,
    required this.bottomBarHeight,
    required this.getMedia,
    required this.controller,
    this.postId,
    this.catetory,
    this.hasPostContent,
    this.remoteMedia,
    this.currentPost,
  });

  final double bottomBarHeight;
  final Future<void> Function(double mediaMaxMBSize) getMedia;
  final TextEditingController controller;
  final String? postId;
  final int? catetory;
  final bool? hasPostContent;
  final List<String>? remoteMedia;
  final Post? currentPost;

  @override
  ConsumerState<EditorBottomBar> createState() => _EditorBottomBarState();
}

class _EditorBottomBarState extends ConsumerState<EditorBottomBar> {
  static const iconSizeForBottomBar = 32.0;
  int category = 0;

  bool _isCancelled = false;

  @override
  void initState() {
    category = widget.catetory ?? 0;
    widget.controller.addListener(_safeSetState);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EditorBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.catetory != widget.catetory) {
      category = widget.catetory ?? 0;
    }
  }

  @override
  void dispose() {
    _isCancelled = true;
    widget.controller.removeListener(_safeSetState);
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

  @override
  Widget build(BuildContext context) {
    final adminSettings = ref.watch(adminSettingsProvider);
    final useCategory = adminSettings.useCategory;
    final categoryList = adminSettings.mainCategory;
    final state = ref.watch(editorScreenControllerProvider);
    final goRouter = ref.watch(goRouterProvider);
    // final progressState = ref.watch(uploadProgressStateProvider);
    final mediaMaxMBSize = ref.watch(adminSettingsProvider).mediaMaxMBSize;
    final isIosWeb = kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    return SafeArea(
      child: GestureDetector(
        onVerticalDragDown: (details) => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: EdgeInsets.only(
            top: 12,
            left: 16,
            right: 16,
            bottom: isIosWeb ? iosWebBottomSafeArea : 12,
          ),
          height: state.isLoading ? widget.bottomBarHeight : null,
          child: /* state.isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        '${context.loc.uploadingFile} ${progressState.index + 1}: ${progressState.percentage == 0 ? context.loc.initializing : progressState.percentage}${progressState.percentage == 0 ? '' : '%'}'),
                    const SizedBox(width: 12),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                )
              : */
              IgnorePointer(
            ignoring: state.isLoading,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // media
                    IconButton(
                      onPressed: () => widget.getMedia(mediaMaxMBSize),
                      icon: const Icon(Icons.image_outlined),
                      iconSize: iconSizeForBottomBar,
                    ),

                    if (useCategory) ...[
                      const SizedBox(width: 12),
                      MenuAnchor(
                        builder: (context, controller, child) {
                          return FilledButton.tonal(
                            onPressed: () async {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                FocusScope.of(context).unfocus();
                                await Future.delayed(
                                    const Duration(milliseconds: 250));
                                controller.open();
                              }
                            },
                            style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                    horizontal: 24,
                                    // vertical: 12,
                                  ),
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                    checkCategory(categoryList, category)
                                        .color),
                                foregroundColor:
                                    const WidgetStatePropertyAll(Colors.white)),
                            child: Text(
                              checkCategory(categoryList, category).title,
                            ),
                          );
                        },
                        menuChildren: [
                          ...categoryList.map((item) => MenuItemButton(
                                onPressed: () {
                                  _safeSetState(() => category = item.index);
                                },
                                child: Text(item.title),
                              )),
                        ],
                      ),
                    ],
                    const SizedBox(width: 12),
                  ],
                ),
                FilledButton(
                  onPressed: widget.controller.text.trim().isEmpty
                      ? null
                      : () async {
                          if (widget.controller.text.trim().isEmpty) {
                            showAdaptiveAlertDialog(
                              context: context,
                              title: context.loc.ooops,
                              content: context.loc.emptyContent,
                            );
                            return;
                          }
                          final result = await ref
                              .read(editorScreenControllerProvider.notifier)
                              .publish(
                                content: widget.controller.text,
                                category: category,
                                hasPostContent: widget.hasPostContent ?? false,
                                postId: widget.postId,
                                oldRemoteMedia: widget.remoteMedia,
                                postNotiString: context.loc.postNoti,
                                currentPost: widget.currentPost,
                              );
                          if (mounted && result) {
                            // When the post writing is complete,
                            // delete the temporarily saved post.
                            ref
                                .read(prefsWithCacheProvider)
                                .requireValue
                                .setString('tempNewPost', '');
                            if (kIsWeb) {
                              WebBackStub().back();
                            } else {
                              if (goRouter.canPop()) {
                                goRouter.pop();
                              }
                            }
                          }
                        },
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                  ),
                  child: Text(
                    context.loc.submit,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

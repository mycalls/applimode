import 'dart:developer' as dev;

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_image.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/src/common_widgets/responsive_widget.dart';
import 'package:applimode_app/src/common_widgets/sized_circular_progress_indicator.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/features/admin_settings/presentation/admin_settings_screen_controller.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';
import 'package:applimode_app/src/utils/show_color_picker.dart';
import 'package:applimode_app/src/utils/show_image_picker.dart';
import 'package:applimode_app/src/utils/show_selection_dialog.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

enum HomeBarTitleStyle {
  text,
  image,
  textimage;
}

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleTextController = TextEditingController();
  int _titleStyle = spareHomeBarStyle;
  String _titleImageUrl = spareHomeBarImageUrl;
  XFile? _pickedFile;
  String? _pickedFileMediaType;
  Color _mainColor = Format.hexStringToColor(spareMainColor);
  final List<CategoryController> _categories = [];
  bool _showAppStyleOption = spareShowAppStyleOption;
  PostsListType _postsListType = sparePostsListType;
  BoxColorType _boxColorType = spareBoxColorType;
  double _mediaMaxMBSize = spareMediaMaxMBSize;
  bool _useRecommendation = spareUseRecommendation;
  bool _useRanking = spareUseRanking;
  bool _useCategory = spareUseCategory;
  bool _showLogoutOnDrawer = spareShowLogoutOnDrawer;
  bool _showLikeCount = spareShowLikeCount;
  bool _showDislikeCount = spareShowDislikeCount;
  bool _showCommentCount = spareShowCommentCount;
  bool _showSumCount = spareShowSumCount;
  bool _showCommentPlusLikeCount = spareShowCommentPlusLikeCount;
  bool _isThumbUpToHeart = spareIsThumbUpToHeart;
  bool _showUserAdminLabel = spareShowUserAdminLabel;
  bool _showUserLikeCount = spareShowUserLikeCount;
  bool _showUserDislikeCount = spareShowUserDislikeCount;
  bool _showUserSumCount = spareShowUserSumCount;
  bool _isMaintenance = false;
  bool _adminOnlyWrite = spareAdminOnlyWrite;
  bool _isPostsItemVideoMute = spareIsPostsItemVideoMute;

  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    final currentValues = ref.read(adminSettingsProvider);
    _titleTextController.text = currentValues.homeBarTitle;
    _titleStyle =
        List<int>.generate(HomeBarTitleStyle.values.length, (index) => index)
                .contains(currentValues.homeBarStyle)
            ? currentValues.homeBarStyle
            : 0;
    _titleImageUrl = currentValues.homeBarImageUrl;
    _mainColor = currentValues.mainColor;
    for (final mainCategory in currentValues.mainCategory) {
      final index = mainCategory.index;
      // dev.log('index: $index');
      _categories.add(
        CategoryController(
          index: index,
          pathController: TextEditingController(),
          titleController: TextEditingController(),
          color: mainCategory.color,
        ),
      );
      _categories[index].pathController.text =
          currentValues.mainCategory[index].path.substring(1);
      _categories[index].titleController.text =
          currentValues.mainCategory[index].title;
    }
    _showAppStyleOption = currentValues.showAppStyleOption;
    _postsListType = currentValues.postsListType;
    _boxColorType = currentValues.boxColorType;
    _mediaMaxMBSize = currentValues.mediaMaxMBSize;
    _useRecommendation = currentValues.useRecommendation;
    _useRanking = currentValues.useRanking;
    _useCategory = currentValues.useCategory;
    _showLogoutOnDrawer = currentValues.showLogoutOnDrawer;
    _showLikeCount = currentValues.showLikeCount;
    _showDislikeCount = currentValues.showDislikeCount;
    _showCommentCount = currentValues.showCommentCount;
    _showSumCount = currentValues.showSumCount;
    _showCommentPlusLikeCount = currentValues.showCommentPlusLikeCount;
    _isThumbUpToHeart = currentValues.isThumbUpToHeart;
    _showUserAdminLabel = currentValues.showUserAdminLabel;
    _showUserLikeCount = currentValues.showUserLikeCount;
    _showUserDislikeCount = currentValues.showUserDislikeCount;
    _showUserSumCount = currentValues.showUserSumCount;
    _isMaintenance = currentValues.isMaintenance;
    _adminOnlyWrite = currentValues.adminOnlyWrite;
    _isPostsItemVideoMute = currentValues.isPostsItemVideoMute;
  }

  @override
  void dispose() {
    _isCancelled = true;
    _titleTextController.dispose();
    for (final category in _categories) {
      category.pathController.dispose();
      category.titleController.dispose();
    }
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
    if (_formKey.currentState!.validate()) {
      final mainCategory = _categories
          .map((e) => MainCategory(
                index: e.index,
                path: '/${e.pathController.text}',
                title: e.titleController.text,
                color: e.color,
              ))
          .toList();
      dev.log('mainCategory: $mainCategory');
      final result = await ref
          .read(adminSettingsScreenControllerProvider.notifier)
          .saveAdminSettings(
            homeBarTitle: _titleTextController.text,
            homeBarStyle: _titleStyle,
            homeBarTitleImageUrl: _titleImageUrl,
            mainColor: _mainColor,
            mainCategory: mainCategory,
            xFile: _pickedFile,
            mediaType: _pickedFileMediaType,
            showAppStyleOption: _showAppStyleOption,
            postsListType: _postsListType,
            boxColorType: _boxColorType,
            mediaMaxMBSize: _mediaMaxMBSize,
            useRecommendation: _useRecommendation,
            useRanking: _useRanking,
            useCategory: _useCategory,
            showLogoutOnDrawer: _showLogoutOnDrawer,
            showLikeCount: _showLikeCount,
            showDislikeCount: _showDislikeCount,
            showCommentCount: _showCommentCount,
            showSumCount: _showSumCount,
            showCommentPlusLikeCount: _showCommentPlusLikeCount,
            isThumbUpToHeart: _isThumbUpToHeart,
            showUserAdminLabel: _showUserAdminLabel,
            showUserLikeCount: _showUserLikeCount,
            showUserDislikeCount: _showUserDislikeCount,
            showUserSumCount: _showUserSumCount,
            isMaintenance: _isMaintenance,
            adminOnlyWrite: _adminOnlyWrite,
            isPostsItemVideoMute: _isPostsItemVideoMute,
          );
      if (mounted && result) {
        if (kIsWeb) {
          WebBackStub().back();
        } else {
          if (context.canPop()) {
            context.pop();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(adminSettingsScreenControllerProvider, (_, next) {
      next.showAlertDialogOnError(context);
    });

    final isLoading =
        ref.watch(adminSettingsScreenControllerProvider).isLoading;

    final titleHeaderStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: kIsWeb ? false : true,
        leading: kIsWeb ? const WebBackButton() : null,
        title: Text(context.loc.adminSettings),
      ),
      body: SafeArea(
        child: ResponsiveScrollView(
          child: Form(
            key: _formKey,
            child: IgnorePointer(
              ignoring: isLoading ? true : false,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        context.loc.homeTitleSetting,
                        style: titleHeaderStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor:
                        ColorScheme.fromSeed(seedColor: _mainColor).surface,
                    surfaceTintColor:
                        ColorScheme.fromSeed(seedColor: _mainColor).surfaceTint,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_titleStyle == 1 || _titleStyle == 2)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: mainScreenAppBarPadding),
                            child: SizedBox(
                              height: mainScreenAppBarHeight -
                                  2 * mainScreenAppBarPadding,
                              child: _pickedFile != null
                                  ? FlatformImage(
                                      xFile: _pickedFile!,
                                      hPadding: 0,
                                      vPadding: 0,
                                    )
                                  : _titleImageUrl.startsWith('assets')
                                      ? Image.asset(_titleImageUrl)
                                      : PlatformNetworkImage(
                                          imageUrl: _titleImageUrl,
                                          /*
                          cacheHeight: (mainScreenAppBarHeight -
                                  2 * mainScreenAppBarPadding)
                              .round(),
                          */
                                          errorWidget: const SizedBox.shrink(),
                                        ),
                            ),
                          ),
                        if (_titleStyle == 2) const SizedBox(width: 8),
                        if (_titleStyle == 0 || _titleStyle == 2)
                          Text(_titleTextController.text),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: MenuAnchor(
                          builder: (context, controller, child) {
                            return FilledButton.tonal(
                              style: const ButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ))),
                              onPressed: () {
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  FocusScope.of(context).unfocus();
                                  controller.open();
                                }
                              },
                              child: Text(
                                _getTitleStyleString(
                                    HomeBarTitleStyle.values[_titleStyle]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                          menuChildren: [
                            MenuItemButton(
                              onPressed: () {
                                _safeSetState(() => _titleStyle = 0);
                              },
                              child: Text(context.loc.textStyle),
                            ),
                            MenuItemButton(
                              onPressed: () {
                                _safeSetState(() => _titleStyle = 1);
                              },
                              child: Text(context.loc.imageStyle),
                            ),
                            MenuItemButton(
                              onPressed: () {
                                _safeSetState(() => _titleStyle = 2);
                              },
                              child: Text(context.loc.textImageStyle),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton.tonal(
                          style: const ButtonStyle(
                              padding:
                                  WidgetStatePropertyAll(EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ))),
                          onPressed: () {
                            showSelectionDialog(
                              context: context,
                              firstTitle: context.loc.defaultImage,
                              firstTap: () async {
                                context.pop();
                                _safeSetState(() {
                                  _titleImageUrl = spareHomeBarImageUrl;
                                  _pickedFile = null;
                                });
                              },
                              secondTitle: context.loc.chooseFromGallery,
                              secondTap: () async {
                                context.pop();
                                _pickedFile = await showImagePicker(
                                  isImage: true,
                                  maxHeight: 128,
                                  mediaMaxMBSize: _mediaMaxMBSize,
                                );
                                if (_pickedFile != null) {
                                  _pickedFileMediaType = _pickedFile!.mimeType;
                                }
                                _safeSetState();
                              },
                            );
                          },
                          child: Text(context.loc.changeHomeAppBarTitleImage),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleTextController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: context.loc.homeAppBarTitleText,
                    ),
                    maxLength: 32,
                    onChanged: (value) {
                      _safeSetState();
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.loc.enterTitle;
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        context.loc.mainColorSetting,
                        style: titleHeaderStyle,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(_mainColor),
                              padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ))),
                          onPressed: () async {
                            final selectedColor = await showColorPicker(
                              context: context,
                              currentColor: _mainColor,
                            );
                            if (selectedColor != null) {
                              _safeSetState(() => _mainColor = selectedColor);
                            }
                          },
                          child: Text(context.loc.changeMainColor),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        context.loc.categorySetting,
                        style: titleHeaderStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ..._categories.map(
                    (controller) => Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.pathController,
                                decoration: InputDecoration(
                                  labelText: context.loc.pathName,
                                  // helperText: context.loc.onlyLowercase,
                                  hintText: context.loc.onlyLowercase,
                                  prefixText: '/',
                                  border: const OutlineInputBorder(),
                                ),
                                maxLength: 24,
                                validator: (value) {
                                  final paths = _categories
                                      .map((e) => e.pathController.text)
                                      .toList();
                                  final pathsSet = paths.toSet();
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      Regex.urlPathStringRegex
                                          .hasMatch(value)) {
                                    return context.loc.invalidName;
                                  }
                                  if (paths.length != pathsSet.length) {
                                    return context.loc.duplicateName;
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: controller.titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Title name',
                                  border: OutlineInputBorder(),
                                ),
                                maxLength: 24,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return context.loc.invalidName;
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ),
                            const SizedBox(width: 16),
                            /*
                            InkWell(
                              onTap: () async {
                                final selectedColor = await showColorPicker(
                                  context: context,
                                  currentColor: _mainColor,
                                  colorPalettes: boxSingleColorPalettes,
                                );
                                if (selectedColor != null) {
                                  _safeSetState();
                                }
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: controller.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            */
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          style: const ButtonStyle(
                              padding:
                                  WidgetStatePropertyAll(EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ))),
                          onPressed: () {
                            final currentIndex = _categories.length;
                            _categories.add(
                              CategoryController(
                                index: currentIndex,
                                pathController: TextEditingController(),
                                titleController: TextEditingController(),
                                color: boxSingleColorPalettes[
                                    _categories.length %
                                        boxSingleColorPalettes.length],
                              ),
                            );
                            dev.log('index: $currentIndex');
                            final indexForName =
                                (_categories.length).toString().padLeft(3, '0');
                            _safeSetState(() {
                              _categories[currentIndex].pathController.text =
                                  'cat$indexForName';
                              _categories[currentIndex].titleController.text =
                                  'cat$indexForName';
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: Text(context.loc.addCategory),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          style: const ButtonStyle(
                              padding:
                                  WidgetStatePropertyAll(EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ))),
                          onPressed: () {
                            if (_categories.length > 1) {
                              // remove controllers
                              _categories.last.pathController.dispose();
                              _categories.last.titleController.dispose();
                              _safeSetState(() => _categories.removeLast());
                            }
                          },
                          icon: const Icon(Icons.remove),
                          label: Text(context.loc.deleteCategory),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.showAppStyleButton),
                    value: _showAppStyleOption,
                    onChanged: (value) {
                      _safeSetState(() => _showAppStyleOption = value);
                    },
                  ),
                  const Divider(),
                  MenuAnchor(
                    style: const MenuStyle(
                        alignment: Alignment.bottomRight,
                        padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 24))),
                    builder: (context, controller, child) => ListTile(
                      onTap: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          FocusScope.of(context).unfocus();
                          controller.open();
                        }
                      },
                      leading: const Icon(Icons.space_dashboard_outlined),
                      title: Text(context.loc.appStyle),
                      trailing: Text(_getPostsListTypeLabel(
                          context, _postsListType.index)),
                      leadingAndTrailingTextStyle:
                          Theme.of(context).textTheme.labelLarge,
                    ),
                    menuChildren: [
                      MenuItemButton(
                        onPressed: () {
                          _safeSetState(
                              () => _postsListType = PostsListType.small);
                        },
                        child: Text(context.loc.listType),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          _safeSetState(
                              () => _postsListType = PostsListType.square);
                        },
                        child: Text(context.loc.cardType),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          _safeSetState(
                              () => _postsListType = PostsListType.page);
                        },
                        child: Text(context.loc.pageType),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          _safeSetState(
                              () => _postsListType = PostsListType.round);
                        },
                        child: Text(context.loc.roundCardType),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          _safeSetState(
                              () => _postsListType = PostsListType.mixed);
                        },
                        child: Text(context.loc.mixedType),
                      ),
                    ],
                  ),
                  const Divider(),
                  MenuAnchor(
                    style: const MenuStyle(
                        alignment: Alignment.bottomRight,
                        padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 24))),
                    builder: (context, controller, child) => ListTile(
                      onTap: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          FocusScope.of(context).unfocus();
                          controller.open();
                        }
                      },
                      leading: const Icon(Icons.color_lens_outlined),
                      title: Text(context.loc.boxColorType),
                      trailing: Text(
                          _getBoxColorTypeLabel(context, _boxColorType.index)),
                      leadingAndTrailingTextStyle:
                          Theme.of(context).textTheme.labelLarge,
                    ),
                    menuChildren: [
                      MenuItemButton(
                        onPressed: () {
                          _safeSetState(
                              () => _boxColorType = BoxColorType.single);
                        },
                        child: Text(context.loc.singleColor),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          _safeSetState(
                              () => _boxColorType = BoxColorType.gradient);
                        },
                        child: Text(context.loc.gradientColor),
                      ),
                    ],
                  ),
                  const Divider(),
                  MenuAnchor(
                    style: const MenuStyle(
                        alignment: Alignment.bottomRight,
                        padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 24))),
                    builder: (context, controller, child) => ListTile(
                      onTap: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          FocusScope.of(context).unfocus();
                          controller.open();
                        }
                      },
                      title: Text(context.loc.mediaMaxMBSize),
                      trailing: Text('${_mediaMaxMBSize.round()} MB'),
                      leadingAndTrailingTextStyle:
                          Theme.of(context).textTheme.labelLarge,
                    ),
                    menuChildren: mediaMaxMBSizesList
                        .map<MenuItemButton>(
                          (double size) => MenuItemButton(
                            onPressed: () {
                              _safeSetState(() => _mediaMaxMBSize = size);
                            },
                            child: Text('${size.round()} MB'),
                          ),
                        )
                        .toList(),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.useRecommendation),
                    value: _useRecommendation,
                    onChanged: (value) {
                      _safeSetState(() => _useRecommendation = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.useRanking),
                    value: _useRanking,
                    onChanged: (value) {
                      _safeSetState(() => _useRanking = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.useCategory),
                    value: _useCategory,
                    onChanged: (value) {
                      _safeSetState(() => _useCategory = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.showLogoutOnDrawer),
                    value: _showLogoutOnDrawer,
                    onChanged: (value) {
                      _safeSetState(() => _showLogoutOnDrawer = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.showCommentCount),
                    value: _showCommentCount,
                    onChanged: (value) {
                      _safeSetState(() => _showCommentCount = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.showLikeCount),
                    value: _showLikeCount,
                    onChanged: (value) {
                      _safeSetState(() => _showLikeCount = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.showDislikeCount),
                    value: _showDislikeCount,
                    onChanged: (value) {
                      _safeSetState(() => _showDislikeCount = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.showSumCount),
                    value: _showSumCount,
                    onChanged: (value) {
                      _safeSetState(() => _showSumCount = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.showCommentPlusLikeCount),
                    value: _showCommentPlusLikeCount,
                    onChanged: (value) {
                      _safeSetState(() => _showCommentPlusLikeCount = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.isThumbUpToHeart),
                    value: _isThumbUpToHeart,
                    onChanged: (value) {
                      _safeSetState(() => _isThumbUpToHeart = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.showUserAdminLabel),
                    value: _showUserAdminLabel,
                    onChanged: (value) {
                      _safeSetState(() => _showUserAdminLabel = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.showUserLikeCount),
                    value: _showUserLikeCount,
                    onChanged: (value) {
                      _safeSetState(() => _showUserLikeCount = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.showUserDislikeCount),
                    value: _showUserDislikeCount,
                    onChanged: (value) {
                      _safeSetState(() => _showUserDislikeCount = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.showUserSumCount),
                    value: _showUserSumCount,
                    onChanged: (value) {
                      _safeSetState(() => _showUserSumCount = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.adminsOnlyPosting),
                    value: _adminOnlyWrite,
                    onChanged: (value) {
                      _safeSetState(() => _adminOnlyWrite = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.defaultVideoMute),
                    value: _isPostsItemVideoMute,
                    onChanged: (value) {
                      _safeSetState(() => _isPostsItemVideoMute = value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(context.loc.systemMaintenanceMode),
                    value: _isMaintenance,
                    onChanged: (value) {
                      _safeSetState(() => _isMaintenance = value);
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLoading
                          ? const SizedCircularProgressIndicator()
                          : Expanded(
                              child: FilledButton.icon(
                                onPressed: _submit,
                                icon: const Icon(Icons.save_outlined),
                                label: Text(context.loc.save),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTitleStyleString(HomeBarTitleStyle style) {
    switch (style) {
      case HomeBarTitleStyle.text:
        return context.loc.textStyle;
      case HomeBarTitleStyle.image:
        return context.loc.imageStyle;
      case HomeBarTitleStyle.textimage:
        return context.loc.textImageStyle;
    }
  }

  String _getPostsListTypeLabel(BuildContext context, int index) {
    switch (index) {
      case 0:
        return context.loc.listType;
      case 1:
        return context.loc.cardType;
      case 2:
        return context.loc.pageType;
      case 3:
        return context.loc.roundCardType;
      case 4:
        return context.loc.mixedType;
      default:
        return context.loc.mixedType;
    }
  }

  String _getBoxColorTypeLabel(BuildContext context, int index) {
    switch (index) {
      case 0:
        return context.loc.singleColor;
      case 1:
        return context.loc.gradientColor;
      case 2:
        return context.loc.animationColor;
      default:
        return context.loc.gradientColor;
    }
  }

  // ignore: unused_element
  List<double> _getMediaMaxMBSizes() {
    return [10.0, ...List.generate(20, (int index) => (index * 50.0) + 50.0)];
  }
}

class CategoryController {
  const CategoryController({
    required this.index,
    required this.pathController,
    required this.titleController,
    required this.color,
  });

  final int index;
  final TextEditingController pathController;
  final TextEditingController titleController;
  final Color color;
}

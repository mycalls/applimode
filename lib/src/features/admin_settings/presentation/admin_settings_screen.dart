// lib/src/features/admin_settings/presentation/admin_settings_screen.dart

import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';
import 'package:applimode_app/src/utils/show_color_picker.dart';
import 'package:applimode_app/src/utils/show_image_picker.dart';
import 'package:applimode_app/src/utils/show_selection_dialog.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_image.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/src/common_widgets/responsive_widget.dart';
import 'package:applimode_app/src/common_widgets/sized_circular_progress_indicator.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/admin_settings/domain/admin_settings.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/features/admin_settings/presentation/admin_settings_screen_controller.dart';

// Enum to represent different styles for the home app bar title.
// 홈 앱 바 제목의 다양한 스타일을 나타내는 열거형입니다.
enum HomeBarTitleStyle {
  text,
  image,
  textimage;
}

// AdminSettingsScreen: A StatefulWidget that allows administrators to configure application settings.
// It uses Riverpod for state management and interacts with AdminSettingsService to save changes.
// AdminSettingsScreen: 관리자가 애플리케이션 설정을 구성할 수 있게 하는 StatefulWidget입니다.
// Riverpod를 사용하여 상태를 관리하고 AdminSettingsService와 상호 작용하여 변경 사항을 저장합니다.
class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  // Creates the mutable state for this widget.
  // 이 위젯의 변경 가능한 상태를 생성합니다.
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleTextController = TextEditingController();

  // State variables for admin settings, initialized with default or current values.
  // 기본값 또는 현재 값으로 초기화된 관리자 설정의 상태 변수입니다.

  // Home app bar title style.
  // 홈 앱 바 제목 스타일입니다.
  int _titleStyle = spareHomeBarStyle;
  // Home app bar title image URL.
  // 홈 앱 바 제목 이미지 URL입니다.
  String _titleImageUrl = spareHomeBarImageUrl;
  // Picked image file for the app bar title.
  // 앱 바 제목을 위해 선택된 이미지 파일입니다.
  XFile? _pickedFile;
  // Media type of the picked image file.
  // 선택된 이미지 파일의 미디어 유형입니다.
  String? _pickedFileMediaType;
  // Main theme color of the application.
  // 애플리케이션의 주요 테마 색상입니다.
  Color _mainColor = Format.hexStringToColor(spareMainColor);
  // List of category controllers for managing main categories.
  // 주요 카테고리 관리를 위한 카테고리 컨트롤러 목록입니다.
  final List<CategoryController> _categories = [];
  // Whether to show the app style option in settings.
  // 설정에서 앱 스타일 옵션을 표시할지 여부입니다.
  bool _showAppStyleOption = spareShowAppStyleOption;
  // Type of posts list display.
  // 게시물 목록 표시 유형입니다.
  PostsListType _postsListType = sparePostsListType;
  // Color type for post item boxes.
  // 게시물 항목 상자의 색상 유형입니다.
  BoxColorType _boxColorType = spareBoxColorType;
  // Maximum media file size in MB.
  // 최대 미디어 파일 크기(MB)입니다.
  double _mediaMaxMBSize = spareMediaMaxMBSize;
  // Whether to use the recommendation feature.
  // 추천 기능을 사용할지 여부입니다.
  bool _useRecommendation = spareUseRecommendation;
  // Whether to use the ranking feature.
  // 랭킹 기능을 사용할지 여부입니다.
  bool _useRanking = spareUseRanking;
  // Whether to use categories.
  // 카테고리를 사용할지 여부입니다.
  bool _useCategory = spareUseCategory;
  // Whether to show the logout button in the drawer.
  // 드로어에 로그아웃 버튼을 표시할지 여부입니다.
  bool _showLogoutOnDrawer = spareShowLogoutOnDrawer;
  // Whether to show like counts on posts.
  // 게시물에 좋아요 수를 표시할지 여부입니다.
  bool _showLikeCount = spareShowLikeCount;
  // Whether to show dislike counts on posts.
  // 게시물에 싫어요 수를 표시할지 여부입니다.
  bool _showDislikeCount = spareShowDislikeCount;
  // Whether to show comment counts on posts.
  // 게시물에 댓글 수를 표시할지 여부입니다.
  bool _showCommentCount = spareShowCommentCount;
  // Whether to show the sum of likes and dislikes on posts.
  // 게시물에 좋아요와 싫어요 합계를 표시할지 여부입니다.
  bool _showSumCount = spareShowSumCount;
  // Whether to show the sum of comments and likes on posts.
  // 게시물에 댓글과 좋아요 합계를 표시할지 여부입니다.
  bool _showCommentPlusLikeCount = spareShowCommentPlusLikeCount;
  // Whether to change the thumb-up icon to a heart icon.
  // 좋아요 아이콘을 하트 아이콘으로 변경할지 여부입니다.
  bool _isThumbUpToHeart = spareIsThumbUpToHeart;
  // Whether to show admin labels on user profiles.
  // 사용자 프로필에 관리자 라벨을 표시할지 여부입니다.
  bool _showUserAdminLabel = spareShowUserAdminLabel;
  // Whether to show like counts on user profiles.
  // 사용자 프로필에 좋아요 수를 표시할지 여부입니다.
  bool _showUserLikeCount = spareShowUserLikeCount;
  // Whether to show dislike counts on user profiles.
  // 사용자 프로필에 싫어요 수를 표시할지 여부입니다.
  bool _showUserDislikeCount = spareShowUserDislikeCount;
  // Whether to show the sum of likes and dislikes on user profiles.
  // 사용자 프로필에 좋아요와 싫어요 합계를 표시할지 여부입니다.
  bool _showUserSumCount = spareShowUserSumCount;
  // Whether the application is in maintenance mode.
  // 애플리케이션이 유지보수 모드인지 여부입니다.
  bool _isMaintenance = false;
  // Whether only admins can write posts.
  // 관리자만 게시물을 작성할 수 있는지 여부입니다.
  bool _adminOnlyWrite = spareAdminOnlyWrite;
  // Whether videos in post items are muted by default.
  // 게시물 항목의 비디오가 기본적으로 음소거되는지 여부입니다.
  bool _isPostsItemVideoMute = spareIsPostsItemVideoMute;

  // Flag to prevent calling setState after dispose.
  // dispose 후 setState 호출을 방지하기 위한 플래그입니다.
  bool _isCancelled = false;

  // Initializes the state from the current admin settings provided by Riverpod.
  // Riverpod에서 제공하는 현재 관리자 설정으로 상태를 초기화합니다.
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

  // Disposes resources like TextEditingControllers when the widget is removed from the tree.
  // 위젯이 트리에서 제거될 때 TextEditingController와 같은 리소스를 해제합니다.
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

  // Safely calls setState only if the widget is still mounted.
  // 위젯이 여전히 마운트된 경우에만 안전하게 setState를 호출합니다.
  void _safeSetState([VoidCallback? callback]) {
    if (_isCancelled) return;
    if (mounted) {
      safeBuildCall(() => setState(() {
            callback?.call();
          }));
    }
  }

  // Constructs an AdminSettings object from the current state of the form fields.
  // 현재 폼 필드의 상태로부터 AdminSettings 객체를 구성합니다.
  AdminSettings _buildAdminSettings() {
    final mainCategory = _categories
        .map((e) => MainCategory(
              index: e.index,
              path: '/${e.pathController.text}',
              title: e.titleController.text,
              color: e.color,
            ))
        .toList();
    dev.log('mainCategory: $mainCategory');
    return AdminSettings(
      homeBarTitle: _titleTextController.text,
      homeBarStyle: _titleStyle,
      homeBarImageUrl: _titleImageUrl,
      mainColor: _mainColor,
      mainCategory: mainCategory,
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
  }

  // Validates the form and submits the admin settings if valid.
  // 폼을 유효성 검사하고 유효한 경우 관리자 설정을 제출합니다.
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final result = await ref
          .read(adminSettingsScreenControllerProvider.notifier)
          .saveAdminSettings(
            settings: _buildAdminSettings(),
            xFile: _pickedFile,
            mediaType: _pickedFileMediaType,
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

  // Builds the UI for the admin settings screen.
  // 관리자 설정 화면의 UI를 빌드합니다.
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
                      trailing:
                          Text(_getPostsListTypeLabel(_postsListType.index)),
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
                      trailing:
                          Text(_getBoxColorTypeLabel(_boxColorType.index)),
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

  // Helper method to get the localized string for a HomeBarTitleStyle.
  // HomeBarTitleStyle에 대한 지역화된 문자열을 가져오는 헬퍼 메서드입니다.
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

  // Helper method to get the localized string for a PostsListType based on its index.
  // 인덱스를 기반으로 PostsListType에 대한 지역화된 문자열을 가져오는 헬퍼 메서드입니다.
  String _getPostsListTypeLabel(int index) {
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

  // Helper method to get the localized string for a BoxColorType based on its index.
  // 인덱스를 기반으로 BoxColorType에 대한 지역화된 문자열을 가져오는 헬퍼 메서드입니다.
  String _getBoxColorTypeLabel(int index) {
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

// CategoryController: A helper class to manage TextEditingControllers and color for each category.
// 각 카테고리에 대한 TextEditingController와 색상을 관리하는 헬퍼 클래스입니다.
class CategoryController {
  const CategoryController({
    required this.index,
    required this.pathController,
    required this.titleController,
    required this.color,
  });

  // The index of the category.
  // 카테고리의 인덱스입니다.
  final int index;
  // TextEditingController for the category path.
  // 카테고리 경로를 위한 TextEditingController입니다.
  final TextEditingController pathController;
  // TextEditingController for the category title.
  // 카테고리 제목을 위한 TextEditingController입니다.
  final TextEditingController titleController;
  // Color associated with the category.
  // 카테고리와 관련된 색상입니다.
  final Color color;
}

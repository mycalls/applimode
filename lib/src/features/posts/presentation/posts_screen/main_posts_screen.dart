// flutter
import 'package:flutter/material.dart';

// core
import 'package:applimode_app/src/core/constants/constants.dart';

// features
import 'package:applimode_app/src/features/posts/presentation/posts_screen/main_posts_list.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_screen/posts_app_bar.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_screen/posts_drawer.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_screen/posts_floating_action_button.dart';

// English: The main screen for displaying posts. It adapts its layout and AppBar
// based on the provided `PostsListType`.
// Korean: 게시물을 표시하기 위한 메인 화면입니다. 제공된 `PostsListType`에 따라
// 레이아웃과 AppBar를 조정합니다.
class MainPostsScreen extends StatelessWidget {
  const MainPostsScreen({
    super.key,
    this.type = PostsListType.square,
  });

  // English: The type of post list to display (e.g., square, page, small).
  // This determines the overall layout and AppBar behavior.
  // Korean: 표시할 게시물 목록의 유형입니다 (예: square, page, small).
  // 이는 전체 레이아웃과 AppBar 동작을 결정합니다.
  final PostsListType type;

  @override
  Widget build(BuildContext context) {
    // English: Determine if the current list type is 'page'.
    // This flag is used to conditionally configure the Scaffold.
    // Korean: 현재 목록 유형이 'page'인지 확인합니다.
    // 이 플래그는 Scaffold를 조건부로 구성하는 데 사용됩니다.
    final isPage = type == PostsListType.page;
    return Scaffold(
      // English: Conditionally set the AppBar.
      // For 'page' type, a transparent AppBar is used because MainPostsList
      // will likely display content that should go behind the AppBar.
      // For other types, MainPostsList handles its own SliverAppBar.
      // Korean: AppBar를 조건부로 설정합니다.
      // 'page' 유형의 경우 MainPostsList가 AppBar 뒤에 표시되어야 하는 콘텐츠를
      // 표시할 가능성이 높으므로 투명한 AppBar가 사용됩니다.
      // 다른 유형의 경우 MainPostsList가 자체 SliverAppBar를 처리합니다.
      appBar: isPage
          ? PostsAppBar(
              forceMaterialTransparency: true,
              foregroundColor: Colors.white,
              elevation: 0,
            )
          : null,
      body: MainPostsList(type: type),
      floatingActionButton: const PostsFloatingActionButton(),
      drawer: const PostsDrawer(),
      // English: Disable opening the drawer via drag gesture.
      // Korean: 드래그 제스처를 통한 드로어 열기를 비활성화합니다.
      drawerEnableOpenDragGesture: false,
      // English: If 'isPage' is true, the body extends behind the AppBar.
      // Korean: 'isPage'가 true이면 body가 AppBar 뒤까지 확장됩니다.
      extendBodyBehindAppBar: isPage ? true : false,
      // English: Set background color to black for 'page' type for a more immersive view,
      // especially if content like images/videos are full-screen.
      // Korean: 'page' 유형의 경우 이미지/비디오와 같은 콘텐츠가 전체 화면일 경우
      // 더욱 몰입감 있는 뷰를 위해 배경색을 검은색으로 설정합니다.
      backgroundColor: isPage ? Colors.black : null,
    );
  }
}

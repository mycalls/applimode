// lib/src/features/posts/presentation/search_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/app_states/updated_post_id.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/common_widgets/search_page_list_view.dart';
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/search_bar.dart';
import 'package:applimode_app/src/features/search/data/d_one_repository.dart';

// English: A screen that allows users to search for posts.
// It can use different search backends (D.One or Firestore tags)
// based on configuration and search query format.
// Korean: 사용자가 게시물을 검색할 수 있도록 하는 화면입니다.
// 설정 및 검색어 형식에 따라 다른 검색 백엔드(D.One 또는 Firestore 태그)를 사용할 수 있습니다.
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.preSearchWord,
  });

  // English: An optional pre-filled search term.
  // Korean: 선택적으로 미리 채워질 검색어입니다.
  final String? preSearchWord;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // English: Controller for the search input field.
  // Korean: 검색 입력 필드의 컨트롤러입니다.
  final controller = TextEditingController();
  // English: The current search query string.
  // Korean: 현재 검색어 문자열입니다.
  String searchWords = '';

  // English: Flag to prevent calling setState on a disposed widget.
  // Korean: 폐기된 위젯에서 setState를 호출하는 것을 방지하는 플래그입니다.
  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    // English: If a pre-search word is provided, initialize the controller and searchWords.
    // Korean: 미리 정의된 검색어가 제공되면 컨트롤러와 searchWords를 초기화합니다.
    if (widget.preSearchWord != null &&
        widget.preSearchWord!.trim().isNotEmpty) {
      controller.text = widget.preSearchWord!;
      searchWords = widget.preSearchWord!;
    }
  }

  @override
  void dispose() {
    // English: Set the cancelled flag and dispose the controller to prevent memory leaks.
    // Korean: 메모리 누수를 방지하기 위해 취소 플래그를 설정하고 컨트롤러를 폐기합니다.
    _isCancelled = true;
    controller.dispose();
    super.dispose();
  }

  // English: Safely updates the state with the new search words from the controller.
  // Checks if the widget is still mounted and not cancelled.
  // Korean: 컨트롤러에서 가져온 새 검색어로 상태를 안전하게 업데이트합니다.
  // 위젯이 여전히 마운트되어 있고 취소되지 않았는지 확인합니다.
  void _safeSetState() {
    if (_isCancelled) return;
    if (mounted) {
      safeBuildCall(() => setState(() {
            searchWords = controller.text;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // English: Show standard back button on mobile, custom WebBackButton on web.
        // Korean: 모바일에서는 표준 뒤로가기 버튼을, 웹에서는 사용자 정의 WebBackButton을 표시합니다.
        automaticallyImplyLeading: kIsWeb ? false : true,
        leading: kIsWeb ? const WebBackButton() : null,
        // English: Custom search bar widget.
        // Korean: 사용자 정의 검색 바 위젯입니다.
        title: CustomSearchBar(
          controller: controller,
          onComplete: _safeSetState,
        ),
        // English: Adds a bottom border to the AppBar.
        // Korean: AppBar에 하단 테두리를 추가합니다.
        shape: const Border(
            bottom: BorderSide(
          color: Colors.black12,
        )),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final postsRepository = ref.watch(postsRepositoryProvider);
          // English: D.One repository, used if `useDOneForSearch` is true.
          // Korean: `useDOneForSearch`가 true인 경우 사용되는 D.One 리포지토리입니다.
          final dOneRepository = ref.watch(dOneRepositoryProvider);
          final updatedPostQuery =
              ref.watch(postsRepositoryProvider).postsRef();

          // English: Conditional logic to choose the search backend.
          // If `useDOneForSearch` is true and the search query doesn't start with '#',
          // use `SearchPageListView` (D.One search). Otherwise, use `SimplePageListView` (Firestore tag search).
          // Korean: 검색 백엔드를 선택하는 조건부 로직입니다.
          // `useDOneForSearch`가 true이고 검색어가 '#'으로 시작하지 않으면 `SearchPageListView`(D.One 검색)를 사용합니다.
          // 그렇지 않으면 `SimplePageListView`(Firestore 태그 검색)를 사용합니다.
          if (useDOneForSearch && !searchWords.startsWith(r'#')) {
            return SearchPageListView(
              searchWords: searchWords,
              searchQuery: dOneRepository.getPostsSearchAll,
              query: postsRepository.postRef,
              itemExtent: listSmallItemHeight,
              listState: postsListStateProvider,
              useDidUpdateWidget: true,
              refreshUpdatedDoc: true,
              updatedDocState: updatedPostIdProvider,
              itemBuilder: (context, index, doc) {
                // English: The document from D.One search might only contain an ID.
                // The actual Post data is fetched via `postsRepository.postRef`.
                // Korean: D.One 검색의 문서는 ID만 포함할 수 있습니다.
                // 실제 Post 데이터는 `postsRepository.postRef`를 통해 가져옵니다.
                final post = doc.data();
                if (post == null) {
                  return SmallPostsItem(post: Post.deleted());
                }
                return SmallPostsItem(
                  post: post,
                  index: index,
                );
              },
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            );
          }

          // English: Prepare search term for Firestore tag search by removing special characters.
          // Korean: 특수 문자를 제거하여 Firestore 태그 검색을 위한 검색어를 준비합니다.
          final processedSearchWords =
              searchWords.replaceAll(RegExp(r'[#_ ]'), '').trim();

          return SimplePageListView(
            isSearchView: true,
            query: postsRepository.searchTagQuery(processedSearchWords),
            useDidUpdateWidget: true,
            itemExtent: listSmallItemHeight,
            itemBuilder: (context, index, doc) {
              final post = doc.data();
              return SmallPostsItem(
                post: post,
                index: index,
              );
            },
            listState: postsListStateProvider,
            refreshUpdatedDoc: true,
            updatedDocQuery: updatedPostQuery,
            updatedDocState: updatedPostIdProvider,
            searchWords: processedSearchWords,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          );
        },
      ),
    );
  }
}

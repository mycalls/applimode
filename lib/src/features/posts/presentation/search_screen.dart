import 'package:applimode_app/src/utils/app_states/updated_post_id.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/common_widgets/search_page_list_view.dart';
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/features/search/data/d_one_repository.dart';
import 'package:applimode_app/src/utils/list_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.preSearchWord,
  });

  final String? preSearchWord;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  String searchWords = '';

  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    if (widget.preSearchWord != null &&
        widget.preSearchWord!.trim().isNotEmpty) {
      controller.text = widget.preSearchWord!;
      searchWords = widget.preSearchWord!;
    }
  }

  @override
  void dispose() {
    _isCancelled = true;
    controller.dispose();
    super.dispose();
  }

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
        automaticallyImplyLeading: kIsWeb ? false : true,
        leading: kIsWeb ? const WebBackButton() : null,
        title: CustomSearchBar(
          controller: controller,
          onComplete: _safeSetState,
        ),
        shape: const Border(
            bottom: BorderSide(
          color: Colors.black12,
        )),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final postsRepository = ref.watch(postsRepositoryProvider);
          final dOneRepository = ref.watch(dOneRepositoryProvider);
          final updatedPostQuery =
              ref.watch(postsRepositoryProvider).postsRef();

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

          return SimplePageListView(
            isSearchView: true,
            query: postsRepository.searchTagQuery(
                searchWords.replaceAll(RegExp(r'[#_ ]'), '').trim()),
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
            searchWords: searchWords.replaceAll(RegExp(r'[#_ ]'), '').trim(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          );
        },
      ),
    );
  }
}

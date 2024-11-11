import 'dart:developer' as dev;

import 'package:applimode_app/src/app_settings/app_settings_controller.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SimplePageListItemBuilder<Document> = Widget Function(
  BuildContext context,
  int index,
  QueryDocumentSnapshot<Document> doc,
);

typedef SimplePageListLoadingBuilder = Widget Function(BuildContext context);

typedef SimplePageListErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace stackTrace,
);

typedef SimplePageListEmptyBuilder = Widget Function(BuildContext context);

class SimplePageListView<Document> extends ConsumerStatefulWidget {
  const SimplePageListView({
    super.key,
    required this.query,
    required this.itemBuilder,
    this.isPage = false,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.listState,
    // this.showMain = false,
    this.mainQuery,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.prototypeItem,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.pageController,
    this.pageSnapping = true,
    this.onPageChanged,
    this.findChildIndexCallback,
    this.allowImplicitScrolling = false,
    this.scrollBehavior,
    this.padEnds = true,
    this.recentDocQuery,
    this.useDidUpdateWidget = false,
    this.refreshUpdatedDocs = false,
    this.updatedDocQuery,
    this.isRootTabel = false,
    this.resetUpdatedDocIds,
    this.updatedDocsState,
    this.useUid = false,
    this.isSearchView = false,
    this.isNoGridView = false,
    this.searchWords,
    this.isSliver = false,
  });

  final Query<Document> query;
  final SimplePageListItemBuilder<Document> itemBuilder;
  final bool isPage;
  final SimplePageListLoadingBuilder? loadingBuilder;
  final SimplePageListErrorBuilder? errorBuilder;
  final SimplePageListEmptyBuilder? emptyBuilder;
  final ProviderListenable<int>? listState;
  // final bool showMain;
  final Query<Document>? mainQuery;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final Widget? prototypeItem;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final PageController? pageController;
  final bool pageSnapping;
  final void Function(int)? onPageChanged;
  final int Function(Key)? findChildIndexCallback;
  final bool allowImplicitScrolling;
  final ScrollBehavior? scrollBehavior;
  final bool padEnds;
  final Query<Document>? recentDocQuery;
  final bool useDidUpdateWidget;
  final bool refreshUpdatedDocs;
  final Query<Document>? updatedDocQuery;
  final bool isRootTabel;
  final VoidCallback? resetUpdatedDocIds;
  final ProviderListenable<List<String>>? updatedDocsState;
  final bool useUid;
  final bool isSearchView;
  final bool isNoGridView;
  final String? searchWords;
  final bool isSliver;

  @override
  ConsumerState<SimplePageListView<Document>> createState() =>
      _SimplePageListViewState<Document>();
}

class _SimplePageListViewState<Document>
    extends ConsumerState<SimplePageListView<Document>>
    with WidgetsBindingObserver {
  late List<QueryDocumentSnapshot<Document>> docs = [];
  // Check if the first page of the list is being loaded
  // 리스트의 첫 페이지를 불러오는 중인지 확인
  late bool isFetching = false;
  // Check if the next page of the list is being loaded
  // 리스트의 다음 페이지를 불러오는 중인지 확인
  late bool isFetchingMore = false;
  // Check if there are more items to load
  // 더 불러올 아이템이 있는지 확인
  late bool hasMore = false;
  // Check if the list needs to be refreshed
  // 리스트의 새로고침이 필요할 경우 확인
  late int refreshTime = DateTime.now().millisecondsSinceEpoch;
  // Check if there is a main item at the top of the list
  // 리스트 최상단에 위치하는 메인 아이템이 있는지 확인
  late bool hasMain = false;
  // If blocked by firestore security rule
  // firestore security rule 에서 막혔을 경우
  late bool isPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    // Add an observer to detect app lifecycle events
    // 앱 생명주기 이벤트를 감지하기 위해 옵저버 추가
    WidgetsBinding.instance.addObserver(this);
    // Load the first page of the list
    // 리스트 첫 페이지 로딩
    if (!widget.isSearchView ||
        widget.isSearchView &&
            widget.searchWords != null &&
            widget.searchWords!.length > 1) {
      // Automatically load the first page only when it is not a search view
      // or when there is a search word in the search view.
      // 검색뷰가 아니거나 또는 검색뷰에서 검색어가 있는 경우에만 첫 페이지 자동 불러오기 실행
      // When entering the search view by clicking on the hashtag of the post
      // 포스트의 해시태그를 눌러 검색뷰에 진입했을 때
      _fechDocs();
    }
  }

  @override
  void dispose() {
    // Remove app lifecycle observer
    // 앱 생명주기 옵저버 제거
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Called when the app's lifecycle state changes
  // 앱의 생명주기 상태가 변경될 때 호출
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Called when the app moves from background to foreground
      // If the app has been in the background for more than 2 hours, reload the list
      // Otherwise, compare recent items and add only new items.
      // 앱이 백그라운드에서 포그라운드로 바뀔 경우 호출
      // 백그라운 상태로 앱이 2시간 이상 유지되었을 경우, 리스트 새로 불러오기
      // 그 외에, 최근 아이템을 비교해, 새로운 아이템들만 추가해 주기
      final pauseDurationInMinute = Duration(
              milliseconds: DateTime.now().millisecondsSinceEpoch - refreshTime)
          .inMinutes;
      if (pauseDurationInMinute > 120) {
        docs = [];
        _fechDocs();
      } else {
        _checkRecentDoc();
      }
    }
  }

  // Called when the parent widget changes its configuration and the widget needs to be rebuilt.
  // 부모 위젯이 구성을 변경하고, 위젯을 다시 build해야하는 경우에 호출
  // Called when parameter value changes in the connected StatefulWidget class
  // 연결된 StatefulWidget 클래스에서 파라미터 값이 변경되면 실행
  @override
  void didUpdateWidget(covariant SimplePageListView<Document> oldWidget) {
    // Only runs if useDidUpdateWidget is true and there is a search word in the search box.
    // useDidUpdateWidget가 참이고, 검색창에서 검색어가 있는 경우에만 실행
    if (widget.useDidUpdateWidget &&
        widget.isSearchView &&
        widget.searchWords != null &&
        widget.searchWords!.length > 1) {
      docs = [];
      _fechDocs();
    }
    // Only runs if useDidUpdateWidget is true, if this is not a search view, and if the query has changed
    // useDidUpdateWidget가 참이고, 검색창이 아니면서 쿼리가 변경된 경우에만 실행
    if (widget.useDidUpdateWidget &&
        !widget.isSearchView &&
        oldWidget.query != widget.query) {
      docs = [];
      _fechDocs();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _checkRecentDoc() async {
    // Implemented by comparing the most recent document
    // 현재 가장 최근 문서를 비교하는 방식으로 구현
    // The reason we used a recent document comparison method rather than a stream
    // is to minimize the number of times posts are loaded.
    // 스트림이 아닌 최근 문서 비교 방식을 사용한 이유는 새 글을 부르는 횟수를 최소화하기 위해
    try {
      if (widget.recentDocQuery != null) {
        final snapshot = await widget.recentDocQuery!.get();
        if (snapshot.docs.isNotEmpty && docs.isNotEmpty) {
          final recentDoc = snapshot.docs.first;
          // If hasMain, the length of docs is always at least 2.
          // hasMain인 경우 무조건 docs의 길이는 2 이상이다.
          final firstDoc = hasMain ? docs[1] : docs[0];
          if (recentDoc.id != firstDoc.id) {
            // Get the items after the most recent item in the current docs
            // 현재 docs의 가장 최근 아이템 후의 아이템들을 가져오기
            final recentSnapshot =
                await widget.query.endBeforeDocument(firstDoc).get();
            // Only fetch if there are 10 or fewer recent documents
            // 최근 문서가 10개 이하인 경우에만 가져오기
            if (recentSnapshot.docs.length <= listFetchLimit) {
              setState(() {
                // If there is a main item, add new posts after the main item
                // 메인 아이템이 있는 경우에는 메인 아이템 이후로 추가
                docs = hasMain
                    ? [docs.first, ...recentSnapshot.docs, ...docs.sublist(1)]
                    : [...recentSnapshot.docs, ...docs];
              });
            }
            // docs = [];
            // _fechDocs();
          }
        }
      }
    } catch (e) {
      debugPrint('checkRecentDoc error: $e');
    }
  }

  void _fetchNextPage() {
    // Executes when the last item in the list is visible and hasMore is true
    // 리스트의 마지막 아이템이 표시되고 hasMore가 참일 경우 실행
    if (isFetching || isFetchingMore || !hasMore) {
      // Stop if loading items or there are no items to load
      // 아이템을 불러오는 중이거나, 불러올 아이템이 없을 경우 중지
      return;
    }
    _fechDocs(nextPage: true);
  }

  Future<void> _fechDocs({bool nextPage = false}) async {
    try {
      QuerySnapshot<Document>? querySnapshot;
      QuerySnapshot<Document>? mainQuerySnapshot;
      // To save the first main item
      // 첫번째 메인 아이템을 저장하기 위해서
      QueryDocumentSnapshot<Document>? mainSnapshot;
      if (nextPage) {
        // when loading more
        // 로드 모어일 경우
        isFetchingMore = true;
      } else {
        // when first page
        // 첫 페이지를 경우
        isFetching = true;
        // If docs are reloaded, such as when refreshed, hasMain is also initialized again.
        // 새로 고침했을 경우와 같이 docs를 새로 부르면 hasMain도 다시 초기화
        hasMain = false;
      }
      Future.microtask(() => setState(() {}));
      if (nextPage) {
        // when loading more
        // 로드 모어일 경우
        querySnapshot = await widget.query
            .startAfterDocument(docs.last)
            .limit(listFetchLimit + 1)
            .get();
      } else {
        // when first page
        // 첫 페이지일 경우
        if (widget.mainQuery != null) {
          // when there is mainQuery
          // 메인쿼리가 존재할 경우
          // Execute the main query and basic query in parallel
          // 메인쿼리와 기본쿼리를 병렬로 실행
          Future<QuerySnapshot<Document>> futureMainQuerySnapshot =
              widget.mainQuery!.get();
          Future<QuerySnapshot<Document>> futureQuerySnapshot =
              widget.query.limit(listFetchLimit + 1).get();
          (mainQuerySnapshot, querySnapshot) =
              await (futureMainQuerySnapshot, futureQuerySnapshot).wait;
          if (mainQuerySnapshot.docs.isNotEmpty) {
            // If there is a document in the main query
            // 메인쿼리에 문서가 있을 경우
            mainSnapshot = mainQuerySnapshot.docs.first;
            hasMain = true;
          }
        } else {
          // when there is no main query
          // 메인쿼리가 없을 경우
          querySnapshot = await widget.query.limit(listFetchLimit + 1).get();
        }
        // Refresh by comparing refreshTime
        // refreshTime을 비교해 새로 고침
        // For example, if the user deletes a document, change the refreshTime.
        // 예를 들어 사용자가 문서를 삭제할 경우 refreshTime을 변경하고
        // Refresh the documents by comparing it to the existing refreshTime.
        // 기존의 refreshTime과 비교해 문서를 새로고침함
        refreshTime = DateTime.now().millisecondsSinceEpoch;
      }
      final result = mainSnapshot != null
          ? [mainSnapshot, ...querySnapshot.docs]
          : querySnapshot.docs;

      // If the number of documents in the basic query exceeds the limit,
      // change to a state where load more can be called.
      // 기본 쿼리의 문서수가 리미트를 초과할 경우 더 부르기 가능 상태로 변경
      if (querySnapshot.docs.length > listFetchLimit) {
        hasMore = true;
        result.removeLast();
      } else {
        hasMore = false;
      }
      docs = [...docs, ...result];
      // test empty table
      // 빈 창 테스트
      // docs = [];

      // update current page
      // 현재 창의 상태를 변경시킴
      setState(() {
        if (nextPage) {
          isFetchingMore = false;
        } else {
          isFetching = false;
        }
      });
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        setState(() {
          isPermissionDenied = true;
        });
        debugPrint('fetch docs error: ${e.toString()}');
      }
    }
  }

  // A function that updates only the document in question when the user modifies the document.
  // 사용자가 문서를 수정했을 경우 그 해당 문서만 업데이트해주는 함수
  // To minimize the number of reads from firestore and maintain scrolling state
  // firestore의 read수를 최소한으로 줄이고 스크롤 상태를 유지시키기 위해
  Future<void> updateDocs(List<String> updatedDocIds) async {
    if (docs.isNotEmpty && updatedDocIds.isNotEmpty) {
      // Document IDs modified by the user
      // 사용자가 수정한 문서 id들
      final docIds = List.from(docs.map((snapshot) => snapshot.id));
      for (final updatedDocId in updatedDocIds) {
        // If the current document list contains the modified document ID
        // 현재 문서리스트에 수정한 문서 id가 포함되어 있을 경우
        if (docIds.contains(updatedDocId)) {
          // Get updated information for modified documents
          // 수정된 문서의 업데이트 된 정보 가져오기
          final querySnapshot = await widget.updatedDocQuery!
              .where(widget.useUid ? 'uid' : 'id', isEqualTo: updatedDocId)
              .limit(1)
              .get();
          final newDoc =
              querySnapshot.docs.isNotEmpty ? querySnapshot.docs[0] : null;
          if (newDoc != null) {
            // Change existing document to updated document
            // 업데이트 된 문서로 기존 문서 변경
            docs = [
              for (final doc in docs)
                if (doc.id == updatedDocId) newDoc else doc
            ];
          }
        }
      }
      // Initialize the list to be modified when the update is finished
      // 업데이트가 끝날 경우 수정할 목록을 초기화
      widget.resetUpdatedDocIds?.call();
      if (mounted) {
        // Update the state of the current list
        // 현재 리스트의 상태 업데이트
        setState(() {});
      }

      /*
      if (widget.isRootTabel) {
        widget.resetUpdatedDocIds?.call();
        setState(() {});
      } else {
        setState(() {});
      }
      */
    }
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(appSettingsControllerProvider);
    final adminSettings = ref.watch(adminSettingsProvider);

    // wher user changes doc, refesh
    // listState의 값이 변경된 경우 리스트를 새로 고침
    // 문서를 삭제하거나, 풀투리프레시를 했을 경우
    if (widget.listState != null) {
      ref.listen(widget.listState!, (_, next) {
        if (next > refreshTime) {
          docs = [];
          _fechDocs();
        }
      });
    }

    // When a user edits a document (including likes and comments)
    // 사용자가 문서를 수정했을 경우 (좋아요, 댓글 포함)
    if (widget.refreshUpdatedDocs &&
        widget.updatedDocQuery != null &&
        widget.updatedDocsState != null) {
      ref.listen(widget.updatedDocsState!, (_, next) {
        dev.log('updatedDocs: $next');
        updateDocs(next);
      });
    }

    // when fist fetch loading
    if (isFetching && !isPermissionDenied) {
      return widget.isSliver
          ? SliverFillRemaining(
              child: ListLoadingWidget(
                loadingBuilder: widget.loadingBuilder,
              ),
            )
          : ListLoadingWidget(
              loadingBuilder: widget.loadingBuilder,
            );
    }

    // when doc is empty
    if (docs.isEmpty) {
      return widget.isSliver
          ? SliverFillRemaining(
              child: ListEmptyWidget(
                isPermissionDenied: isPermissionDenied,
                emptyBuilder: widget.emptyBuilder,
              ),
            )
          : ListEmptyWidget(
              isPermissionDenied: isPermissionDenied,
              emptyBuilder: widget.emptyBuilder,
            );
    }

    if (widget.isPage) {
      return PageView.builder(
        itemBuilder: _itemBuilder,
        itemCount: docs.length,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        controller: widget.pageController,
        physics: widget.physics,
        pageSnapping: widget.pageSnapping,
        onPageChanged: widget.onPageChanged,
        findChildIndexCallback: widget.findChildIndexCallback,
        dragStartBehavior: widget.dragStartBehavior,
        allowImplicitScrolling: widget.allowImplicitScrolling,
        restorationId: widget.restorationId,
        clipBehavior: widget.clipBehavior,
        scrollBehavior: widget.scrollBehavior,
        padEnds: widget.padEnds,
      );
    }

    final currentListType = adminSettings.showAppStyleOption
        ? PostsListType.values[appSettings.appStyle ?? 1]
        : adminSettings.postsListType;
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (currentListType == PostsListType.square &&
        screenWidth > pcWidthBreakpoint &&
        !widget.isSearchView &&
        !widget.isNoGridView) {
      return widget.isSliver
          ? widget.padding != null
              ? SliverPadding(
                  padding: widget.padding!,
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                    ),
                    itemBuilder: _itemBuilder,
                    itemCount: docs.length,
                    addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                    addRepaintBoundaries: widget.addRepaintBoundaries,
                    addSemanticIndexes: widget.addSemanticIndexes,
                  ),
                )
              : SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.0,
                    crossAxisSpacing: 12.0,
                  ),
                  itemBuilder: _itemBuilder,
                  itemCount: docs.length,
                  addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                  addRepaintBoundaries: widget.addRepaintBoundaries,
                  addSemanticIndexes: widget.addSemanticIndexes,
                )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
              ),
              itemBuilder: _itemBuilder,
              itemCount: docs.length,
              scrollDirection: widget.scrollDirection,
              reverse: widget.reverse,
              controller: widget.controller,
              primary: widget.primary,
              physics: widget.physics,
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
              addRepaintBoundaries: widget.addRepaintBoundaries,
              addSemanticIndexes: widget.addSemanticIndexes,
              cacheExtent: widget.cacheExtent,
              semanticChildCount: widget.semanticChildCount,
              dragStartBehavior: widget.dragStartBehavior,
              keyboardDismissBehavior: widget.keyboardDismissBehavior,
              restorationId: widget.restorationId,
              clipBehavior: widget.clipBehavior,
            );
    }
    return widget.isSliver
        ? widget.padding != null
            ? SliverPadding(
                padding: widget.padding!,
                sliver: SliverList.builder(
                  itemBuilder: _itemBuilder,
                  itemCount: docs.length,
                  addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                  addRepaintBoundaries: widget.addRepaintBoundaries,
                  addSemanticIndexes: widget.addSemanticIndexes,
                ),
              )
            : SliverList.builder(
                itemBuilder: _itemBuilder,
                itemCount: docs.length,
                addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                addRepaintBoundaries: widget.addRepaintBoundaries,
                addSemanticIndexes: widget.addSemanticIndexes,
              )
        : ListView.builder(
            itemBuilder: _itemBuilder,
            itemCount: docs.length,
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            controller: widget.controller,
            primary: widget.primary,
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap,
            padding: widget.padding,
            itemExtent: widget.itemExtent,
            prototypeItem: widget.prototypeItem,
            addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
            addRepaintBoundaries: widget.addRepaintBoundaries,
            addSemanticIndexes: widget.addSemanticIndexes,
            cacheExtent: widget.cacheExtent,
            semanticChildCount: widget.semanticChildCount,
            dragStartBehavior: widget.dragStartBehavior,
            keyboardDismissBehavior: widget.keyboardDismissBehavior,
            restorationId: widget.restorationId,
            clipBehavior: widget.clipBehavior,
          );
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    final isLastItem = index + 1 == docs.length;
    if (isLastItem && hasMore) _fetchNextPage();
    final doc = docs[index];
    return widget.itemBuilder(context, index, doc);
  }
}

class ListLoadingWidget extends StatelessWidget {
  const ListLoadingWidget({
    super.key,
    this.loadingBuilder,
  });

  final Widget Function(BuildContext)? loadingBuilder;

  @override
  Widget build(BuildContext context) {
    if (loadingBuilder != null) {
      return loadingBuilder!.call(context);
    }

    return const Center(child: CupertinoActivityIndicator());
  }
}

// 리스트에 아이템이 없을 경우 표시하는 위젯
class ListEmptyWidget extends StatelessWidget {
  const ListEmptyWidget({
    super.key,
    required this.isPermissionDenied,
    this.emptyBuilder,
  });

  final bool isPermissionDenied;
  final Widget Function(BuildContext)? emptyBuilder;
  // firestore security rule 에서 막혔을 경우

  @override
  Widget build(BuildContext context) {
    if (emptyBuilder != null) {
      if (isPermissionDenied) {
        return Text(context.loc.needPermission);
      }
      return emptyBuilder!.call(context);
    }

    return Center(
        child: Text(isPermissionDenied
            ? context.loc.needPermission
            : context.loc.noContent));
  }
}

/*
// 메인 헤더 아이템을 슬리버로 처리할 경우 하단 코드 사용
class SimplePageListView<Document> extends ConsumerStatefulWidget {
  const SimplePageListView({
    super.key,
    required this.query,
    required this.itemBuilder,
    this.isPage = false,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.listState,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.prototypeItem,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.pageController,
    this.pageSnapping = true,
    this.onPageChanged,
    this.findChildIndexCallback,
    this.allowImplicitScrolling = false,
    this.scrollBehavior,
    this.padEnds = true,
    this.recentDocQuery,
    this.useDidUpdateWidget = false,
    this.refreshUpdatedDocs = false,
    this.updatedDocQuery,
    this.isRootTabel = false,
    this.resetUpdatedDocIds,
    this.updatedDocsState,
    this.useUid = false,
    this.isSearchView = false,
    this.isNoGridView = false,
    this.searchWords,
    this.isSliver = false,
  });

  final Query<Document> query;
  final SimplePageListItemBuilder<Document> itemBuilder;
  final bool isPage;
  final SimplePageListLoadingBuilder? loadingBuilder;
  final SimplePageListErrorBuilder? errorBuilder;
  final SimplePageListEmptyBuilder? emptyBuilder;
  final ProviderListenable<int>? listState;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final Widget? prototypeItem;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final PageController? pageController;
  final bool pageSnapping;
  final void Function(int)? onPageChanged;
  final int Function(Key)? findChildIndexCallback;
  final bool allowImplicitScrolling;
  final ScrollBehavior? scrollBehavior;
  final bool padEnds;
  final Query<Document>? recentDocQuery;
  final bool useDidUpdateWidget;
  final bool refreshUpdatedDocs;
  final Query<Document>? updatedDocQuery;
  final bool isRootTabel;
  final VoidCallback? resetUpdatedDocIds;
  final ProviderListenable<List<String>>? updatedDocsState;
  final bool useUid;
  final bool isSearchView;
  final bool isNoGridView;
  final String? searchWords;
  final bool isSliver;

  @override
  ConsumerState<SimplePageListView<Document>> createState() =>
      _SimplePageListViewState<Document>();
}

class _SimplePageListViewState<Document>
    extends ConsumerState<SimplePageListView<Document>>
    with WidgetsBindingObserver {
  late List<QueryDocumentSnapshot<Document>> docs = [];
  // 리스트의 첫번째 페이지의 아이템들을 불러오는 중
  late bool isFetching = false;
  // 리스트의 첫 페이지 이후의 아이템들을 불러오는 중
  late bool isFetchingMore = false;
  // 더 불러올 아이템이 있을 경우
  late bool hasMore = false;
  // 리스트를 새로고침해야 할 경우 타임스탬프를 변경해서 가져옴
  late int refreshTime = DateTime.now().millisecondsSinceEpoch;
  // firestore security rule 에서 막혔을 경우
  late bool isPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    // 앱 생명주기 이벤트를 감지하기 위해 옵저버 추가
    WidgetsBinding.instance.addObserver(this);
    // 리스트 첫 페이지 로딩
    if (!widget.isSearchView ||
        widget.isSearchView &&
            widget.searchWords != null &&
            widget.searchWords!.length > 1) {
      // 검색창 제외 또는 검색창에서 검색어가 있는 경우
      _fechDocs();
    }
  }

  @override
  void dispose() {
    // 앱 생명주가 옵저버 제거
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // // 앱의 생명주기 상태가 변경될 때 호출
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 앱이 백그라운드에서 포그라운드로 바뀔 경우 호출
      _checkRecentDoc();
    }
  }

  // 부모 위젯이 구성을 변경하고, 위젯을 다시 build해야하는 경우에 호출
  // 연결된 StatefulWidget 클래스에서 파라미터 값이 변경되면 실행
  @override
  void didUpdateWidget(covariant SimplePageListView<Document> oldWidget) {
    // useDidUpdateWidget가 참이고, 검색창에서 검색어가 있는 경우에만 실행
    if (widget.useDidUpdateWidget &&
        widget.isSearchView &&
        widget.searchWords != null &&
        widget.searchWords!.length > 1) {
      docs = [];
      _fechDocs();
    }
    // useDidUpdateWidget가 참이고, 검색창이 아니면서 쿼리가 변경된 경우에만 실행
    if (widget.useDidUpdateWidget &&
        !widget.isSearchView &&
        oldWidget.query != widget.query) {
      docs = [];
      _fechDocs();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _checkRecentDoc() async {
    // 현재 가장 최근 문서를 비교하는 방식으로 구현
    // 스트림이 아닌 최근 문서 비교 방식을 사용한 이유는 새 글을 부르는 횟수를 최소화하기 위해
    try {
      if (widget.recentDocQuery != null) {
        final snapshot = await widget.recentDocQuery!.get();
        if (snapshot.docs.isNotEmpty && docs.isNotEmpty) {
          final recentDoc = snapshot.docs.first;
          if (recentDoc.id != docs[0].id) {
            // 현재 docs의 가장 최근 아이템 후의 아이템들을 가져오기
            final recentSnapshot =
                await widget.query.endBeforeDocument(docs.first).get();
            // 최근 문서가 10개 이하인 경우에만 가져오기
            if (recentSnapshot.docs.length <= listFetchLimit) {
              setState(() {
                docs = [...recentSnapshot.docs, ...docs];
              });
            }
            // docs = [];
            // _fechDocs();
          }
        }
      }
    } catch (e) {
      debugPrint('checkRecentDoc error: $e');
    }
  }

  void _fetchNextPage() {
    // 리스트의 마지막 아이템이 표시되고 hasMore가 참일 경우 실행
    if (isFetching || isFetchingMore || !hasMore) {
      // 아이템을 불러오는 중이거나, 불러올 아이템이 없을 경우 중지
      return;
    }
    _fechDocs(nextPage: true);
  }

  Future<void> _fechDocs({bool nextPage = false}) async {
    try {
      QuerySnapshot<Document>? querySnapshot;
      if (nextPage) {
        isFetchingMore = true;
      } else {
        isFetching = true;
      }
      Future.microtask(() => setState(() {}));
      if (nextPage) {
        querySnapshot = await widget.query
            .startAfterDocument(docs.last)
            .limit(listFetchLimit + 1)
            .get();
      } else {
        querySnapshot = await widget.query.limit(listFetchLimit + 1).get();
        refreshTime = DateTime.now().millisecondsSinceEpoch;
      }
      final result = querySnapshot.docs;

      if (result.length > listFetchLimit) {
        hasMore = true;
        result.removeLast();
      } else {
        hasMore = false;
      }
      docs = [...docs, ...result];

      setState(() {
        if (nextPage) {
          isFetchingMore = false;
        } else {
          isFetching = false;
        }
      });
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        setState(() {
          isPermissionDenied = true;
        });
        debugPrint('fetch docs error: ${e.toString()}');
      }
    }
  }

  Future<void> updateDocs(List<String> updatedDocIds) async {
    if (docs.isNotEmpty && updatedDocIds.isNotEmpty) {
      final docIds = List.from(docs.map((snapshot) => snapshot.id));
      for (final updatedDocId in updatedDocIds) {
        if (docIds.contains(updatedDocId)) {
          final querySnapshot = await widget.updatedDocQuery!
              .where(widget.useUid ? 'uid' : 'id', isEqualTo: updatedDocId)
              .limit(1)
              .get();
          final newDoc =
              querySnapshot.docs.isNotEmpty ? querySnapshot.docs[0] : null;
          if (newDoc != null) {
            docs = [
              for (final doc in docs)
                if (doc.id == updatedDocId) newDoc else doc
            ];
          }
        }
      }
      widget.resetUpdatedDocIds?.call();
      if (mounted) {
        setState(() {});
      }

      /*
      if (widget.isRootTabel) {
        widget.resetUpdatedDocIds?.call();
        setState(() {});
      } else {
        setState(() {});
      }
      */
    }
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(appSettingsControllerProvider);
    final adminSettings = ref.watch(adminSettingsProvider);

    // wher user changes doc, refesh
    if (widget.listState != null) {
      ref.listen(widget.listState!, (_, next) {
        if (next > refreshTime) {
          docs = [];
          _fechDocs();
        }
      });
    }

    if (widget.refreshUpdatedDocs &&
        widget.updatedDocQuery != null &&
        widget.updatedDocsState != null) {
      ref.listen(widget.updatedDocsState!, (_, next) {
        dev.log('updatedDocs: $next');
        updateDocs(next);
      });
    }

    // when fist fetch loading
    if (isFetching && !isPermissionDenied) {
      return widget.isSliver
          ? SliverToBoxAdapter(
              child: ListLoadingWidget(
                loadingBuilder: widget.loadingBuilder,
              ),
            )
          : ListLoadingWidget(
              loadingBuilder: widget.loadingBuilder,
            );
    }

    // when doc is empty
    if (docs.isEmpty) {
      return widget.isSliver
          ? SliverToBoxAdapter(
              child: ListEmptyWidget(
                isPermissionDenied: isPermissionDenied,
                emptyBuilder: widget.emptyBuilder,
              ),
            )
          : ListEmptyWidget(
              isPermissionDenied: isPermissionDenied,
              emptyBuilder: widget.emptyBuilder,
            );
    }

    if (widget.isPage) {
      return PageView.builder(
        itemBuilder: _itemBuilder,
        itemCount: docs.length,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        controller: widget.pageController,
        physics: widget.physics,
        pageSnapping: widget.pageSnapping,
        onPageChanged: widget.onPageChanged,
        findChildIndexCallback: widget.findChildIndexCallback,
        dragStartBehavior: widget.dragStartBehavior,
        allowImplicitScrolling: widget.allowImplicitScrolling,
        restorationId: widget.restorationId,
        clipBehavior: widget.clipBehavior,
        scrollBehavior: widget.scrollBehavior,
        padEnds: widget.padEnds,
      );
    }

    final currentListType = adminSettings.showAppStyleOption
        ? PostsListType.values[appSettings.appStyle ?? 1]
        : adminSettings.postsListType;
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (currentListType == PostsListType.square &&
        screenWidth > pcWidthBreakpoint &&
        !widget.isSearchView &&
        !widget.isNoGridView) {
      return widget.isSliver
          ? widget.padding != null
              ? SliverPadding(
                  padding: widget.padding!,
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                    ),
                    itemBuilder: _itemBuilder,
                    itemCount: docs.length,
                    addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                    addRepaintBoundaries: widget.addRepaintBoundaries,
                    addSemanticIndexes: widget.addSemanticIndexes,
                  ),
                )
              : SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.0,
                    crossAxisSpacing: 12.0,
                  ),
                  itemBuilder: _itemBuilder,
                  itemCount: docs.length,
                  addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                  addRepaintBoundaries: widget.addRepaintBoundaries,
                  addSemanticIndexes: widget.addSemanticIndexes,
                )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
              ),
              itemBuilder: _itemBuilder,
              itemCount: docs.length,
              scrollDirection: widget.scrollDirection,
              reverse: widget.reverse,
              controller: widget.controller,
              primary: widget.primary,
              physics: widget.physics,
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
              addRepaintBoundaries: widget.addRepaintBoundaries,
              addSemanticIndexes: widget.addSemanticIndexes,
              cacheExtent: widget.cacheExtent,
              semanticChildCount: widget.semanticChildCount,
              dragStartBehavior: widget.dragStartBehavior,
              keyboardDismissBehavior: widget.keyboardDismissBehavior,
              restorationId: widget.restorationId,
              clipBehavior: widget.clipBehavior,
            );
    }
    return widget.isSliver
        ? widget.padding != null
            ? SliverPadding(
                padding: widget.padding!,
                sliver: SliverList.builder(
                  itemBuilder: _itemBuilder,
                  itemCount: docs.length,
                  addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                  addRepaintBoundaries: widget.addRepaintBoundaries,
                  addSemanticIndexes: widget.addSemanticIndexes,
                ),
              )
            : SliverList.builder(
                itemBuilder: _itemBuilder,
                itemCount: docs.length,
                addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                addRepaintBoundaries: widget.addRepaintBoundaries,
                addSemanticIndexes: widget.addSemanticIndexes,
              )
        : ListView.builder(
            itemBuilder: _itemBuilder,
            itemCount: docs.length,
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            controller: widget.controller,
            primary: widget.primary,
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap,
            padding: widget.padding,
            itemExtent: widget.itemExtent,
            prototypeItem: widget.prototypeItem,
            addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
            addRepaintBoundaries: widget.addRepaintBoundaries,
            addSemanticIndexes: widget.addSemanticIndexes,
            cacheExtent: widget.cacheExtent,
            semanticChildCount: widget.semanticChildCount,
            dragStartBehavior: widget.dragStartBehavior,
            keyboardDismissBehavior: widget.keyboardDismissBehavior,
            restorationId: widget.restorationId,
            clipBehavior: widget.clipBehavior,
          );
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    final isLastItem = index + 1 == docs.length;
    if (isLastItem && hasMore) _fetchNextPage();
    final doc = docs[index];
    return widget.itemBuilder(context, index, doc);
  }
}
*/
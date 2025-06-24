import 'dart:async';
import 'dart:developer' as dev;

// flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

// external
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/app_settings/app_settings_controller.dart';
import 'package:applimode_app/src/core/constants/constants.dart';

// utils
import 'package:applimode_app/src/utils/safe_build_call.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/list_empty_widget.dart';
import 'package:applimode_app/src/common_widgets/list_loading_widget.dart';

// features
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';

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
    this.refreshUpdatedDoc = false,
    this.updatedDocQuery,
    this.isRootTabel = false,
    // this.resetUpdatedDocIds,
    this.updatedDocState,
    this.useUid = false,
    this.isSearchView = false,
    this.isNoGridView = false,
    this.searchWords,
    this.isSliver = false,
    this.isLiveUpdate = false,
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
  final bool refreshUpdatedDoc;
  final Query<Document>? updatedDocQuery;
  final bool isRootTabel;
  // final VoidCallback? resetUpdatedDocIds;
  final ProviderListenable<String?>? updatedDocState;
  final bool useUid;
  final bool isSearchView;
  final bool isNoGridView;
  final String? searchWords;
  final bool isSliver;
  final bool isLiveUpdate;

  @override
  ConsumerState<SimplePageListView<Document>> createState() =>
      _SimplePageListViewState<Document>();
}

class _SimplePageListViewState<Document>
    extends ConsumerState<SimplePageListView<Document>>
    with WidgetsBindingObserver {
  List<QueryDocumentSnapshot<Document>> _docs = [];
  // Check if the first page of the list is being loaded
  // 리스트의 첫 페이지를 불러오는 중인지 확인
  bool _isFetching = false;
  // Check if the next page of the list is being loaded
  // 리스트의 다음 페이지를 불러오는 중인지 확인
  bool _isFetchingMore = false;
  // Check if there are more items to load
  // 더 불러올 아이템이 있는지 확인
  bool _hasMore = false;
  // Check if the list needs to be refreshed
  // 리스트의 새로고침이 필요할 경우 확인
  int _refreshTime = DateTime.now().millisecondsSinceEpoch;
  // Check if there is a main item at the top of the list
  // 리스트 최상단에 위치하는 메인 아이템이 있는지 확인
  bool _hasMain = false;
  // If blocked by firestore security rule
  // firestore security rule 에서 막혔을 경우
  bool _isPermissionDenied = false;

  bool _isCancelled = false;

  StreamSubscription? _liveSubscription;

  Timer? _debounceTimer;

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
      _fetchDocs();
    }
    if (widget.controller != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.controller!.addListener(_scrollListener);
      });
    }
  }

  @override
  void dispose() {
    _isCancelled = true;
    _liveSubscription?.cancel();
    // Remove app lifecycle observer
    // 앱 생명주기 옵저버 제거
    WidgetsBinding.instance.removeObserver(this);
    widget.controller?.removeListener(_scrollListener);
    _debounceTimer?.cancel();
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
      if (!_isFetching || !_isFetchingMore) {
        final pauseDurationInMinute = Duration(
                milliseconds:
                    DateTime.now().millisecondsSinceEpoch - _refreshTime)
            .inMinutes;
        if (pauseDurationInMinute > 120) {
          // docs = [];
          _fetchDocs();
        } else if (pauseDurationInMinute > 1) {
          if (_docs.isEmpty) {
            // docs = [];
            _fetchDocs();
          } else {
            _checkRecentDoc();
          }
        }
      }
    }
  }

  // Called when the parent widget changes its configuration and the widget needs to be rebuilt.
  // 부모 위젯이 구성을 변경하고, 위젯을 다시 build해야하는 경우에 호출
  // Called when parameter value changes in the connected StatefulWidget class
  // 연결된 StatefulWidget 클래스에서 파라미터 값이 변경되면 실행
  @override
  void didUpdateWidget(covariant SimplePageListView<Document> oldWidget) {
    if (widget.useDidUpdateWidget) {
      if (widget.isSearchView) {
        if (widget.searchWords != null &&
            widget.searchWords!.length > 1 &&
            oldWidget.searchWords != widget.searchWords) {
          // docs = [];
          _fetchDocs();
        }
      } else {
        if (oldWidget.query != widget.query) {
          // docs = [];
          _fetchDocs();
        }
      }
    }
    if (widget.controller != null) {
      if (widget.controller != oldWidget.controller) {
        oldWidget.controller?.removeListener(_scrollListener);
        widget.controller?.addListener(_scrollListener);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void _scrollListener() {
    if (_isFetching || _isFetchingMore || !_hasMore) return;
    if (widget.controller != null) {
      final position = widget.controller!.position;
      if (position.pixels >= (position.maxScrollExtent - 50)) {
        _fetchNextPage();
      }
    }
  }

  void _debounceSetState(VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), callback);
  }

  Future<void> _checkRecentDoc() async {
    // Implemented by comparing the most recent document
    // 현재 가장 최근 문서를 비교하는 방식으로 구현
    // The reason we used a recent document comparison method rather than a stream
    // is to minimize the number of times posts are loaded.
    // 스트림이 아닌 최근 문서 비교 방식을 사용한 이유는 새 글을 부르는 횟수를 최소화하기 위해
    if (_isCancelled || _isFetching || _isFetchingMore) return;
    try {
      if (widget.recentDocQuery != null) {
        final snapshot = await widget.recentDocQuery!.get();
        if (snapshot.docs.isNotEmpty && _docs.isNotEmpty) {
          final recentDoc = snapshot.docs.first;
          // If hasMain, the length of docs is always at least 2.
          // hasMain인 경우 무조건 docs의 길이는 2 이상이다.
          final firstDoc = _hasMain ? _docs[1] : _docs[0];
          if (recentDoc.id != firstDoc.id) {
            // Get the items after the most recent item in the current docs
            // 현재 docs의 가장 최근 아이템 후의 아이템들을 가져오기
            final recentSnapshot =
                await widget.query.endBeforeDocument(firstDoc).get();
            // Only fetch if there are 10 or fewer recent documents
            // 최근 문서가 10개 이하인 경우에만 가져오기
            if (recentSnapshot.docs.length <= listFetchLimit) {
              if (_isCancelled) return;
              if (mounted) {
                safeBuildCall(() {
                  setState(() {
                    // If there is a main item, add new posts after the main item
                    // 메인 아이템이 있는 경우에는 메인 아이템 이후로 추가
                    _docs = _hasMain
                        ? [
                            _docs.first,
                            ...recentSnapshot.docs,
                            ..._docs.sublist(1)
                          ]
                        : [...recentSnapshot.docs, ..._docs];
                  });
                });
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('checkRecentDoc error: $e');
    }
  }

  Future<void> _setLiveUpdate() async {
    if (_isCancelled || widget.recentDocQuery != null) return;
    try {
      final latestDocQuery = widget.query.limit(1);
      _liveSubscription = latestDocQuery.snapshots().listen((event) async {
        if (_isFetching || _isFetchingMore) return;
        if (_docs.isEmpty) {
          // there is no doc in list
          // cancel when there is no doc in event
          if (event.docs.isEmpty || _isCancelled) return;
          if (mounted) {
            safeBuildCall(() {
              setState(() {
                _docs = event.docs;
              });
            });
          }
        } else {
          // there are docs in list
          final firstDoc = _hasMain ? _docs[1] : _docs[0];
          final recentSnapshot =
              await widget.query.endBeforeDocument(firstDoc).get();
          if (_isCancelled || recentSnapshot.docs.isEmpty) return;
          final existingDocIds = _docs.map((doc) => doc.id).toSet();
          final newDocs = recentSnapshot.docs
              .where((doc) => !existingDocIds.contains(doc.id))
              .toList();
          if (_isCancelled) return;
          if (mounted) {
            _debounceSetState(() {
              safeBuildCall(() {
                setState(() {
                  // If there is a main item, add new posts after the main item
                  // 메인 아이템이 있는 경우에는 메인 아이템 이후로 추가
                  _docs = _hasMain
                      ? [_docs.first, ...newDocs, ..._docs.sublist(1)]
                      : [...newDocs, ..._docs];
                });
              });
            });
          }
        }
      });
    } catch (e) {
      debugPrint('setLiveUpdate error: $e');
    }
  }

  void _fetchNextPage() {
    // Executes when the last item in the list is visible and hasMore is true
    // 리스트의 마지막 아이템이 표시되고 hasMore가 참일 경우 실행
    if (_isFetching || _isFetchingMore || !_hasMore) {
      // Stop if loading items or there are no items to load
      // 아이템을 불러오는 중이거나, 불러올 아이템이 없을 경우 중지
      return;
    }
    _fetchDocs(nextPage: true);
  }

  Future<void> _fetchDocs({bool nextPage = false}) async {
    if (_isCancelled) return;
    try {
      QuerySnapshot<Document>? querySnapshot;
      QuerySnapshot<Document>? mainQuerySnapshot;
      // To save the first main item
      // 첫번째 메인 아이템을 저장하기 위해서
      QueryDocumentSnapshot<Document>? mainSnapshot;
      if (nextPage) {
        // when loading more
        // 로드 모어일 경우
        _isFetchingMore = true;
      } else {
        _liveSubscription?.cancel();
        _docs.clear();
        // when first page
        // 첫 페이지를 경우
        _isFetching = true;
        // If docs are reloaded, such as when refreshed, hasMain is also initialized again.
        // 새로 고침했을 경우와 같이 docs를 새로 부르면 hasMain도 다시 초기화
        _hasMain = false;
        if (mounted) {
          safeBuildCall(() => setState(() {}));
          /*
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });
          */
        }
      }

      /*
      Future.microtask(() => setState(() {}));
      */
      if (nextPage) {
        // when loading more
        // 로드 모어일 경우
        querySnapshot = await widget.query
            .startAfterDocument(_docs.last)
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
            _hasMain = true;
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
        _refreshTime = DateTime.now().millisecondsSinceEpoch;
      }
      final result = mainSnapshot != null
          ? [mainSnapshot, ...querySnapshot.docs]
          : querySnapshot.docs;

      // If the number of documents in the basic query exceeds the limit,
      // change to a state where load more can be called.
      // 기본 쿼리의 문서수가 리미트를 초과할 경우 더 부르기 가능 상태로 변경
      if (querySnapshot.docs.length > listFetchLimit) {
        _hasMore = true;
        result.removeLast();
      } else {
        _hasMore = false;
      }
      _docs = [..._docs, ...result];
      // test empty table
      // 빈 창 테스트
      // docs.clear();

      // update current page
      // 현재 창의 상태를 변경시킴
      if (_isCancelled) return;
      if (mounted) {
        safeBuildCall(() {
          setState(() {
            _isFetching = false;
            _isFetchingMore = false;
          });
        });
      }
      if (widget.isLiveUpdate && widget.recentDocQuery == null && !nextPage) {
        _setLiveUpdate();
      }
      /*
      setState(() {
        if (nextPage) {
          isFetchingMore = false;
        } else {
          isFetching = false;
        }
      });
      */
    } catch (e) {
      if (_isCancelled) return;
      if (e.toString().contains('permission-denied') && mounted) {
        safeBuildCall(() {
          setState(() {
            _isPermissionDenied = true;
          });
        });
        debugPrint('fetch docs error: ${e.toString()}');
      }
    }
  }

  // A function that updates only the document in question when the user modifies the document.
  // 사용자가 문서를 수정했을 경우 그 해당 문서만 업데이트해주는 함수
  // To minimize the number of reads from firestore and maintain scrolling state
  // firestore의 read수를 최소한으로 줄이고 스크롤 상태를 유지시키기 위해
  Future<void> _updateDocs(String updatedDocId) async {
    if (_isCancelled) return;
    try {
      if (_docs.isNotEmpty) {
        // Document IDs modified by the user
        // 사용자가 수정한 문서 id들
        final docIds = List.from(_docs.map((snapshot) => snapshot.id));
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
          if (newDoc == null) {
            // 사용자가 문서를 삭제했을 경우 로컬에서 변경
            _docs = _docs.where((doc) => doc.id != updatedDocId).toList();
          } else {
            // Change existing document to updated document
            // 업데이트 된 문서로 기존 문서 변경
            _docs = [
              for (final doc in _docs)
                if (doc.id == updatedDocId) newDoc else doc
            ];
          }
          /*
            if (newDoc != null) {
              // Change existing document to updated document
              // 업데이트 된 문서로 기존 문서 변경
              docs = [
                for (final doc in docs)
                  if (doc.id == updatedDocId) newDoc else doc
              ];
            }
            */
        }
        if (_isCancelled) return;
        if (mounted) {
          // Update the state of the current list
          // 현재 리스트의 상태 업데이트
          safeBuildCall(() => setState(() {}));
        }
        // Initialize the list to be modified when the update is finished
        // 업데이트가 끝날 경우 수정할 목록을 초기화
        // widget.resetUpdatedDocIds?.call();
      }
    } catch (e) {
      debugPrint('updateDocs error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    dev.log('docs: ${_docs.length}');
    final appSettings = ref.watch(appSettingsControllerProvider);
    final adminSettings = ref.watch(adminSettingsProvider);

    // wher user changes doc, refesh
    // listState의 값이 변경된 경우 리스트를 새로 고침
    // 문서를 삭제하거나, 풀투리프레시를 했을 경우
    if (widget.listState != null) {
      ref.listen(widget.listState!, (_, next) {
        if (next > _refreshTime && !_isFetching && !_isFetchingMore) {
          // docs = [];
          _fetchDocs();
        }
      });
    }

    // When a user edits a document (including likes and comments)
    // 사용자가 문서를 수정했을 경우 (좋아요, 댓글 포함)
    if (widget.refreshUpdatedDoc &&
        widget.updatedDocQuery != null &&
        widget.updatedDocState != null) {
      ref.listen(widget.updatedDocState!, (_, next) {
        dev.log('updatedDocs: $next');
        if (next != null) {
          _updateDocs(next);
        }
      });
    }

    // when fist fetch loading
    if (_isFetching && !_isPermissionDenied) {
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
    if (_docs.isEmpty) {
      dev.log('doc is empty');
      return widget.isSliver
          ? SliverFillRemaining(
              child: ListEmptyWidget(
                isPermissionDenied: _isPermissionDenied,
                emptyBuilder: widget.emptyBuilder,
              ),
            )
          : ListEmptyWidget(
              isPermissionDenied: _isPermissionDenied,
              emptyBuilder: widget.emptyBuilder,
            );
    }

    if (widget.isPage) {
      return PageView.builder(
        itemBuilder: _itemBuilder,
        itemCount: _docs.length,
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
                    itemCount: _docs.length,
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
                  itemCount: _docs.length,
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
              itemCount: _docs.length,
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
                  itemCount: _docs.length,
                  addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                  addRepaintBoundaries: widget.addRepaintBoundaries,
                  addSemanticIndexes: widget.addSemanticIndexes,
                ),
              )
            : SliverList.builder(
                itemBuilder: _itemBuilder,
                itemCount: _docs.length,
                addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                addRepaintBoundaries: widget.addRepaintBoundaries,
                addSemanticIndexes: widget.addSemanticIndexes,
              )
        : ListView.builder(
            itemBuilder: _itemBuilder,
            itemCount: _docs.length,
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
    if (widget.controller == null) {
      final isLastItem = index + 1 == _docs.length;
      if (isLastItem && _hasMore) _fetchNextPage();
    }
    final doc = _docs[index];
    return widget.itemBuilder(context, index, doc);
  }
}

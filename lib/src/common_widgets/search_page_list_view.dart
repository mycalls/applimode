import 'dart:developer' as dev;

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/common_widgets/list_empty_widget.dart';
import 'package:applimode_app/src/common_widgets/list_loading_widget.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SearchPageListItemBuilder<Document> = Widget Function(
  BuildContext context,
  int index,
  DocumentSnapshot<Document> doc,
);

typedef SearchPageListLoadingBuilder = Widget Function(BuildContext context);

typedef SearchPageListErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace stackTrace,
);

typedef SearchPageListEmptyBuilder = Widget Function(BuildContext context);

class SearchPageListView<Document> extends ConsumerStatefulWidget {
  const SearchPageListView({
    super.key,
    required this.searchWords,
    required this.searchQuery,
    required this.query,
    required this.itemBuilder,
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
    this.useDidUpdateWidget = false,
    this.refreshUpdatedDoc = false,
    // this.resetUpdatedDocIds,
    this.updatedDocState,
    this.useUid = false,
    this.isSliver = false,
  });

  final String searchWords;
  final Future<List<String>> Function(String) searchQuery;
  final DocumentReference<Document> Function(String) query;
  final SearchPageListItemBuilder<Document> itemBuilder;
  final SearchPageListLoadingBuilder? loadingBuilder;
  final SearchPageListErrorBuilder? errorBuilder;
  final SearchPageListEmptyBuilder? emptyBuilder;
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
  final bool useDidUpdateWidget;
  final bool refreshUpdatedDoc;
  // final VoidCallback? resetUpdatedDocIds;
  final ProviderListenable<String?>? updatedDocState;
  final bool useUid;
  final bool isSliver;

  @override
  ConsumerState<SearchPageListView<Document>> createState() =>
      _SearchPageListViewState<Document>();
}

class _SearchPageListViewState<Document>
    extends ConsumerState<SearchPageListView<Document>>
    with WidgetsBindingObserver {
  List<DocumentSnapshot<Document>> docs = [];
  List<String> pids = [];
  bool isFetching = false;
  bool isFetchingMore = false;
  bool hasMore = false;
  int refreshTime = DateTime.now().millisecondsSinceEpoch;
  bool hasMain = false;
  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    if (widget.searchWords.trim().length > 1) {
      _fechDocs();
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
    widget.controller?.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SearchPageListView<Document> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.useDidUpdateWidget &&
        widget.searchWords.trim().length > 1 &&
        oldWidget.searchWords != widget.searchWords) {
      _fechDocs();
    }
    if (widget.controller != null) {
      if (widget.controller != oldWidget.controller) {
        oldWidget.controller?.removeListener(_scrollListener);
        widget.controller?.addListener(_scrollListener);
      }
    }
  }

  void _scrollListener() {
    if (isFetching || isFetchingMore || !hasMore) return;
    if (widget.controller != null) {
      final position = widget.controller!.position;
      if (position.pixels >= (position.maxScrollExtent - 50)) {
        _fetchNextPage();
      }
    }
  }

  void _fetchNextPage() {
    if (isFetching || isFetchingMore || !hasMore) {
      return;
    }
    _fechDocs(nextPage: true);
  }

  Future<void> _fechDocs({bool nextPage = false}) async {
    if (_isCancelled || widget.searchWords.length < 2) return;
    try {
      if (nextPage) {
        isFetchingMore = true;
      } else {
        pids.clear();
        docs.clear();
        isFetching = true;
        if (mounted) {
          safeBuildCall(() => setState(() {}));
        }
      }
      if (nextPage) {
        dev.log('fetch search next page');
        final lastIndex = pids.length > docs.length + listFetchLimit
            ? docs.length + listFetchLimit
            : pids.length;

        final futures = pids
            .sublist(docs.length, lastIndex)
            .map((pid) => widget.query(pid).get());
        final snapshots = await Future.wait(futures);
        docs.addAll(snapshots);

        /*
        for (final pid in pids.sublist(docs.length, lastIndex)) {
          final snapshot = await widget.query(pid).get();
          docs.add(snapshot);
        }
        */
      } else {
        dev.log('fetch search initial page');
        pids = await widget.searchQuery(widget.searchWords);
        final lastIndex =
            pids.length > listFetchLimit ? listFetchLimit : pids.length;

        final futures =
            pids.sublist(0, lastIndex).map((pid) => widget.query(pid).get());
        final snapshots = await Future.wait(futures);
        docs.addAll(snapshots);
        /*
        for (final pid in pids.sublist(0, lastIndex)) {
          final snapshot = await widget.query(pid).get();
          docs.add(snapshot);
        }
        */

        refreshTime = DateTime.now().millisecondsSinceEpoch;
      }

      if (pids.length > docs.length) {
        hasMore = true;
        dev.log('hasMore: $hasMore');
      } else {
        hasMore = false;
        dev.log('hasMore: $hasMore');
      }

      if (_isCancelled) return;
      if (mounted) {
        safeBuildCall(() {
          setState(() {
            isFetchingMore = false;
            isFetching = false;
          });
        });
      }
    } catch (e) {
      debugPrint('fetch docs error: ${e.toString()}');
    }
  }

  Future<void> _updateDocs(String updatedDocId) async {
    if (_isCancelled) return;
    try {
      if (docs.isNotEmpty) {
        final docIds = List.from(docs.map((snapshot) => snapshot.id));
        if (docIds.contains(updatedDocId)) {
          final newDoc = await widget.query(updatedDocId).get();
          if (newDoc.data() == null) {
            docs = docs.where((doc) => doc.id != updatedDocId).toList();
          } else {
            docs = [
              for (final doc in docs)
                if (doc.id == updatedDocId) newDoc else doc
            ];
          }
        }
        if (_isCancelled) return;
        if (mounted) {
          safeBuildCall(() => setState(() {}));
        }
        // widget.resetUpdatedDocIds?.call();
      }
    } catch (e) {
      debugPrint('updateDocs error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    dev.log('searchDocs: ${docs.length}');
    // wher user changes doc, refesh
    if (widget.listState != null) {
      ref.listen(widget.listState!, (_, next) {
        if (next > refreshTime && !isFetching && !isFetchingMore) {
          // docs = [];
          _fechDocs();
        }
      });
    }

    if (widget.refreshUpdatedDoc && widget.updatedDocState != null) {
      ref.listen(widget.updatedDocState!, (_, next) {
        dev.log('updatedDocs: $next');
        if (next != null) {
          _updateDocs(next);
        }
      });
    }

    // when fist fetch loading
    if (isFetching) {
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
      dev.log('doc is empty');
      return widget.isSliver
          ? SliverFillRemaining(
              child: ListEmptyWidget(
                isPermissionDenied: false,
                emptyBuilder: widget.emptyBuilder,
              ),
            )
          : ListEmptyWidget(
              isPermissionDenied: false,
              emptyBuilder: widget.emptyBuilder,
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
    if (widget.controller == null) {
      final isLastItem = index + 1 == docs.length;
      if (isLastItem && hasMore) _fetchNextPage();
    }
    final doc = docs[index];
    return widget.itemBuilder(context, index, doc);
  }
}

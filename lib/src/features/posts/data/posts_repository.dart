import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_repository.g.dart';

class PostsRepository {
  const PostsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const limit = listFetchLimit;
  static const mainLimit = mainFetchLimit;
  static String postsPath() => 'posts';
  static String postPath(String id) => 'posts/$id';

  Future<void> createPost({
    required String id,
    required String uid,
    required String content,
    required String title,
    bool needUpdate = false,
    bool isLongContent = false,
    bool isHeader = false,
    bool isNoTitle = false,
    bool isNoWriter = false,
    int category = 0,
    String? mainImageUrl,
    String? mainVideoUrl,
    String? mainVideoImageUrl,
    List<String> tags = const [],
    required DateTime createdAt,
  }) =>
      _firestore.doc(postPath(id)).set({
        'id': id,
        'uid': uid,
        'content': content,
        'title': title,
        'needUpdate': needUpdate,
        'isLongContent': isLongContent,
        'isHeader': isHeader,
        'isBlock': false,
        'isRecommended': false,
        'isNoTitle': isNoTitle,
        'isNoWriter': isNoWriter,
        'category': category,
        'mainImageUrl': mainImageUrl,
        'mainVideoUrl': mainVideoUrl,
        'mainVideoImageUrl': mainVideoImageUrl,
        'tags': tags,
        'postCommentCount': 0,
        'viewCount': 0,
        'likeCount': 0,
        'dislikeCount': 0,
        'sumCount': 0,
        'reportCount': 0,
        'day': Format.yearMonthDayToInt(DateTime.now()),
        'month': Format.yearMonthToInt(DateTime.now()),
        'year': DateTime.now().year,
        'createdAt': createdAt.millisecondsSinceEpoch,
      });

  Future<void> updatePost({
    required String id,
    // required String uid,
    required String content,
    required String title,
    bool needUpdate = false,
    bool isLongContent = false,
    // bool isHeader = false,
    bool isNoTitle = false,
    bool isNoWriter = false,
    int category = 0,
    String? mainImageUrl,
    String? mainVideoUrl,
    String? mainVideoImageUrl,
    List<String> tags = const [],
    required DateTime updatedAt,
  }) =>
      _firestore.doc(postPath(id)).update({
        // 'id': id,
        // 'uid': uid,
        'content': content,
        'title': title,
        'needUpdate': needUpdate,
        'isLongContent': isLongContent,
        // 'isHeader': isHeader,
        'isNoTitle': isNoTitle,
        'isNoWriter': isNoWriter,
        'category': category,
        'mainImageUrl': mainImageUrl,
        'mainVideoUrl': mainVideoUrl,
        'mainVideoImageUrl': mainVideoImageUrl,
        'tags': tags,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      });

  Future<void> blockPost(String id) => _firestore.doc(postPath(id)).update({
        'isBlock': true,
      });

  Future<void> unblockPost(String id) => _firestore.doc(postPath(id)).update({
        'isBlock': false,
      });

  Future<void> recommendPost(String id) => _firestore.doc(postPath(id)).update({
        'isRecommended': true,
      });

  Future<void> unrecommendPost(String id) =>
      _firestore.doc(postPath(id)).update({
        'isRecommended': false,
      });

  Future<void> toMainPost(String id) => _firestore.doc(postPath(id)).update({
        'isHeader': true,
      });

  Future<void> toGeneralPost(String id) => _firestore.doc(postPath(id)).update({
        'isHeader': false,
      });

  Future<void> updatePostCommentCount(
          {required String id, required int number}) =>
      _firestore.doc(postPath(id)).update({
        'postCommentCount': FieldValue.increment(number),
      });

  Future<void> increaseLikeCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'likeCount': FieldValue.increment(1),
        'sumCount': FieldValue.increment(1),
      });

  Future<void> decreaseLikeCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'likeCount': FieldValue.increment(-1),
        'sumCount': FieldValue.increment(-1),
      });

  Future<void> increaseDislikeCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'dislikeCount': FieldValue.increment(1),
        'sumCount': FieldValue.increment(-1),
      });

  Future<void> decreaseDislikeCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'dislikeCount': FieldValue.increment(-1),
        'sumCount': FieldValue.increment(1),
      });

  Future<void> increaseViewCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'viewCount': FieldValue.increment(1),
      });

  Future<void> decreaseViewCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'viewCount': FieldValue.increment(-1),
      });

  Future<void> increaseReportCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'reportCount': FieldValue.increment(1),
      });

  Future<void> decreaseReportCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'reportCount': FieldValue.increment(-1),
      });

  Future<void> updateMainVideoImageUrl(String id, String url) =>
      _firestore.doc(postPath(id)).update({
        'mainVideoImageUrl': url,
      });

  Future<void> deletePost(String id) => _firestore.doc(postPath(id)).delete();

  Future<void> createTestPost({
    required String id,
    required String uid,
    required String content,
    required String title,
    bool needUpdate = false,
    bool isLongContent = false,
    bool isHeader = false,
    bool isRecommended = false,
    bool isNoTitle = false,
    bool isNoWriter = false,
    int category = 0,
    String? mainImageUrl,
    String? mainVideoUrl,
    String? mainVideoImageUrl,
    List<String> tags = const [],
    int postCommentCount = 0,
    int likeCount = 0,
    int dislikeCount = 0,
    int sumCount = 0,
    int reportCount = 0,
  }) =>
      _firestore.doc(postPath(id)).set({
        'id': id,
        'uid': uid,
        'content': content,
        'title': title,
        'needUpdate': needUpdate,
        'isLongContent': isLongContent,
        'isHeader': isHeader,
        'isBlock': false,
        'isRecommended': isRecommended,
        'isNoTitle': isNoTitle,
        'isNoWriter': isNoWriter,
        'category': category,
        'mainImageUrl': mainImageUrl,
        'mainVideoUrl': mainVideoUrl,
        'mainVideoImageUrl': mainVideoImageUrl,
        'tags': tags,
        'postCommentCount': postCommentCount,
        'viewCount': 0,
        'likeCount': likeCount,
        'dislikeCount': dislikeCount,
        'sumCount': sumCount,
        'reportCount': reportCount,
        'day': Format.yearMonthDayToInt(DateTime.now()),
        'month': Format.yearMonthToInt(DateTime.now()),
        'year': DateTime.now().year,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

  // basic query
  // 기본 쿼리
  Query<Post> postsRef() => _firestore.collection(postsPath()).withConverter(
        fromFirestore: (snapshot, _) => Post.fromMap(snapshot.data()!),
        toFirestore: (value, _) => value.toMap(),
      );

  // Sort post query in creation order
  // 생성 순서 정렬 포스트 쿼리
  Query<Post> defaultPostsQuery() =>
      postsRef().orderBy('createdAt', descending: true);

  // Admin recommended post query
  // 관리자 추천 포스트 쿼리
  Query<Post> recommendedPostsQuery() => postsRef()
      .where('isRecommended', isEqualTo: true)
      .orderBy('createdAt', descending: true);

  // Category Post Query
  // 카테고리 포스트 쿼리
  Query<Post> categoryPostsQuery(int category) => postsRef()
      .where('category', isEqualTo: category)
      .orderBy('createdAt', descending: true);

  // search post query
  // 검색 포스트 쿼리
  Query<Post> searchTagQuery(String searchTag) =>
      postsRef().where('tags', arrayContains: searchTag);

  // user post query
  // 사용자 포스트 쿼리
  Query<Post> userPostsQuery(String uid) => postsRef()
      .where('uid', isEqualTo: uid)
      .orderBy('createdAt', descending: true);

  // main post query
  // 메인 포스트 쿼리
  Query<Post> mainPostsQuery() => postsRef()
      .where('isHeader', isEqualTo: true)
      .orderBy('createdAt', descending: true)
      .limit(mainLimit);

  // Most recent post query
  // 가장 최근 포스트 쿼리
  Query<Post> recentPostQuery() =>
      postsRef().orderBy('createdAt', descending: true).limit(1);

  // main post list future
  // 메인 포스트 리스트 퓨처
  Future<List<Post>> fetchMainPostsList() async {
    final querySnaphost = await postsRef()
        .where('isHeader', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(mainLimit)
        .get();
    return querySnaphost.docs.map((e) => e.data()).toList();
  }

  // Main Post Document Snapshot List Future
  // 메인 포스트 도큐먼트 스냅샷 리스트 퓨처
  Future<List<DocumentSnapshot<Post>>> fetchMainPostSnapshotsList() async {
    final querySnaphost = await postsRef()
        .where('isHeader', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(mainLimit)
        .get();
    return querySnaphost.docs;
  }

  // user post id list future
  // 사용자 포스트 아이디 리스트 퓨처
  Future<List<String>> getPostIdsForUser(String uid) async {
    final query = await postsRef().where('uid', isEqualTo: uid).get();
    return query.docs.map((e) => e.id).toList();
  }

  DocumentReference<Post> postRef(String id) =>
      _firestore.doc(postPath(id)).withConverter(
            fromFirestore: (snapshot, _) => Post.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  Future<Post?> fetchPost(String id) async {
    final snapshot = await postRef(id).get();
    return snapshot.data();
  }

  Stream<Post> watchPost(String id) =>
      postRef(id).snapshots().map((snapshot) => snapshot.data()!);
}

@Riverpod(keepAlive: true)
PostsRepository postsRepository(Ref ref) {
  return PostsRepository(FirebaseFirestore.instance);
}

@riverpod
FutureOr<Post?> postFuture(Ref ref, String id) {
  return ref.watch(postsRepositoryProvider).fetchPost(id);
}

@riverpod
Stream<Post> postStream(Ref ref, String id) {
  return ref.watch(postsRepositoryProvider).watchPost(id);
}

@riverpod
FutureOr<List<Post>> mainPostsFuture(Ref ref) {
  final postsRepository = ref.watch(postsRepositoryProvider);
  return postsRepository.fetchMainPostsList();
}

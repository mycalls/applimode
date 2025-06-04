// lib/src/features/posts/data/posts_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/utils/format.dart';

part 'posts_repository.g.dart';

// English: Repository class for managing post data in Firestore.
// Korean: Firestore에서 게시물 데이터를 관리하기 위한 리포지토리 클래스입니다.
class PostsRepository {
  const PostsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  // English: Default limit for fetching posts in lists.
  // Korean: 목록에서 게시물을 가져오기 위한 기본 제한입니다.
  static const limit = listFetchLimit;
  // English: Default limit for fetching main/header posts.
  // Korean: 메인/헤더 게시물을 가져오기 위한 기본 제한입니다.
  static const mainLimit = mainFetchLimit;
  // English: Returns the path for the posts collection.
  // Korean: 게시물 컬렉션의 경로를 반환합니다.
  static String postsPath() => 'posts';
  // English: Returns the path for a specific post document.
  // Korean: 특정 게시물 문서의 경로를 반환합니다.
  static String postPath(String id) => 'posts/$id';

  // English: Creates a new post in Firestore.
  // Korean: Firestore에 새 게시물을 생성합니다.
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
        // English: Derive day, month, year from the provided createdAt for consistency.
        // Korean: 일관성을 위해 제공된 createdAt에서 day, month, year를 파생합니다.
        'day': Format.yearMonthDayToInt(createdAt),
        'month': Format.yearMonthToInt(createdAt),
        'year': createdAt.year,
        'createdAt': createdAt.millisecondsSinceEpoch,
      });

  // English: Updates an existing post in Firestore.
  // Korean: Firestore에서 기존 게시물을 업데이트합니다.
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

  // English: Marks a post as blocked.
  // Korean: 게시물을 차단된 것으로 표시합니다.
  Future<void> blockPost(String id) => _firestore.doc(postPath(id)).update({
        'isBlock': true,
      });

  // English: Unmarks a post as blocked.
  // Korean: 게시물의 차단 표시를 해제합니다.
  Future<void> unblockPost(String id) => _firestore.doc(postPath(id)).update({
        'isBlock': false,
      });

  // English: Marks a post as recommended.
  // Korean: 게시물을 추천된 것으로 표시합니다.
  Future<void> recommendPost(String id) => _firestore.doc(postPath(id)).update({
        'isRecommended': true,
      });

  // English: Unmarks a post as recommended.
  // Korean: 게시물의 추천 표시를 해제합니다.
  Future<void> unrecommendPost(String id) =>
      _firestore.doc(postPath(id)).update({
        'isRecommended': false,
      });

  // English: Sets a post as a main/header post.
  // Korean: 게시물을 메인/헤더 게시물로 설정합니다.
  Future<void> toMainPost(String id) => _firestore.doc(postPath(id)).update({
        'isHeader': true,
      });

  // English: Sets a post as a general post (not main/header).
  // Korean: 게시물을 일반 게시물(메인/헤더 아님)로 설정합니다.
  Future<void> toGeneralPost(String id) => _firestore.doc(postPath(id)).update({
        'isHeader': false,
      });

  // English: Updates the comment count for a post by the given number.
  // Korean: 주어진 숫자만큼 게시물의 댓글 수를 업데이트합니다.
  Future<void> updatePostCommentCount(
          {required String id, required int number}) =>
      _firestore.doc(postPath(id)).update({
        'postCommentCount': FieldValue.increment(number),
      });

  // English: Increases the like count and sum count of a post.
  // Korean: 게시물의 좋아요 수와 합계 수를 증가시킵니다.
  Future<void> increaseLikeCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'likeCount': FieldValue.increment(1),
        'sumCount': FieldValue.increment(1),
      });

  // English: Decreases the like count and sum count of a post.
  // Korean: 게시물의 좋아요 수와 합계 수를 감소시킵니다.
  Future<void> decreaseLikeCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'likeCount': FieldValue.increment(-1),
        'sumCount': FieldValue.increment(-1),
      });

  // English: Increases the dislike count and decreases the sum count of a post.
  // Korean: 게시물의 싫어요 수를 증가시키고 합계 수를 감소시킵니다.
  Future<void> increaseDislikeCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'dislikeCount': FieldValue.increment(1),
        'sumCount': FieldValue.increment(-1),
      });

  // English: Decreases the dislike count and increases the sum count of a post.
  // Korean: 게시물의 싫어요 수를 감소시키고 합계 수를 증가시킵니다.
  Future<void> decreaseDislikeCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'dislikeCount': FieldValue.increment(-1),
        'sumCount': FieldValue.increment(1),
      });

  // English: Increases the view count of a post.
  // Korean: 게시물의 조회수를 증가시킵니다.
  Future<void> increaseViewCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'viewCount': FieldValue.increment(1),
      });

  // English: Decreases the view count of a post. (Note: Typically view counts only increase)
  // Korean: 게시물의 조회수를 감소시킵니다. (참고: 일반적으로 조회수는 증가만 합니다)
  Future<void> decreaseViewCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'viewCount': FieldValue.increment(-1),
      });

  // English: Increases the report count of a post.
  // Korean: 게시물의 신고 수를 증가시킵니다.
  Future<void> increaseReportCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'reportCount': FieldValue.increment(1),
      });

  Future<void> decreaseReportCount(String id) =>
      _firestore.doc(postPath(id)).update({
        'reportCount': FieldValue.increment(-1),
      });

  // English: Updates the main video image URL for a post.
  // Korean: 게시물의 메인 비디오 이미지 URL을 업데이트합니다.
  Future<void> updateMainVideoImageUrl(String id, String url) =>
      _firestore.doc(postPath(id)).update({
        'mainVideoImageUrl': url,
      });

  // English: Deletes a post from Firestore.
  // Korean: Firestore에서 게시물을 삭제합니다.
  Future<void> deletePost(String id) => _firestore.doc(postPath(id)).delete();

  // English: Creates a test post with customizable fields, primarily for testing purposes.
  // Korean: 주로 테스트 목적으로 사용되며 사용자 정의 필드를 사용하여 테스트 게시물을 생성합니다.
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
    DateTime?
        createdAt, // English: Optional creation time for testing. Korean: 테스트를 위한 선택적 생성 시간입니다.
  }) {
    // English: Use provided createdAt or default to now.
    // Korean: 제공된 createdAt을 사용하거나 현재 시간으로 기본 설정합니다.
    final DateTime effectiveCreatedAt = createdAt ?? DateTime.now();
    return _firestore.doc(postPath(id)).set({
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
      // English: Derive day, month, year from effectiveCreatedAt.
      // Korean: effectiveCreatedAt에서 day, month, year를 파생합니다.
      'day': Format.yearMonthDayToInt(effectiveCreatedAt),
      'month': Format.yearMonthToInt(effectiveCreatedAt),
      'year': effectiveCreatedAt.year,
      'createdAt': effectiveCreatedAt.millisecondsSinceEpoch,
    });
  }

  // basic query
  // 기본 쿼리
  // English: Returns a Firestore query for posts with a converter.
  // Korean: 변환기가 적용된 게시물에 대한 Firestore 쿼리를 반환합니다.
  Query<Post> postsRef() => _firestore.collection(postsPath()).withConverter(
        fromFirestore: (snapshot, _) => Post.fromMap(snapshot.data()!),
        toFirestore: (value, _) => value.toMap(),
      );

  // Sort post query in creation order
  // 생성 순서 정렬 포스트 쿼리
  // English: Returns a query for posts sorted by creation date (descending).
  // Korean: 생성 날짜(내림차순)로 정렬된 게시물 쿼리를 반환합니다.
  Query<Post> defaultPostsQuery() =>
      postsRef().orderBy('createdAt', descending: true);

  // Admin recommended post query
  // 관리자 추천 포스트 쿼리
  // English: Returns a query for posts marked as recommended by admin.
  // Korean: 관리자가 추천한 것으로 표시된 게시물 쿼리를 반환합니다.
  Query<Post> recommendedPostsQuery() => postsRef()
      .where('isRecommended', isEqualTo: true)
      .orderBy('createdAt', descending: true);

  // Category Post Query
  // 카테고리 포스트 쿼리
  // English: Returns a query for posts belonging to a specific category.
  // Korean: 특정 카테고리에 속하는 게시물 쿼리를 반환합니다.
  Query<Post> categoryPostsQuery(int category) => postsRef()
      .where('category', isEqualTo: category)
      .orderBy('createdAt', descending: true);

  // search post query
  // 검색 포스트 쿼리
  // English: Returns a query for posts containing a specific search tag.
  // Korean: 특정 검색 태그를 포함하는 게시물 쿼리를 반환합니다.
  Query<Post> searchTagQuery(String searchTag) =>
      postsRef().where('tags', arrayContains: searchTag);

  // user post query
  // 사용자 포스트 쿼리
  // English: Returns a query for posts created by a specific user.
  // Korean: 특정 사용자가 생성한 게시물 쿼리를 반환합니다.
  Query<Post> userPostsQuery(String uid) => postsRef()
      .where('uid', isEqualTo: uid)
      .orderBy('createdAt', descending: true);

  // main post query
  // 메인 포스트 쿼리
  // English: Returns a query for main/header posts, limited by `mainLimit`.
  // Korean: `mainLimit`으로 제한된 메인/헤더 게시물 쿼리를 반환합니다.
  Query<Post> mainPostsQuery() => postsRef()
      .where('isHeader', isEqualTo: true)
      .orderBy('createdAt', descending: true)
      .limit(mainLimit);

  // Most recent post query
  // 가장 최근 포스트 쿼리
  // English: Returns a query for the most recent post.
  // Korean: 가장 최근 게시물에 대한 쿼리를 반환합니다.
  Query<Post> recentPostQuery() =>
      postsRef().orderBy('createdAt', descending: true).limit(1);

  // main post list future
  // 메인 포스트 리스트 퓨처
  // English: Fetches a list of main/header posts.
  // Korean: 메인/헤더 게시물 목록을 가져옵니다.
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
  // English: Fetches a list of document snapshots for main/header posts.
  // Korean: 메인/헤더 게시물에 대한 문서 스냅샷 목록을 가져옵니다.
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
  // English: Fetches a list of post IDs for a given user.
  // Korean: 주어진 사용자의 게시물 ID 목록을 가져옵니다.
  Future<List<String>> getPostIdsForUser(String uid) async {
    final query = await postsRef().where('uid', isEqualTo: uid).get();
    return query.docs.map((e) => e.id).toList();
  }

  // English: Returns a document reference for a specific post with a converter.
  // Korean: 변환기가 적용된 특정 게시물에 대한 문서 참조를 반환합니다.
  DocumentReference<Post> postRef(String id) =>
      _firestore.doc(postPath(id)).withConverter(
            fromFirestore: (snapshot, _) => Post.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  // English: Fetches a single post by its ID. Returns null if not found.
  // Korean: ID로 단일 게시물을 가져옵니다. 찾을 수 없으면 null을 반환합니다.
  Future<Post?> fetchPost(String id) async {
    final snapshot = await postRef(id).get();
    return snapshot.data();
  }

  // English: Watches a single post by its ID for real-time updates. Returns null in the stream if the post is deleted.
  // Korean: 실시간 업데이트를 위해 ID로 단일 게시물을 관찰합니다. 게시물이 삭제되면 스트림에서 null을 반환합니다.
  Stream<Post?> watchPost(String id) =>
      postRef(id).snapshots().map((snapshot) => snapshot.data());
}

// English: Riverpod provider for the PostsRepository. Kept alive throughout the app.
// Korean: PostsRepository를 위한 Riverpod 프로바이더입니다. 앱 전체에서 활성 상태를 유지합니다.
@Riverpod(keepAlive: true)
PostsRepository postsRepository(Ref ref) {
  return PostsRepository(FirebaseFirestore.instance);
}

// English: Riverpod provider to fetch a single post as a Future.
// Korean: 단일 게시물을 Future로 가져오는 Riverpod 프로바이더입니다.
@riverpod
FutureOr<Post?> postFuture(Ref ref, String id) {
  return ref.watch(postsRepositoryProvider).fetchPost(id);
}

// English: Riverpod provider to watch a single post as a Stream.
// Korean: 단일 게시물을 Stream으로 관찰하는 Riverpod 프로바이더입니다.
@riverpod
Stream<Post?> postStream(Ref ref, String id) {
  return ref.watch(postsRepositoryProvider).watchPost(id);
}

// English: Riverpod provider to fetch the list of main posts as a Future.
// Korean: 메인 게시물 목록을 Future로 가져오는 Riverpod 프로바이더입니다.
@riverpod
FutureOr<List<Post>> mainPostsFuture(Ref ref) {
  final postsRepository = ref.watch(postsRepositoryProvider);
  return postsRepository.fetchMainPostsList();
}

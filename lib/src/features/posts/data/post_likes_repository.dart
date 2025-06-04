// lib/src/features/posts/data/post_likes_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/features/posts/domain/post_like.dart';

part 'post_likes_repository.g.dart';

// English: Repository for managing post likes and dislikes in Firestore.
// Korean: Firestore에서 게시물 좋아요 및 싫어요를 관리하는 리포지토리입니다.
class PostLikesRepository {
  const PostLikesRepository(this._firestore);

  final FirebaseFirestore _firestore;

  // English: Default limit for fetching items, though not directly used in this repository's current methods.
  // Korean: 항목을 가져오기 위한 기본 제한값으로, 현재 이 리포지토리의 메소드에서는 직접 사용되지 않습니다.
  static const limit = listFetchLimit;

  // English: Returns the path for the postLikes collection.
  // Korean: postLikes 컬렉션의 경로를 반환합니다.
  static String postLikesPath() => 'postLikes';
  // English: Returns the path for a specific postLike document.
  // Korean: 특정 postLike 문서의 경로를 반환합니다.
  static String postLikePath(String id) => 'postLikes/$id';

  // English: Creates a new post like/dislike document in Firestore.
  // Korean: Firestore에 새 게시물 좋아요/싫어요 문서를 생성합니다.
  Future<void> createPostLike({
    required String id,
    required String uid,
    required String postId,
    required String postWriterId,
    bool isDislike = false,
    required DateTime createdAt,
  }) =>
      _firestore.doc(postLikePath(id)).set({
        'id': id,
        'uid': uid,
        'postId': postId,
        'postWriterId': postWriterId,
        'isDislike': isDislike,
        'createdAt': createdAt.millisecondsSinceEpoch,
      });

  // English: Deletes a post like/dislike document from Firestore.
  // Korean: Firestore에서 게시물 좋아요/싫어요 문서를 삭제합니다.
  Future<void> deletePostLike(String id) =>
      _firestore.doc(postLikePath(id)).delete();

  // English: Constructs a Firestore query for PostLike documents with optional filters.
  // Filters are applied with precedence: uid, then postId, then postWriterId.
  // The 'isDislike' filter is applied if 'uid' or 'postId' is also provided.
  // Korean: 선택적 필터를 사용하여 PostLike 문서에 대한 Firestore 쿼리를 구성합니다.
  // 필터는 uid, postId, postWriterId 순으로 우선 적용됩니다.
  // 'isDislike' 필터는 'uid' 또는 'postId'도 제공된 경우에 적용됩니다.
  Query<PostLike> postLikesRef({
    bool? isDislike,
    String? uid,
    String? postId,
    String? postWriterId,
  }) {
    Query<PostLike> query = _firestore
        .collection(postLikesPath())
        .withConverter(
          fromFirestore: (snapshot, _) => PostLike.fromMap(snapshot.data()!),
          toFirestore: (value, _) => value.toMap(),
        );

    if (uid != null) {
      query = query.where('uid', isEqualTo: uid);
      if (isDislike != null) {
        query = query.where('isDislike', isEqualTo: isDislike);
      }
      // English: If uid is specified, it's the primary filter.
      // Other primary filters like postId or postWriterId are not considered in conjunction here.
      // Korean: uid가 지정되면 기본 필터입니다. postId 또는 postWriterId와 같은 다른 기본 필터는 여기에서 함께 고려되지 않습니다.
      return query;
    }

    if (postId != null) {
      query = query.where('postId', isEqualTo: postId);
      if (isDislike != null) {
        query = query.where('isDislike', isEqualTo: isDislike);
      }
      // English: If postId is specified (and uid was not), it's the primary filter.
      // postWriterId is not considered in conjunction here.
      // Korean: postId가 지정되면 (uid가 지정되지 않은 경우) 기본 필터입니다. postWriterId는 여기에서 함께 고려되지 않습니다.
      return query;
    }

    if (postWriterId != null) {
      query = query.where('postWriterId', isEqualTo: postWriterId);
      // English: Note: isDislike is not applied if only postWriterId is the filter,
      // matching the original logic where isDislike was only paired with uid or postId.
      // Korean: 참고: postWriterId만 필터인 경우 isDislike는 적용되지 않으며,
      // 이는 isDislike가 uid 또는 postId와만 쌍을 이루던 원래 로직과 일치합니다.
      return query;
    }

    return query;
  }

  // English: Fetches all postLike IDs associated with a specific post. Used during post deletion.
  // Korean: 특정 게시물과 관련된 모든 postLike ID를 가져옵니다. 게시물 삭제 시 사용됩니다.
  Future<List<String>> getPostLikeIdsForPost(String postId) async {
    final query = await postLikesRef(postId: postId).get();
    return query.docs.map((e) => e.id).toList();
  }

  // English: Fetches a user's specific like or dislike status for a given post.
  // Korean: 주어진 게시물에 대한 사용자의 특정 좋아요 또는 싫어요 상태를 가져옵니다.
  Future<List<PostLike>> fetchPostLikesByUser({
    required String postId,
    required String uid,
    bool isDislike = false,
  }) async {
    final postLikesSnapshot = await postLikesRef()
        .where('postId', isEqualTo: postId)
        .where('uid', isEqualTo: uid)
        .where('isDislike', isEqualTo: isDislike)
        .get();
    return postLikesSnapshot.docs.map((e) => e.data()).toList();
  }

  // English: Watches for real-time updates on a user's likes/dislikes for a specific post.
  // Korean: 특정 게시물에 대한 사용자의 좋아요/싫어요에 대한 실시간 업데이트를 관찰합니다.
  Stream<List<PostLike>> watchPostLikesByUser({
    required String postId,
    required String uid,
  }) =>
      postLikesRef()
          .where('postId', isEqualTo: postId)
          .where('uid', isEqualTo: uid)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  // English: Fetches all postLike IDs created by a specific user. Used during account removal.
  // Korean: 특정 사용자가 생성한 모든 postLike ID를 가져옵니다. 계정 삭제 시 사용됩니다.
  Future<List<String>> getPostLikeIdsForUser(String uid) async {
    final query = await postLikesRef(uid: uid).get();
    return query.docs.map((e) => e.id).toList();
  }

  // English: Fetches all postLike IDs associated with posts written by a specific user. Used during account removal.
  // Korean: 특정 사용자가 작성한 게시물과 관련된 모든 postLike ID를 가져옵니다. 계정 삭제 시 사용됩니다.
  Future<List<String>> getPostLikeIdsForPostWriter(String postWriterId) async {
    final query = await postLikesRef(postWriterId: postWriterId).get();
    return query.docs.map((e) => e.id).toList();
  }

  // English: Fetches all postLike IDs either created by the user or on posts written by the user. Used for comprehensive cleanup during account closure.
  // Korean: 사용자가 생성했거나 사용자가 작성한 게시물에 대한 모든 postLike ID를 가져옵니다. 계정 해지 시 포괄적인 정리에 사용됩니다.
  Future<List<String>> getPostLikeIdsForClose(String uid) async {
    final query = await postLikesRef()
        .where(Filter.or(Filter('uid', isEqualTo: uid),
            Filter('postWriterId', isEqualTo: uid)))
        .get();
    return query.docs.map((e) => e.id).toList();
  }
}

// English: Riverpod provider for the PostLikesRepository. Kept alive throughout the app.
// Korean: PostLikesRepository를 위한 Riverpod 프로바이더입니다. 앱 전체에서 활성 상태를 유지합니다.
@Riverpod(keepAlive: true)
PostLikesRepository postLikesRepository(Ref ref) {
  return PostLikesRepository(FirebaseFirestore.instance);
}

// English: Riverpod provider to get a Firestore query for post likes, filterable by dislike status, user ID, or post ID.
// Korean: 좋아요/싫어요 상태, 사용자 ID 또는 게시물 ID로 필터링 가능한 게시물 좋아요에 대한 Firestore 쿼리를 가져오는 Riverpod 프로바이더입니다.
@riverpod
Query<PostLike> postLikesQuery(
  Ref ref, {
  bool? isDislike,
  String? uid,
  String? postId,
}) {
  final postLikesRepository = ref.watch(postLikesRepositoryProvider);
  return postLikesRepository.postLikesRef(
    isDislike: isDislike,
    uid: uid,
    postId: postId,
  );
}

// English: Riverpod provider to fetch a user's like/dislike status for a post as a Future.
// Korean: 게시물에 대한 사용자의 좋아요/싫어요 상태를 Future로 가져오는 Riverpod 프로바이더입니다.
@riverpod
FutureOr<List<PostLike>> postLikesByUserFuture(
  Ref ref, {
  required String postId,
  required String uid,
  bool isDislike = false,
}) {
  return ref.watch(postLikesRepositoryProvider).fetchPostLikesByUser(
        postId: postId,
        uid: uid,
        isDislike: isDislike,
      );
}

// English: Riverpod provider to watch a user's like/dislike status for a post as a Stream.
// Korean: 게시물에 대한 사용자의 좋아요/싫어요 상태를 Stream으로 관찰하는 Riverpod 프로바이더입니다.
@riverpod
Stream<List<PostLike>> postLikesByUserStream(
  Ref ref, {
  required String postId,
  required String uid,
}) {
  return ref
      .watch(postLikesRepositoryProvider)
      .watchPostLikesByUser(postId: postId, uid: uid);
}

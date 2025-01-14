import 'package:applimode_app/src/features/comments/domain/post_comment.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_comments_repository.g.dart';

class PostCommentsRepository {
  const PostCommentsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const limit = listFetchLimit;
  static const bestLimit = 1;

  static String postCommentsPath() => 'postComments';
  static String postCommentPath(String id) => 'postComments/$id';

  Future<void> createPostComment({
    required String id,
    required String uid,
    required String postId,
    required String parentCommentId,
    required String postWriterId,
    bool isReply = false,
    String? content,
    String? imageUrl,
  }) =>
      _firestore.doc(postCommentPath(id)).set({
        'id': id,
        'uid': uid,
        'postId': postId,
        'parentCommentId': parentCommentId,
        'postWriterId': postWriterId,
        'isReply': isReply,
        'content': content,
        'imageUrl': imageUrl,
        'replyCount': 0,
        'likeCount': 0,
        'dislikeCount': 0,
        'sumCount': 0,
        'reportCount': 0,
        'day': Format.yearMonthDayToInt(DateTime.now()),
        'month': Format.yearMonthToInt(DateTime.now()),
        'year': DateTime.now().year,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

  Future<void> deletePostComment(String id) =>
      _firestore.doc(postCommentPath(id)).delete();

  Future<void> updateReplyCount({required String id, required int number}) =>
      _firestore.doc(postCommentPath(id)).update({
        'replyCount': FieldValue.increment(number),
      });

  Future<void> increaseLikeCount(String id) =>
      _firestore.doc(postCommentPath(id)).update({
        'likeCount': FieldValue.increment(1),
        'sumCount': FieldValue.increment(1),
      });

  Future<void> decreaseLikeCount(String id) =>
      _firestore.doc(postCommentPath(id)).update({
        'likeCount': FieldValue.increment(-1),
        'sumCount': FieldValue.increment(-1),
      });

  Future<void> increaseDislikeCount(String id) =>
      _firestore.doc(postCommentPath(id)).update({
        'dislikeCount': FieldValue.increment(1),
        'sumCount': FieldValue.increment(-1),
      });

  Future<void> decreaseDislikeCount(String id) =>
      _firestore.doc(postCommentPath(id)).update({
        'dislikeCount': FieldValue.increment(-1),
        'sumCount': FieldValue.increment(1),
      });

  Future<void> increaseReportCount(String id) =>
      _firestore.doc(postCommentPath(id)).update({
        'reportCount': FieldValue.increment(1),
      });

  Future<void> decreaseReportCount(String id) =>
      _firestore.doc(postCommentPath(id)).update({
        'reportCount': FieldValue.increment(-1),
      });

  // 쿼리
  Query<PostComment> postCommentsRef({
    String? postId,
    String? uid,
    bool byCreatedAt = false,
    bool byCommentCount = false,
    bool byLikeCount = false,
    bool byDislikeCount = false,
    bool bySumCount = false,
    int? day,
    int? month,
    int? year,
  }) {
    Query<PostComment> query = _firestore
        .collection(postCommentsPath())
        .withConverter(
          fromFirestore: (snapshot, _) => PostComment.fromMap(snapshot.data()!),
          toFirestore: (value, _) => value.toMap(),
        );

    // 사용자 댓글 목록 시간순 정렬 쿼리
    if (uid != null) {
      return query
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true);
    }

    // 포스트에 대한 댓글 시간순 정렬 커리
    if (postId != null && byCreatedAt) {
      return query
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: true);
    }

    // 포스트에 대한 댓글 좋아요 싫어요 합계순 정렬 커리
    if (postId != null && bySumCount) {
      return query
          .where('postId', isEqualTo: postId)
          .orderBy('sumCount', descending: true);
    }

    // 포스트에 대한 댓글 답글 합계순 정렬 커리
    if (postId != null && byCommentCount) {
      return query
          .where('postId', isEqualTo: postId)
          .orderBy('replyCount', descending: true);
    }

    // 포스트에 대한 댓글 좋아요 합계순 정렬 커리
    if (postId != null && byLikeCount) {
      return query
          .where('postId', isEqualTo: postId)
          .orderBy('likeCount', descending: true);
    }

    // 포스트에 대한 댓글 싫어요 합계순 정렬 커리
    if (postId != null && byDislikeCount) {
      return query
          .where('postId', isEqualTo: postId)
          .orderBy('dislikeCount', descending: true);
    }

    // 날짜별 베스트 댓글
    if (day != null) {
      return query
          .where('day', isEqualTo: day)
          .orderBy('sumCount', descending: true);
    }

    // 월별 베스트 댓글
    if (month != null) {
      return query
          .where('month', isEqualTo: month)
          .orderBy('sumCount', descending: true);
    }

    // 년도별 베스트 댓글
    if (year != null) {
      return query
          .where('year', isEqualTo: year)
          .orderBy('sumCount', descending: true);
    }

    return query;
  }

  // 댓글에 대한 답글 쿼리
  Query<PostComment> postCommentRepliesRef(String parentCommentId) =>
      postCommentsRef()
          .where('parentCommentId', isEqualTo: parentCommentId)
          .orderBy('createdAt', descending: true);

  // 포스트에 대한 베스트 댓글 쿼리
  Future<List<PostComment>> fetchBestPostCommentsList(String postId) async {
    final querySnaphost = await postCommentsRef(
      postId: postId,
      bySumCount: true,
    ).limit(bestLimit).get();
    return querySnaphost.docs.map((e) => e.data()).toList();
  }

  // 포스트 삭제시 댓글 아이디 리스트 가져오기
  Future<List<String>> getPostCommentIdsForPost(String postId) async {
    final query =
        await postCommentsRef().where('postId', isEqualTo: postId).get();
    return query.docs.map((e) => e.id).toList();
  }

  // 회원탈퇴시 댓글 아이디 목록 가져오기
  Future<List<String>> getPostCommentIdsForUser(String uid) async {
    final query = await postCommentsRef().where('uid', isEqualTo: uid).get();
    return query.docs.map((e) => e.id).toList();
  }

  // 회원탈퇴시 회원이 작성한 포스트에 대한 댓글 아이디 목록 가져오기
  Future<List<String>> getPostCommentIdsForPostWriter(
      String postWriterId) async {
    final query = await postCommentsRef()
        .where('postWriterId', isEqualTo: postWriterId)
        .get();
    return query.docs.map((e) => e.id).toList();
  }

  // 회원탈퇴시 사용자 댓글 목록 가져오기
  Future<List<PostComment>> getPostCommentsForUser(String uid) async {
    final query = await postCommentsRef().where('uid', isEqualTo: uid).get();
    return query.docs.map((e) => e.data()).toList();
  }

  // 회원탈퇴시 사용자 및 사용자가 작성한 포스트의 댓글 목록 가져오기
  Future<List<PostComment>> getPostCommentsForClose(String uid) async {
    final query = await postCommentsRef()
        .where(Filter.or(Filter('uid', isEqualTo: uid),
            Filter('postWriterId', isEqualTo: uid)))
        .get();
    return query.docs.map((e) => e.data()).toList();
  }

  DocumentReference<PostComment> postCommentRef(String id) =>
      _firestore.doc(postCommentPath(id)).withConverter(
            fromFirestore: (snapshot, _) =>
                PostComment.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  Future<PostComment?> fetchPostComment(String id) async {
    final snapshot = await postCommentRef(id).get();
    return snapshot.data();
  }
}

@Riverpod(keepAlive: true)
PostCommentsRepository postCommentsRepository(Ref ref) {
  return PostCommentsRepository(FirebaseFirestore.instance);
}

@riverpod
Query<PostComment> postCommentsQuery(
  Ref ref, {
  String? postId,
  String? uid,
  bool byCreatedAt = true,
  bool byCommentCount = false,
  bool byLikeCount = false,
  bool byDislikeCount = false,
  bool bySumCount = false,
  int? day,
  int? month,
  int? year,
}) {
  final postCommentsRepository = ref.watch(postCommentsRepositoryProvider);
  return postCommentsRepository.postCommentsRef(
    postId: postId,
    uid: uid,
    byCreatedAt: byCreatedAt,
    byCommentCount: byCommentCount,
    byLikeCount: byLikeCount,
    byDislikeCount: byDislikeCount,
    bySumCount: bySumCount,
    day: day,
    month: month,
    year: year,
  );
}

@riverpod
Query<PostComment> postCommentRepliesQuery(Ref ref, String parentCommentId) {
  return ref
      .watch(postCommentsRepositoryProvider)
      .postCommentRepliesRef(parentCommentId);
}

@riverpod
FutureOr<PostComment?> postCommentFuture(Ref ref, String id) {
  return ref.watch(postCommentsRepositoryProvider).fetchPostComment(id);
}

@riverpod
FutureOr<List<PostComment>> bestPostCommentsFuture(Ref ref, String postId) {
  return ref
      .watch(postCommentsRepositoryProvider)
      .fetchBestPostCommentsList(postId);
}

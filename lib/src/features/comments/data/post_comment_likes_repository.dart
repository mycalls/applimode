// external
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:applimode_app/custom_settings.dart';

// features
import 'package:applimode_app/src/features/comments/domain/post_comment_like.dart';

part 'post_comment_likes_repository.g.dart';

class PostCommentLikesRepository {
  const PostCommentLikesRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const limit = listFetchLimit;

  static String postCommentLikesPath() => 'postCommentLikes';
  static String postCommentLikePath(String id) => 'postCommentLikes/$id';

  Future<void> createPostCommentLike({
    required String id,
    required String uid,
    required String postId,
    required String commentId,
    required String commentWriterId,
    required String postWriterId,
    required String parentCommentId,
    bool isDislike = false,
    required DateTime createdAt,
  }) =>
      _firestore.doc(postCommentLikePath(id)).set({
        'id': id,
        'uid': uid,
        'postId': postId,
        'commentId': commentId,
        'commentWriterId': commentWriterId,
        'postWriterId': postWriterId,
        'parentCommentId': parentCommentId,
        'isDislike': isDislike,
        'createdAt': createdAt.millisecondsSinceEpoch,
      });

  Future<void> deletePostCommentLike(String id) =>
      _firestore.doc(postCommentLikePath(id)).delete();

  Query<PostCommentLike> postCommentLikesRef({
    bool? isDislike,
    String? uid,
    String? commentId,
  }) {
    Query<PostCommentLike> query =
        _firestore.collection(postCommentLikesPath()).withConverter(
              fromFirestore: (snapshot, _) =>
                  PostCommentLike.fromMap(snapshot.data()!),
              toFirestore: (value, _) => value.toMap(),
            );

    // 사용자의 모든 좋아요 싫어요 쿼리
    if (uid != null && isDislike == null) {
      return query.where('uid', isEqualTo: uid);
    }

    // 댓글의 모든 좋아요 싫어요 쿼리
    if (commentId != null && isDislike == null) {
      return query.where('commentId', isEqualTo: commentId);
    }

    // 사용자의 좋아요 쿼리
    if (uid != null && isDislike == false) {
      return query
          .where('uid', isEqualTo: uid)
          .where('isDislike', isEqualTo: false);
    }

    // 사용자의 싫어요 쿼리
    if (uid != null && isDislike == true) {
      return query
          .where('uid', isEqualTo: uid)
          .where('isDislike', isEqualTo: true);
    }

    // 댓글의 좋아요 쿼리
    if (commentId != null && isDislike == false) {
      return query
          .where('commentId', isEqualTo: commentId)
          .where('isDislike', isEqualTo: false);
    }

    // 댓글의 싫어요 쿼리
    if (commentId != null && isDislike == true) {
      return query
          .where('commentId', isEqualTo: commentId)
          .where('isDislike', isEqualTo: true);
    }

    return query;
  }

  // 댓글 삭제시 모든 좋아요 싫어요 아이디 목록 가져오기
  Future<List<String>> getPostCommentLikeIdsForComment(String commentId) async {
    final query = await postCommentLikesRef(commentId: commentId).get();
    return query.docs.map((e) => e.id).toList();
  }

  // 포스트 삭제시 모든 좋아요 싫어요 목록 가져오기
  Future<List<String>> getPostParentCommentLikeIdsForComment(
      String parentCommentId) async {
    final query = await postCommentLikesRef()
        .where('parentCommentId', isEqualTo: parentCommentId)
        .get();
    return query.docs.map((e) => e.id).toList();
  }

  // 포스트 삭제시 모든 좋아요 싫어요 목록 가져오기
  Future<List<String>> getPostCommentLikeIdsForPost(String postId) async {
    final query =
        await postCommentLikesRef().where('postId', isEqualTo: postId).get();
    return query.docs.map((e) => e.id).toList();
  }

  // 회원 탈퇴시 모든 좋아요 싫어요 아이디 목록 가져오기
  Future<List<String>> getPostCommentLikeIdsForUser(String uid) async {
    final query = await postCommentLikesRef(uid: uid).get();
    return query.docs.map((e) => e.id).toList();
  }

  // 회원 탈퇴시 사용자, 사용자가 작성한 포스트, 사용자가 작성한 댓글의 좋아요 싫어요 아이디 목록 가져오기
  Future<List<String>> getPostCommentLikeIdsForClose(String uid) async {
    final query = await postCommentLikesRef()
        .where(Filter.or(
          Filter('uid', isEqualTo: uid),
          Filter('postWriterId', isEqualTo: uid),
          Filter('commentWriterId', isEqualTo: uid),
        ))
        .get();
    return query.docs.map((e) => e.id).toList();
  }

  // 각 댓글에 대한 사용자의 좋아요 싫어요 상태 확인
  Future<List<PostCommentLike>> fetchPostCommentLikesByUser({
    required String uid,
    required String commentId,
    bool isDislike = false,
  }) async {
    final postCommentLikesSnapshot = await postCommentLikesRef()
        .where('commentId', isEqualTo: commentId)
        .where('uid', isEqualTo: uid)
        .where('isDislike', isEqualTo: isDislike)
        .get();
    return postCommentLikesSnapshot.docs.map((e) => e.data()).toList();
  }
}

@Riverpod(keepAlive: true)
PostCommentLikesRepository postCommentLikesRepository(Ref ref) {
  return PostCommentLikesRepository(FirebaseFirestore.instance);
}

@riverpod
Query<PostCommentLike> postCommentLikesQuery(
  Ref ref, {
  bool? isDislike,
  String? uid,
  String? commentId,
}) {
  final postCommentLikesRepository =
      ref.watch(postCommentLikesRepositoryProvider);
  return postCommentLikesRepository.postCommentLikesRef(
    isDislike: isDislike,
    uid: uid,
    commentId: commentId,
  );
}

@riverpod
FutureOr<List<PostCommentLike>> postCommentLikesByUserFuture(
  Ref ref, {
  required String uid,
  required String commentId,
  bool isDislike = false,
}) {
  return ref
      .watch(postCommentLikesRepositoryProvider)
      .fetchPostCommentLikesByUser(
        uid: uid,
        commentId: commentId,
        isDislike: isDislike,
      );
}

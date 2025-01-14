import 'dart:async';

import 'package:applimode_app/src/features/comments/domain/post_comment_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_comment_report_repository.g.dart';

class PostCommentReportsRepository {
  const PostCommentReportsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static String postCommentReportsPath() => 'postCommentReports';
  static String postCommentReportPath(String id) => 'postCommentReports/$id';

  // create PostCommentReport
  Future<void> createPostCommentReport({
    required String id,
    required String uid,
    required String postId,
    required String commentId,
    required String commentWriterId,
    required String postWriterId,
    required int reportType,
    String? custom,
    required DateTime createdAt,
  }) =>
      _firestore.doc(postCommentReportPath(id)).set({
        'id': id,
        'uid': uid,
        'postId': postId,
        'commentId': commentId,
        'commentWriterId': commentWriterId,
        'postWriterId': postWriterId,
        'reportType': reportType,
        'custom': custom,
        'createdAt': createdAt.millisecondsSinceEpoch,
      });

  // delete PostCommentReport
  Future<void> deletePostCommentReport(String id) =>
      _firestore.doc(postCommentReportPath(id)).delete();

  // default PostCommentReports ref
  Query<PostCommentReport> postCommentReportsRef() =>
      _firestore.collection(postCommentReportsPath()).withConverter(
            fromFirestore: (snapshot, _) =>
                PostCommentReport.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  // default PostCommentReport ref
  DocumentReference<PostCommentReport> postCommentReportRef(String id) =>
      _firestore.doc(postCommentReportPath(id)).withConverter(
            fromFirestore: (snapshot, _) =>
                PostCommentReport.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  // get a PostCommentReport future
  Future<PostCommentReport?> fetchPostCommentReport(String id) async {
    final snapshot = await postCommentReportRef(id).get();
    return snapshot.data();
  }

  // get all PostCommentReports for a comment (PostReports list for a comment)
  Query<PostCommentReport> postCommentReportsForCommentRef(String commentId) =>
      postCommentReportsRef()
          .where('commentId', isEqualTo: commentId)
          .orderBy('createdAt', descending: true);

  // get all PostCommentReportIds when delete a comment
  Future<List<String>> getPostCommentReportIdsForComment(
      String commentId) async {
    final snapshot = await postCommentReportsRef()
        .where('commentId', isEqualTo: commentId)
        .get();
    return snapshot.docs.map((e) => e.id).toList();
  }

  // get all PostCommentReportIds when delete a post
  Future<List<String>> getPostCommentReportIdsForPost(String postId) async {
    final snapshot =
        await postCommentReportsRef().where('postId', isEqualTo: postId).get();
    return snapshot.docs.map((e) => e.id).toList();
  }

  // get all PostCommentReportIds wher close a user
  Future<List<String>> getPostCommentReportIdsForClose(String uid) async {
    final snapshot = await postCommentReportsRef()
        .where(Filter.or(
          Filter('uid', isEqualTo: uid),
          Filter('postWriterId', isEqualTo: uid),
          Filter('commentWriterId', isEqualTo: uid),
        ))
        .get();
    return snapshot.docs.map((e) => e.id).toList();
  }
}

@riverpod
PostCommentReportsRepository postCommentReportsRepository(Ref ref) {
  return PostCommentReportsRepository(FirebaseFirestore.instance);
}

@riverpod
FutureOr<PostCommentReport?> postCommentReportFuture(Ref ref, String id) {
  return ref
      .watch(postCommentReportsRepositoryProvider)
      .fetchPostCommentReport(id);
}

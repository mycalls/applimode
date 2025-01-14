import 'dart:async';

import 'package:applimode_app/src/features/posts/domain/post_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_reports_repository.g.dart';

class PostReportsRepository {
  const PostReportsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static String postReportsPath() => 'postReports';
  static String postReportPath(String id) => 'postReports/$id';

  // create PostReport
  Future<void> createPostReport({
    required String id,
    required String uid,
    required String postId,
    required String postWriterId,
    required int reportType,
    String? custom,
    required DateTime createdAt,
  }) =>
      _firestore.doc(postReportPath(id)).set({
        'id': id,
        'uid': uid,
        'postId': postId,
        'postWriterId': postWriterId,
        'reportType': reportType,
        'custom': custom,
        'createdAt': createdAt.millisecondsSinceEpoch,
      });

  // delete PostReport
  Future<void> deletePostReport(String id) =>
      _firestore.doc(postReportPath(id)).delete();

  // default PostReports ref
  Query<PostReport> postReportsRef() =>
      _firestore.collection(postReportsPath()).withConverter(
            fromFirestore: (snapshot, _) =>
                PostReport.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  // default PostReport ref
  DocumentReference<PostReport> postReportRef(String id) =>
      _firestore.doc(postReportPath(id)).withConverter(
            fromFirestore: (snapshot, _) =>
                PostReport.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  // get a PostReport future
  Future<PostReport?> fetchPostReport(String id) async {
    final snapshot = await postReportRef(id).get();
    return snapshot.data();
  }

  // get all PostReports for a post (PostReports list for a post)
  Query<PostReport> postReportsForPostRef(String postId) => postReportsRef()
      .where('postId', isEqualTo: postId)
      .orderBy('createdAt', descending: true);

  // Get all PostReport IDs when deleting a post
  // 포스트 삭제시 모든 포스트신고 아이디 가져오기
  Future<List<String>> getPostReportIdsForPost(String postId) async {
    final snapshot =
        await postReportsRef().where('postId', isEqualTo: postId).get();
    return snapshot.docs.map((e) => e.id).toList();
  }

  // Get post report IDs of the user and the posts written by the user
  // 회원 탈퇴시 사용자 및 사용자가 작성한 포스트의 포스트 신고 아이디 가져오기
  Future<List<String>> getPostReportIdsForClose(String uid) async {
    final snapshot = await postReportsRef()
        .where(Filter.or(Filter('uid', isEqualTo: uid),
            Filter('postWriterId', isEqualTo: uid)))
        .get();
    return snapshot.docs.map((e) => e.id).toList();
  }
}

@riverpod
PostReportsRepository postReportsRepository(Ref ref) {
  return PostReportsRepository(FirebaseFirestore.instance);
}

@riverpod
FutureOr<PostReport?> postReportFuture(Ref ref, String id) {
  return ref.watch(postReportsRepositoryProvider).fetchPostReport(id);
}

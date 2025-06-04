// lib/src/features/posts/data/post_reports_repository.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applimode_app/src/features/posts/domain/post_report.dart';

part 'post_reports_repository.g.dart';

// English: Repository for managing post reports in Firestore.
// Korean: Firestore에서 게시물 신고를 관리하는 리포지토리입니다.
class PostReportsRepository {
  const PostReportsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  // English: Returns the path for the postReports collection.
  // Korean: postReports 컬렉션의 경로를 반환합니다.
  static String postReportsPath() => 'postReports';
  // English: Returns the path for a specific postReport document.
  // Korean: 특정 postReport 문서의 경로를 반환합니다.
  static String postReportPath(String id) => 'postReports/$id';

  // English: Creates a new post report document in Firestore.
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

  // English: Deletes a post report document from Firestore.
  Future<void> deletePostReport(String id) =>
      _firestore.doc(postReportPath(id)).delete();

  // English: Returns a Firestore query for postReports with a converter.
  Query<PostReport> postReportsRef() =>
      _firestore.collection(postReportsPath()).withConverter(
            fromFirestore: (snapshot, _) =>
                PostReport.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  // English: Returns a document reference for a specific postReport with a converter.
  DocumentReference<PostReport> postReportRef(String id) =>
      _firestore.doc(postReportPath(id)).withConverter(
            fromFirestore: (snapshot, _) =>
                PostReport.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  // English: Fetches a single post report by its ID. Returns null if not found.
  Future<PostReport?> fetchPostReport(String id) async {
    final snapshot = await postReportRef(id).get();
    return snapshot.data();
  }

  // English: Returns a query for all reports associated with a specific post, ordered by creation date.
  Query<PostReport> postReportsForPostRef(String postId) => postReportsRef()
      .where('postId', isEqualTo: postId)
      .orderBy('createdAt', descending: true);

  // English: Fetches all postReport IDs associated with a specific post.
  // Korean: 특정 게시물과 관련된 모든 게시물 신고 ID를 가져옵니다.
  Future<List<String>> getPostReportIdsForPost(String postId) async {
    final snapshot =
        await postReportsRef().where('postId', isEqualTo: postId).get();
    return snapshot.docs.map((e) => e.id).toList();
  }

  // English: Fetches all postReport IDs created by a user or on posts written by that user.
  // Used for cleanup during account closure.
  // Korean: 사용자가 생성했거나 해당 사용자가 작성한 게시물에 대한 모든 게시물 신고 ID를 가져옵니다.
  // 계정 해지 시 정리에 사용됩니다.
  Future<List<String>> getPostReportIdsForClose(String uid) async {
    final snapshot = await postReportsRef()
        .where(Filter.or(Filter('uid', isEqualTo: uid),
            Filter('postWriterId', isEqualTo: uid)))
        .get();
    return snapshot.docs.map((e) => e.id).toList();
  }
}

// English: Riverpod provider for the PostReportsRepository.
// Korean: PostReportsRepository를 위한 Riverpod 프로바이더입니다.
@riverpod
PostReportsRepository postReportsRepository(Ref ref) {
  return PostReportsRepository(FirebaseFirestore.instance);
}

// English: Riverpod provider to fetch a single post report as a Future.
// Korean: 단일 게시물 신고를 Future로 가져오는 Riverpod 프로바이더입니다.
@riverpod
FutureOr<PostReport?> postReportFuture(Ref ref, String id) {
  return ref.watch(postReportsRepositoryProvider).fetchPostReport(id);
}

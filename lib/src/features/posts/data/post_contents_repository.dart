// lib/src/features/posts/data/post_contents_repository.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applimode_app/src/features/posts/domain/post_content.dart';

part 'post_contents_repository.g.dart';

// English: Repository for managing the content of posts, typically used for long posts
// where content is stored separately.
// Korean: 게시물의 내용을 관리하는 리포지토리로, 일반적으로 내용이 별도로 저장되는 긴 게시물에 사용됩니다.
class PostContentsRepository {
  const PostContentsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  // English: Returns the path for the postContents collection.
  // Korean: postContents 컬렉션의 경로를 반환합니다.
  static String postContentsPath() => 'postContents';
  // English: Returns the path for a specific postContent document.
  // Korean: 특정 postContent 문서의 경로를 반환합니다.
  static String postContentPath(String id) => 'postContents/$id';

  // English: Creates a new post content document in Firestore.
  // Korean: Firestore에 새 게시물 내용 문서를 생성합니다.
  Future<void> createPostContent({
    required String id,
    required String uid,
    String content = '',
    int category = 0,
  }) =>
      _firestore.doc(postContentPath(id)).set({
        'id': id,
        'uid': uid,
        'content': content,
        'category': category,
      });

  // English: Deletes a post content document from Firestore.
  // Korean: Firestore에서 게시물 내용 문서를 삭제합니다.
  Future<void> deletePostContent(String id) =>
      _firestore.doc(postContentPath(id)).delete();

  // English: Returns a Firestore query for postContents with a converter.
  // Korean: 변환기가 적용된 postContents에 대한 Firestore 쿼리를 반환합니다.
  Query<PostContent> postContentsRef() =>
      _firestore.collection(postContentsPath()).withConverter(
            fromFirestore: (snapshot, _) =>
                PostContent.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  // English: Returns a document reference for a specific postContent with a converter.
  // Korean: 변환기가 적용된 특정 postContent에 대한 문서 참조를 반환합니다.
  DocumentReference<PostContent> postContentRef(String id) =>
      _firestore.doc(postContentPath(id)).withConverter(
            fromFirestore: (snapshot, _) =>
                PostContent.fromMap(snapshot.data()!),
            toFirestore: (value, _) => value.toMap(),
          );

  // English: Fetches a single post content by its ID. Returns null if not found.
  // Korean: ID로 단일 게시물 내용을 가져옵니다. 찾을 수 없으면 null을 반환합니다.
  Future<PostContent?> fetchPostContent(String id) async {
    final snapshot = await postContentRef(id).get();
    return snapshot.data();
  }

  // English: Fetches a list of post content IDs for a given user.
  // Korean: 주어진 사용자의 게시물 내용 ID 목록을 가져옵니다.
  Future<List<String>> getPostContentIdsForUser(String uid) async {
    final query = await postContentsRef().where('uid', isEqualTo: uid).get();
    return query.docs.map((e) => e.id).toList();
  }
}

// English: Riverpod provider for the PostContentsRepository.
// Korean: PostContentsRepository를 위한 Riverpod 프로바이더입니다.
@riverpod
PostContentsRepository postContentsRepository(Ref ref) {
  return PostContentsRepository(FirebaseFirestore.instance);
}

// English: Riverpod provider to fetch a single post content as a Future.
// Korean: 단일 게시물 내용을 Future로 가져오는 Riverpod 프로바이더입니다.
@riverpod
FutureOr<PostContent?> postContentFuture(Ref ref, String id) {
  return ref.watch(postContentsRepositoryProvider).fetchPostContent(id);
}

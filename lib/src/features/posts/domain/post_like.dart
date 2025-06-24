// lib/src/features/posts/domain/post_like.dart

// flutter
import 'package:flutter/foundation.dart' show immutable;

// external
import 'package:equatable/equatable.dart';

// core
import 'package:applimode_app/src/core/constants/constants.dart';

// English: Represents a like or dislike action performed by a user on a post.
// Korean: 사용자가 게시물에 대해 수행한 좋아요 또는 싫어요 행동을 나타냅니다.
@immutable
class PostLike extends Equatable {
  // English: Constructor for creating a PostLike instance.
  // Korean: PostLike 인스턴스를 생성하기 위한 생성자입니다.
  const PostLike({
    required this.id,
    required this.uid,
    required this.postId,
    required this.postWriterId,
    this.isDislike = false,
    required this.createdAt,
  });

  // English: Unique identifier for the like/dislike record itself.
  // Korean: 좋아요/싫어요 기록 자체의 고유 식별자입니다.
  final String id;
  // English: Unique identifier of the user who performed the like/dislike action.
  // Korean: 좋아요/싫어요 행동을 수행한 사용자의 고유 식별자입니다.
  final String uid;
  // English: Unique identifier of the post that was liked/disliked.
  // Korean: 좋아요/싫어요 된 게시물의 고유 식별자입니다.
  final String postId;
  // English: Unique identifier of the user who wrote the post.
  // Korean: 게시물을 작성한 사용자의 고유 식별자입니다.
  final String postWriterId;
  // English: Flag indicating if this action is a dislike (true) or a like (false). Defaults to false (like).
  // Korean: 이 행동이 싫어요(true)인지 좋아요(false)인지를 나타내는 플래그입니다. 기본값은 false(좋아요)입니다.
  final bool isDislike;
  // English: Timestamp of when the like/dislike action was performed.
  // Korean: 좋아요/싫어요 행동이 수행된 타임스탬프입니다.
  final DateTime createdAt;

  // English: Creates a PostLike instance from a map (e.g., from Firestore).
  // Korean: 맵에서 PostLike 인스턴스를 생성합니다 (예: Firestore로부터).
  factory PostLike.fromMap(Map<String, dynamic> map) {
    final createdAtInt = map['createdAt'] as int;
    return PostLike(
      id: map['id'] as String,
      uid: map['uid'] as String,
      postId: map['postId'] as String,
      // English: Defaults to 'unknown' if postWriterId is missing in the map, ensuring robustness.
      // Korean: 맵에 postWriterId가 없는 경우 'unknown'으로 기본 설정되어 안정성을 보장합니다.
      postWriterId: map['postWriterId'] as String? ?? unknown,
      isDislike: map['isDislike'] as bool? ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtInt),
    );
  }

  // English: Converts the PostLike instance to a map (e.g., for Firestore).
  // Korean: PostLike 인스턴스를 맵으로 변환합니다 (예: Firestore로).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'postId': postId,
      'postWriterId': postWriterId,
      'isDislike': isDislike,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // English: Creates a copy of this PostLike instance with updated fields.
  // Korean: 업데이트된 필드로 이 PostLike 인스턴스의 복사본을 생성합니다.
  PostLike copyWith({
    String? id,
    String? uid,
    String? postId,
    String? postWriterId,
    bool? isDislike,
    DateTime? createdAt,
  }) {
    return PostLike(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      postId: postId ?? this.postId,
      postWriterId: postWriterId ?? this.postWriterId,
      isDislike: isDislike ?? this.isDislike,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  // English: Enables string representation for debugging.
  // Korean: 디버깅을 위한 문자열 표현을 활성화합니다.
  bool? get stringify => true;

  @override
  // English: Defines the properties used for equality comparison by Equatable.
  // Korean: Equatable에 의해 동등성 비교에 사용되는 속성을 정의합니다.
  List<Object?> get props => [
        id,
        uid,
        postId,
        postWriterId,
        isDislike,
        createdAt,
      ];
}

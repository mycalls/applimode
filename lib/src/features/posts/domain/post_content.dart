// lib/src/features/posts/domain/post_content.dart

// flutter
import 'package:flutter/foundation.dart' show immutable;

// external
import 'package:equatable/equatable.dart';

// English: Represents the separated, potentially long, textual content of a Post.
// Korean: 게시물의 분리된, 잠재적으로 긴, 텍스트 내용을 나타냅니다.
// This class is used when a Post's content exceeds a certain length (e.g., longContentSize from custom_settings.dart)
// to improve performance by not loading the full content with the main Post metadata.
// 이 클래스는 게시물의 내용이 특정 길이(예: custom_settings.dart의 longContentSize)를 초과할 때
// 주 게시물 메타데이터와 함께 전체 내용을 로드하지 않아 성능을 향상시키기 위해 사용됩니다.
@immutable
class PostContent extends Equatable {
  // English: Constructor for creating a PostContent instance.
  // Korean: PostContent 인스턴스를 생성하기 위한 생성자입니다.
  const PostContent({
    this.id = '',
    this.uid = '',
    this.content = '',
    this.category = 0,
  });

  // English: Unique identifier of the post this content belongs to.
  // Korean: 이 콘텐츠가 속한 게시물의 고유 식별자입니다.
  final String id;
  // English: Unique identifier of the user who created the post.
  // Korean: 게시물을 작성한 사용자의 고유 식별자입니다.
  final String uid;
  // English: The main textual content of the post.
  // Korean: 게시물의 주요 텍스트 내용입니다.
  final String content;
  // English: The category of the post.
  // Korean: 게시물의 카테고리입니다.
  final int category;

  // English: Creates a PostContent instance from a map (e.g., from Firestore).
  // Korean: 맵에서 PostContent 인스턴스를 생성합니다 (예: Firestore로부터).
  factory PostContent.fromMap(Map<String, dynamic> map) {
    return PostContent(
      id: map['id'] as String? ?? '',
      uid: map['uid'] as String? ?? '',
      content: map['content'] as String? ?? '',
      category: map['category'] as int? ?? 0,
    );
  }

  // English: Converts the PostContent instance to a map (e.g., for Firestore).
  // Korean: PostContent 인스턴스를 맵으로 변환합니다 (예: Firestore로).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'content': content,
      'category': category,
    };
  }

  // English: Creates a copy of this PostContent instance with updated fields.
  // Korean: 업데이트된 필드로 이 PostContent 인스턴스의 복사본을 생성합니다.
  PostContent copyWith({
    String? id,
    String? uid,
    String? content,
    int? category,
  }) {
    return PostContent(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      content: content ?? this.content,
      category: category ?? this.category,
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
        content,
        category,
      ];
}

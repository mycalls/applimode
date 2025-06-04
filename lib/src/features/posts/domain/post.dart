// lib/src/features/posts/domain/post.dart

import 'package:flutter/foundation.dart' show immutable;
import 'package:equatable/equatable.dart';

import 'package:applimode_app/src/constants/constants.dart';

// English: Represents a post in the application.
// Korean: 애플리케이션의 게시물을 나타냅니다.
@immutable
class Post extends Equatable {
  // English: Constructor for creating a Post instance.
  // Korean: Post 인스턴스를 생성하기 위한 생성자입니다.
  // Note: day, month, and year are typically used for database querying/indexing.
  // 참고: day, month, year는 일반적으로 데이터베이스 조회/인덱싱에 사용됩니다.
  const Post({
    required this.id,
    required this.uid,
    this.content = 'No content',
    this.title = '',
    this.needUpdate = false,
    this.isLongContent = false,
    this.isHeader = false,
    this.isBlock = false,
    this.isRecommended = false,
    this.isNoTitle = false,
    this.isNoWriter = false,
    this.category = 0,
    this.mainImageUrl,
    this.mainVideoUrl,
    this.mainVideoImageUrl,
    this.tags = const [],
    this.postCommentCount = 0,
    this.viewCount = 0,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.sumCount = 0,
    this.reportCount = 0,
    required this.day,
    required this.month,
    required this.year,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String uid;
  final String content;
  final String title;
  final bool needUpdate;
  final bool isLongContent;
  final bool isHeader;
  final bool isBlock;
  final bool isRecommended;
  final bool isNoTitle;
  final bool isNoWriter;
  final int category;
  final String? mainImageUrl;
  final String? mainVideoUrl;
  final String? mainVideoImageUrl;
  final List<String> tags;
  final int postCommentCount;
  final int viewCount;
  final int likeCount;
  final int dislikeCount;
  final int sumCount;
  final int reportCount;
  final int day;
  final int month;
  final int year;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory Post.fromMap(Map<String, dynamic> map) {
    final createdAtInt = map['createdAt'] as int;
    final updatedAtInt = map['updatedAt'] as int?;
    final createdDateTime = DateTime.fromMillisecondsSinceEpoch(createdAtInt);
    return Post(
      id: map['id'] as String,
      uid: map['uid'] as String,
      content: map['content'] as String? ?? 'No content',
      title: map['title'] as String? ?? '',
      needUpdate: map['needUpdate'] as bool? ?? false,
      isLongContent: map['isLongContent'] as bool? ?? false,
      isHeader: map['isHeader'] as bool? ?? false,
      isBlock: map['isBlock'] as bool? ?? false,
      isRecommended: map['isRecommended'] as bool? ?? false,
      isNoTitle: map['isNoTitle'] as bool? ?? false,
      isNoWriter: map['isNoWriter'] as bool? ?? false,
      category: map['category'] as int? ?? 0,
      mainImageUrl: map['mainImageUrl'] as String?,
      mainVideoUrl: map['mainVideoUrl'] as String?,
      mainVideoImageUrl: map['mainVideoImageUrl'] as String?,
      tags: map['tags'] == null
          ? []
          : (map['tags'] as List<dynamic>).map((e) => e as String).toList(),
      postCommentCount: map['postCommentCount'] as int? ?? 0,
      viewCount: map['viewCount'] as int? ?? 0,
      likeCount: map['likeCount'] as int? ?? 0,
      dislikeCount: map['dislikeCount'] as int? ?? 0,
      sumCount: map['sumCount'] as int? ?? 0,
      reportCount: map['reportCount'] as int? ?? 0,
      // English: Derive day, month, year from createdAt if not provided in the map.
      // Korean: 맵에 제공되지 않은 경우 createdAt에서 day, month, year를 파생합니다.
      day: map['day'] as int? ??
          (createdDateTime.year * 10000 +
              createdDateTime.month * 100 +
              createdDateTime.day),
      month: map['month'] as int? ??
          (createdDateTime.year * 100 + createdDateTime.month),
      year: map['year'] as int? ?? createdDateTime.year,
      createdAt: createdDateTime,
      updatedAt: updatedAtInt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(updatedAtInt),
    );
  }

  // English: Converts the Post instance to a map (e.g., for Firestore).
  // Korean: Post 인스턴스를 맵으로 변환합니다 (예: Firestore로).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'content': content,
      'title': title,
      'needUpdate': needUpdate,
      'isLongContent': isLongContent,
      'isHeader': isHeader,
      'isBlock': isBlock,
      'isRecommended': isRecommended,
      'isNoTitle': isNoTitle,
      'isNoWriter': isNoWriter,
      'category': category,
      'mainImageUrl': mainImageUrl,
      'mainVideoUrl': mainVideoUrl,
      'mainVideoImageUrl': mainVideoImageUrl,
      'tags': tags,
      'postCommentCount': postCommentCount,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'dislikeCount': dislikeCount,
      'sumCount': sumCount,
      'reportCount': reportCount,
      'day': day,
      'month': month,
      'year': year,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  // English: Creates a copy of this Post instance with updated fields.
  // Korean: 업데이트된 필드로 이 Post 인스턴스의 복사본을 생성합니다.
  Post copyWith({
    String? id,
    String? uid,
    String? content,
    String? title,
    bool? needUpdate,
    bool? isLongContent,
    bool? isHeader,
    bool? isBlock,
    bool? isRecommended,
    bool? isNoTitle,
    bool? isNoWriter,
    int? category,
    String? mainImageUrl,
    String? mainVideoUrl,
    String? mainVideoImageUrl,
    List<String>? tags,
    int? postCommentCount,
    int? viewCount,
    int? likeCount,
    int? dislikeCount,
    int? sumCount,
    int? reportCount,
    int? day,
    int? month,
    int? year,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Post(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      content: content ?? this.content,
      title: title ?? this.title,
      needUpdate: needUpdate ?? this.needUpdate,
      isLongContent: isLongContent ?? this.isLongContent,
      isHeader: isHeader ?? this.isHeader,
      isBlock: isBlock ?? this.isBlock,
      isRecommended: isRecommended ?? this.isRecommended,
      isNoTitle: isNoTitle ?? this.isNoTitle,
      isNoWriter: isNoWriter ?? this.isNoWriter,
      category: category ?? this.category,
      mainImageUrl: mainImageUrl ?? this.mainImageUrl,
      mainVideoUrl: mainVideoUrl ?? this.mainVideoUrl,
      mainVideoImageUrl: mainVideoImageUrl ?? this.mainVideoImageUrl,
      tags: tags ?? this.tags,
      postCommentCount: postCommentCount ?? this.postCommentCount,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      sumCount: sumCount ?? this.sumCount,
      reportCount: reportCount ?? this.reportCount,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // English: Factory method to create a placeholder "deleted" post.
  // Korean: "삭제된" 게시물 플레이스홀더를 생성하는 팩토리 메소드입니다.
  factory Post.deleted() {
    final now = DateTime.now();
    return Post(
      id: deleted,
      uid: deleted,
      day: now.year * 10000 + now.month * 100 + now.day,
      month: now.year * 100 + now.month,
      year: now.year,
      createdAt: now,
    );
  }

  @override
  bool? get stringify => true;

  // English: Defines the properties used for equality comparison by Equatable.
  // Korean: Equatable에 의해 동등성 비교에 사용되는 속성을 정의합니다.
  @override
  List<Object?> get props => [
        id,
        uid,
        content,
        title,
        needUpdate,
        isLongContent,
        isHeader,
        isBlock,
        isRecommended,
        isNoTitle,
        isNoWriter,
        category,
        mainImageUrl,
        mainVideoUrl,
        mainVideoImageUrl,
        tags,
        postCommentCount,
        viewCount,
        likeCount,
        dislikeCount,
        sumCount,
        reportCount,
        day,
        month,
        year,
        createdAt,
        updatedAt,
      ];
}

// English: Arguments class used for Riverpod providers that deal with a specific post.
// Korean: 특정 게시물을 다루는 Riverpod 프로바이더에 사용되는 인수 클래스입니다.
@immutable
class PostArgs {
  // English: Constructor for PostArgs.
  // Korean: PostArgs 생성자입니다.
  // postId: The ID of the post.
  // postId: 게시물의 ID입니다.
  // initialPost: Optional initial Post data to avoid immediate fetching if available.
  // initialPost: 사용 가능한 경우 즉시 가져오기를 피하기 위한 선택적 초기 Post 데이터입니다.
  const PostArgs(this.postId, [this.initialPost]);

  final String postId;
  final Post? initialPost;

  // English: Custom equality operator. Only compares postId.
  // Korean: 사용자 정의 동등 연산자입니다. postId만 비교합니다.
  // This is crucial for Riverpod: if only initialPost changes but postId is the same,
  // the provider might not need to rebuild if its core dependency is just the postId.
  // Riverpod에 중요: initialPost만 변경되고 postId가 동일한 경우,
  // 프로바이더의 핵심 종속성이 postId뿐이라면 재빌드할 필요가 없을 수 있습니다.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostArgs &&
        runtimeType == other.runtimeType &&
        postId ==
            other
                .postId; // English: Only compare postId! Korean: 오직 postId만 비교!
  }

  @override
  int get hashCode => postId.hashCode;
}

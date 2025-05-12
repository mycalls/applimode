import 'package:equatable/equatable.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class Post extends Equatable {
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
      day: map['day'] as int? ?? 20231106,
      month: map['month'] as int? ?? 202311,
      year: map['year'] as int? ?? 2023,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtInt),
      updatedAt: updatedAtInt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(updatedAtInt),
    );
  }

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

  factory Post.deleted() {
    return Post(
      id: deleted,
      uid: deleted,
      day: 20231106,
      month: 202311,
      year: 2023,
      createdAt: DateTime.now(),
    );
  }

  @override
  bool? get stringify => true;

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

@immutable
class PostArgs {
  const PostArgs(this.postId, [this.initialPost]);

  final String postId;
  final Post? initialPost;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostArgs &&
        runtimeType == other.runtimeType &&
        postId == other.postId; // 오직 documentId만 비교!
  }

  @override
  int get hashCode => postId.hashCode;
}

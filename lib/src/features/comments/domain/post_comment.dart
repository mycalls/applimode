import 'package:applimode_app/src/constants/constants.dart';
import 'package:equatable/equatable.dart';

class PostComment extends Equatable {
  const PostComment({
    required this.id,
    required this.uid,
    required this.postId,
    required this.parentCommentId,
    required this.postWriterId,
    this.isReply = false,
    this.content,
    this.imageUrl,
    this.replyCount = 0,
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
  final String postId;
  final String parentCommentId;
  final String postWriterId;
  final bool isReply;
  final String? content;
  final String? imageUrl;
  final int replyCount;
  final int likeCount;
  final int dislikeCount;
  final int sumCount;
  final int reportCount;
  final int day;
  final int month;
  final int year;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory PostComment.fromMap(Map<String, dynamic> map) {
    final createdAtInt = map['createdAt'] as int;
    final updatedAtInt = map['updatedAt'] as int?;
    return PostComment(
      id: map['id'] as String,
      uid: map['uid'] as String,
      postId: map['postId'] as String,
      parentCommentId: map['parentCommentId'] as String,
      postWriterId: map['postWriterId'] as String? ?? unknown,
      isReply: map['isReply'] as bool? ?? false,
      content: map['content'] as String?,
      imageUrl: map['imageUrl'] as String?,
      replyCount: map['replyCount'] as int? ?? 0,
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
      'postId': postId,
      'parentCommentId': parentCommentId,
      'postWriterId': postWriterId,
      'isReply': isReply,
      'content': content,
      'imageUrl': imageUrl,
      'replyCount': replyCount,
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

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        id,
        uid,
        postId,
        parentCommentId,
        postWriterId,
        isReply,
        content,
        imageUrl,
        replyCount,
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

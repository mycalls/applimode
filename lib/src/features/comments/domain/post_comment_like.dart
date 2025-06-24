// external
import 'package:equatable/equatable.dart';

// core
import 'package:applimode_app/src/core/constants/constants.dart';

class PostCommentLike extends Equatable {
  const PostCommentLike({
    required this.id,
    required this.uid,
    required this.postId,
    required this.commentId,
    required this.commentWriterId,
    required this.postWriterId,
    required this.parentCommentId,
    this.isDislike = false,
    required this.createdAt,
  });

  final String id;
  final String uid;
  final String postId;
  final String commentId;
  final String commentWriterId;
  final String postWriterId;
  final String parentCommentId;
  final bool isDislike;
  final DateTime createdAt;

  factory PostCommentLike.fromMap(Map<String, dynamic> map) {
    final createdAtInt = map['createdAt'] as int;
    return PostCommentLike(
      id: map['id'] as String,
      uid: map['uid'] as String,
      postId: map['postId'] as String,
      commentId: map['commentId'] as String,
      commentWriterId: map['commentWriterId'] as String? ?? unknown,
      postWriterId: map['postWriterId'] as String? ?? unknown,
      parentCommentId: map['parentCommentId'] as String? ?? unknown,
      isDislike: map['isDislike'] as bool? ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtInt),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'postId': postId,
      'commentId': commentId,
      'commentWriterId': commentWriterId,
      'postWriterId': postWriterId,
      'parentCommentId': parentCommentId,
      'isDislike': isDislike,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        id,
        uid,
        postId,
        commentId,
        commentWriterId,
        postWriterId,
        parentCommentId,
        isDislike,
        createdAt,
      ];
}

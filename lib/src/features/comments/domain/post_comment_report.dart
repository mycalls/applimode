import 'package:equatable/equatable.dart';

class PostCommentReport extends Equatable {
  const PostCommentReport({
    required this.id,
    required this.uid,
    required this.postId,
    required this.commentId,
    required this.commentWriterId,
    required this.postWriterId,
    required this.reportType,
    this.custom,
    required this.createdAt,
  });

  final String id;
  final String uid;
  final String postId;
  final String commentId;
  final String commentWriterId;
  final String postWriterId;
  final int reportType;
  final String? custom;
  final DateTime createdAt;

  factory PostCommentReport.fromMap(Map<String, dynamic> map) {
    final createdAtInt = map['createdAt'] as int;
    return PostCommentReport(
      id: map['id'] as String,
      uid: map['uid'] as String,
      postId: map['postId'] as String,
      commentId: map['commentId'] as String,
      commentWriterId: map['commentWriterId'] as String,
      postWriterId: map['postWriterId'] as String,
      reportType: map['reportType'] as int,
      custom: map['custom'] as String?,
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
      'reportType': reportType,
      'custom': custom,
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
        reportType,
        custom,
        createdAt,
      ];
}

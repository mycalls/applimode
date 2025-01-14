import 'package:equatable/equatable.dart';

class PostReport extends Equatable {
  const PostReport({
    required this.id,
    required this.uid,
    required this.postId,
    required this.postWriterId,
    required this.reportType,
    this.custom,
    required this.createdAt,
  });

  final String id;
  final String uid;
  final String postId;
  final String postWriterId;
  final int reportType;
  final String? custom;
  final DateTime createdAt;

  factory PostReport.fromMap(Map<String, dynamic> map) {
    final createdAtInt = map['createdAt'] as int;
    return PostReport(
      id: map['id'] as String,
      uid: map['uid'] as String,
      postId: map['postId'] as String,
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
        postWriterId,
        reportType,
        custom,
        createdAt,
      ];
}

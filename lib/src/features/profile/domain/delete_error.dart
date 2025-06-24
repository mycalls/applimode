// external
import 'package:equatable/equatable.dart';

class DeleteError extends Equatable {
  const DeleteError({
    required this.id,
    required this.uid,
    required this.errorType,
    required this.errorIdType,
    required this.errorId,
  });
  final String id;
  final String uid;
  final String errorType;
  final String errorIdType;
  final String errorId;

  factory DeleteError.fromMap(Map<String, dynamic> map) {
    return DeleteError(
      id: map['id'] as String,
      uid: map['uid'] as String,
      errorType: map['errorType'] as String,
      errorIdType: map['errorIdType'] as String,
      errorId: map['errorId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'errorType': errorType,
      'errorIdType': errorIdType,
      'errorId': errorId,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        id,
        uid,
        errorType,
        errorIdType,
        errorId,
      ];
}

enum DeleteErrorType {
  postMediaFromCloudflare,
  postMediaFromFirebase,
  postCommentMedia,
  postDOne,
  userPostMediaFromCloudflare,
  userPostMediaFromFirebase,
}

enum DeleteErrorIdType {
  uid,
  postId,
  commentId,
}

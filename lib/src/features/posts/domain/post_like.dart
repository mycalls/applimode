import 'package:applimode_app/src/constants/constants.dart';
import 'package:equatable/equatable.dart';

class PostLike extends Equatable {
  const PostLike({
    required this.id,
    required this.uid,
    required this.postId,
    required this.postWriterId,
    this.isDislike = false,
    required this.createdAt,
  });

  final String id;
  final String uid;
  final String postId;
  final String postWriterId;
  final bool isDislike;
  final DateTime createdAt;

  factory PostLike.fromMap(Map<String, dynamic> map) {
    final createdAtInt = map['createdAt'] as int;
    return PostLike(
      id: map['id'] as String,
      uid: map['uid'] as String,
      postId: map['postId'] as String,
      postWriterId: map['postWriterId'] as String? ?? unknown,
      isDislike: map['isDislike'] as bool? ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtInt),
    );
  }

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
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        id,
        uid,
        postId,
        postWriterId,
        isDislike,
        createdAt,
      ];
}

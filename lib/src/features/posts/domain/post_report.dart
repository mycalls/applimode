// lib/src/features/posts/domain/post_report.dart

// flutter
import 'package:flutter/foundation.dart' show immutable;

// external
import 'package:equatable/equatable.dart';

// English: Represents a report made by a user on a post.
// Korean: 사용자가 게시물에 대해 작성한 신고를 나타냅니다.
@immutable
class PostReport extends Equatable {
  // English: Constructor for creating a PostReport instance.
  // Korean: PostReport 인스턴스를 생성하기 위한 생성자입니다.
  const PostReport({
    required this.id,
    required this.uid,
    required this.postId,
    required this.postWriterId,
    required this.reportType,
    this.custom,
    required this.createdAt,
  });

  // English: Unique identifier for the report record itself.
  // Korean: 신고 기록 자체의 고유 식별자입니다.
  final String id;
  // English: Unique identifier of the user who made the report.
  // Korean: 신고를 한 사용자의 고유 식별자입니다.
  final String uid;
  // English: Unique identifier of the post that was reported.
  // Korean: 신고된 게시물의 고유 식별자입니다.
  final String postId;
  // English: Unique identifier of the user who wrote the reported post.
  // Korean: 신고된 게시물을 작성한 사용자의 고유 식별자입니다.
  final String postWriterId;
  // English: Type of report (e.g., spam, inappropriate content), represented as an integer.
  // Korean: 신고 유형 (예: 스팸, 부적절한 콘텐츠), 정수로 표현됩니다.
  final int reportType;
  // English: Optional custom text provided by the user for the report.
  // Korean: 사용자가 신고에 대해 제공한 선택적 사용자 정의 텍스트입니다.
  final String? custom;
  // English: Timestamp of when the report was made.
  // Korean: 신고가 이루어진 타임스탬프입니다.
  final DateTime createdAt;

  // English: Creates a PostReport instance from a map (e.g., from Firestore).
  // Korean: 맵에서 PostReport 인스턴스를 생성합니다 (예: Firestore로부터).
  factory PostReport.fromMap(Map<String, dynamic> map) {
    final createdAtInt = map['createdAt'] as int;
    return PostReport(
      id: map['id'] as String,
      uid: map['uid'] as String,
      postId: map['postId'] as String,
      // English: Assumes 'postWriterId' is always present in the map.
      // Korean: 맵에 'postWriterId'가 항상 존재한다고 가정합니다.
      postWriterId: map['postWriterId'] as String,
      // English: Assumes 'reportType' is always present in the map.
      // Korean: 맵에 'reportType'이 항상 존재한다고 가정합니다.
      reportType: map['reportType'] as int,
      custom: map['custom'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtInt),
    );
  }

  // English: Converts the PostReport instance to a map (e.g., for Firestore).
  // Korean: PostReport 인스턴스를 맵으로 변환합니다 (예: Firestore로).
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

  // English: Creates a copy of this PostReport instance with updated fields.
  // Korean: 업데이트된 필드로 이 PostReport 인스턴스의 복사본을 생성합니다.
  PostReport copyWith({
    String? id,
    String? uid,
    String? postId,
    String? postWriterId,
    int? reportType,
    String? custom,
    DateTime? createdAt,
  }) {
    return PostReport(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      postId: postId ?? this.postId,
      postWriterId: postWriterId ?? this.postWriterId,
      reportType: reportType ?? this.reportType,
      custom: custom ?? this.custom,
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
        reportType,
        custom,
        createdAt,
      ];
}

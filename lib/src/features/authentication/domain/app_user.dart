// external
import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.uid,
    required this.displayName,
    this.isAdmin = false,
    this.isBlock = false,
    this.isHideInfo = false,
    this.photoUrl,
    this.storyUrl,
    this.bio = '',
    this.gender = 0,
    this.birthday,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.sumCount = 0,
    this.verified = false,
    this.fcmToken,
  });

  final String uid;
  final String displayName;
  final bool isAdmin;
  final bool isBlock;
  final bool isHideInfo;
  final String? photoUrl;
  final String? storyUrl;
  final String bio;
  final int gender;
  final DateTime? birthday;
  final int likeCount;
  final int dislikeCount;
  final int sumCount;
  final bool verified;
  final String? fcmToken;

  factory AppUser.fromMap(Map<String, dynamic> map) {
    final birthDayInt = map['birthday'] as int?;
    return AppUser(
      uid: map['uid'] as String,
      displayName: map['displayName'] as String? ?? 'Unknown',
      isAdmin: map['isAdmin'] as bool? ?? false,
      isBlock: map['isBlock'] as bool? ?? false,
      isHideInfo: map['isHideInfo'] as bool? ?? false,
      photoUrl: map['photoUrl'] as String?,
      storyUrl: map['storyUrl'] as String?,
      bio: map['bio'] as String? ?? '',
      gender: map['gender'] as int? ?? 0,
      birthday: birthDayInt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(birthDayInt),
      likeCount: map['likeCount'] as int? ?? 0,
      dislikeCount: map['dislikeCount'] as int? ?? 0,
      sumCount: map['sumCount'] as int? ?? 0,
      verified: map['verified'] as bool? ?? false,
      fcmToken: map['fcmToken'] as String?,
    );
  }

  factory AppUser.failed(String uid) {
    return AppUser(
      uid: uid,
      displayName: 'User',
    );
  }

  factory AppUser.loading(String uid) {
    return AppUser(
      uid: uid,
      displayName: 'Loading...',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'isAdmin': isAdmin,
      'isBlock': isBlock,
      'isHideInfo': isHideInfo,
      'photoUrl': photoUrl,
      'storyUrl': storyUrl,
      'bio': bio,
      'gender': gender,
      'birthday': birthday?.millisecondsSinceEpoch,
      'likeCount': likeCount,
      'dislikeCount': dislikeCount,
      'sumCount': sumCount,
      'verified': verified,
      'fcmToken': fcmToken,
    };
  }

  AppUser copyWith({
    String? uid,
    String? displayName,
    bool? isAdmin,
    bool? isBlock,
    bool? isHideInfo,
    String? photoUrl,
    String? storyUrl,
    String? bio,
    int? gender,
    DateTime? birthday,
    int? likeCount,
    int? dislikeCount,
    int? sumCount,
    bool? verified,
    String? fcmToken,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      isAdmin: isAdmin ?? this.isAdmin,
      isBlock: isBlock ?? this.isBlock,
      isHideInfo: isHideInfo ?? this.isHideInfo,
      photoUrl: photoUrl ?? this.photoUrl,
      storyUrl: storyUrl ?? this.storyUrl,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      sumCount: sumCount ?? this.sumCount,
      verified: verified ?? this.verified,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        uid,
        displayName,
        isAdmin,
        isBlock,
        isHideInfo,
        photoUrl,
        storyUrl,
        bio,
        gender,
        birthday,
        likeCount,
        dislikeCount,
        sumCount,
        verified,
        fcmToken,
      ];
}

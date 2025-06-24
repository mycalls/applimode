import 'dart:convert';

// external
import 'package:equatable/equatable.dart';

class UserPrompt extends Equatable {
  const UserPrompt({
    required this.uid,
    this.prompts = const [],
    this.predefinedPrompt = '',
  });

  final String uid;
  final List<String> prompts;
  final String predefinedPrompt;

  factory UserPrompt.fromMap(Map<String, dynamic> map) {
    return UserPrompt(
      uid: map['uid'] as String,
      prompts:
          (json.decode((map['prompts'] as String?) ?? '[]') as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      predefinedPrompt: map['predefinedPrompt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'prompts': json.encode(prompts),
      'predefinedPrompt': predefinedPrompt,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [uid, prompts, predefinedPrompt];
}

import 'dart:convert';

// external
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// features
import 'package:applimode_app/src/features/prompts/domain/user_prompt.dart';

part 'user_prompts_repository.g.dart';

class UserPromptsRepository {
  const UserPromptsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static String userPromptsPath() => 'userPrompts';
  static String userPromptPath(String id) => 'userPrompts/$id';

  Future<void> createUserPrompt({
    required String id,
    List<String> prompts = const [],
    String predefinedPrompt = '',
  }) =>
      _firestore.doc(userPromptPath(id)).set({
        'uid': id,
        'prompts': json.encode(prompts),
        'predefinedPrompt': predefinedPrompt,
      });

  Future<void> deleteUserPrompt(String id) =>
      _firestore.doc(userPromptPath(id)).delete();

  Query<UserPrompt> userPromptsRef() =>
      _firestore.collection(userPromptsPath()).withConverter(
            fromFirestore: (snapshot, _) =>
                UserPrompt.fromMap(snapshot.data() ?? {}),
            toFirestore: (value, _) => value.toMap(),
          );

  DocumentReference<UserPrompt> userPromptDocRef(String id) =>
      _firestore.doc(userPromptPath(id)).withConverter(
          fromFirestore: (snapshot, _) => UserPrompt.fromMap(snapshot.data()!),
          toFirestore: (value, _) => value.toMap());

  Future<UserPrompt?> fetchUserPrompt(String id) async {
    final snapshot = await userPromptDocRef(id).get();
    return snapshot.data();
  }

  Stream<UserPrompt?> watchUserPrompt(String id) =>
      userPromptDocRef(id).snapshots().map((event) => event.data());

  Future<List<String>> getUserPromptIdsForUser(String uid) async {
    final query = await userPromptsRef().where('uid', isEqualTo: uid).get();
    return query.docs.map((e) => e.id).toList();
  }
}

@Riverpod(keepAlive: true)
UserPromptsRepository userPromptsRepository(Ref ref) {
  return UserPromptsRepository(FirebaseFirestore.instance);
}

@Riverpod(keepAlive: true)
Stream<UserPrompt?> userPromptStream(Ref ref, String id) {
  final repository = ref.watch(userPromptsRepositoryProvider);
  return repository.watchUserPrompt(id);
}

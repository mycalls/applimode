// external
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  const AuthRepository(this._auth);

  final FirebaseAuth _auth;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

  Future<void> updateEmail(String newEmail) async {
    if (_auth.currentUser == null) {
      return;
    }
    await _auth.currentUser!.verifyBeforeUpdateEmail(newEmail);
  }

  Future<void> updatePassword(String newPassword) async {
    if (_auth.currentUser == null) {
      return;
    }
    await _auth.currentUser!.updatePassword(newPassword);
  }

  Future<void> updateDisplayName(String displayName) async {
    if (_auth.currentUser == null) {
      return;
    }
    await _auth.currentUser!.updateDisplayName(displayName);
  }

  Future<void> updatePhotoUrl(String? photoUrl) async {
    if (_auth.currentUser == null) {
      return;
    }
    await _auth.currentUser!.updatePhotoURL(photoUrl);
  }

  Future<void> updateMetadata({
    required String displayName,
    String? photoUrl,
  }) async {
    if (_auth.currentUser == null) {
      return;
    }
    await _auth.currentUser!.updateDisplayName(displayName);
    await _auth.currentUser!.updatePhotoURL(photoUrl);
  }

  Future<void> signOut() => _auth.signOut();

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> reauthenticateWithCredential(
          AuthCredential credential) =>
      _auth.currentUser!.reauthenticateWithCredential(credential);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(FirebaseAuth.instance);
}

@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}

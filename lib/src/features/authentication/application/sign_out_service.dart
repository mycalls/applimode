import 'dart:developer' as dev;

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// features
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/application/fcm_auth_service.dart';

part 'sign_out_service.g.dart';

class SignOutService {
  const SignOutService(this._ref);

  final Ref _ref;

  Future<void> signOut() async {
    final user = _ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      try {
        await _ref.read(fcmAuthServiceProvider).tokenToEmpty(user.uid);
      } catch (e) {
        dev.log('user token is not exist');
      }
    }
    await _ref.read(authRepositoryProvider).signOut();
    // _ref.invalidate(authStateChangesProvider);
  }
}

@riverpod
SignOutService signOutService(Ref ref) {
  return SignOutService(ref);
}

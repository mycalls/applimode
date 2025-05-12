// import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/utils/fcm_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_service.g.dart';

class SignOutService {
  const SignOutService(this._ref);

  final Ref _ref;

  Future<void> signOut() async {
    final user = _ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await _ref.read(fcmServiceProvider).tokenToEmpty(user.uid);
    }
    await _ref.read(authRepositoryProvider).signOut();
    // _ref.invalidate(authStateChangesProvider);
  }
}

@riverpod
SignOutService signOutService(Ref ref) {
  return SignOutService(ref);
}

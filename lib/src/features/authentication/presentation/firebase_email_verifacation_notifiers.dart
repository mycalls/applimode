// lib/src/features/authentication/presentation/firebase_email_verifacation_notifiers.dart

// external
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_email_verifacation_notifiers.g.dart';

@riverpod
class IsResendLock extends _$IsResendLock {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }

  void setTrue() {
    state = true;
  }

  void setFalse() {
    state = false;
  }
}

@riverpod
class IsCheckLock extends _$IsCheckLock {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }

  void setTrue() {
    state = true;
  }

  void setFalse() {
    state = false;
  }
}

@riverpod
class IsGoBack extends _$IsGoBack {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }

  void setTrue() {
    state = true;
  }

  void setFalse() {
    state = false;
  }
}

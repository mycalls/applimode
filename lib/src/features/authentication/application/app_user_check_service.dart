// lib/src/features/authentication/application/app_user_check_service.dart

import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';

part 'app_user_check_service.g.dart';

// Service class for managing app user-specific checks and operations,
// such as initializing a new user.
// 앱 사용자 관련 확인 및 작업(예: 신규 사용자 초기화)을 관리하는 서비스 클래스입니다.
class AppUserCheckService {
  const AppUserCheckService(this._ref);

  final Ref _ref;

  // Initializes a new app user.
  // This involves:
  // 1. Generating an initial display name.
  // 2. Updating the user's metadata in the authentication provider (e.g., Firebase Auth).
  // 3. Creating a corresponding user document in the application's database (e.g., Firestore).
  //
  // 신규 앱 사용자를 초기화합니다.
  // 이 과정은 다음을 포함합니다:
  // 1. 초기 표시 이름 생성.
  // 2. 인증 공급자(예: Firebase Auth)에서 사용자 메타데이터 업데이트.
  // 3. 애플리케이션의 데이터베이스(예: Firestore)에 해당 사용자 문서 생성.
  Future<void> initializeAppUser(String uid) async {
    dev.log('Initializing app user $uid');

    // Generate a random number suffix for the initial display name.
    // This helps in providing a default unique-enough display name.
    // 초기 표시 이름에 사용할 랜덤 숫자 접미사를 생성합니다.
    // 이는 기본적으로 충분히 고유한 표시 이름을 제공하는 데 도움이 됩니다.
    final initialId = (Random().nextInt(999999) + 1).toString();
    final displayName = 'User$initialId';

    try {
      // Step 1: Update the user's display name in the authentication provider.
      // 1단계: 인증 공급자에서 사용자의 표시 이름을 업데이트합니다.
      await _ref
          .read(authRepositoryProvider)
          .updateMetadata(displayName: displayName);

      // Step 2: Create the user document in the application's database with default values.
      // 2단계: 애플리케이션의 데이터베이스에 기본값으로 사용자 문서를 생성합니다.
      await _ref.read(appUserRepositoryProvider).createAppUser(
            uid: uid,
            displayName: displayName,
            isAdmin:
                false, // New users are not admins by default. // 신규 사용자는 기본적으로 관리자가 아님.
            isBlock:
                false, // New users are not blocked by default. // 신규 사용자는 기본적으로 차단되지 않음.
            isHideInfo:
                false, // User info is not hidden by default. // 사용자 정보는 기본적으로 숨겨지지 않음.
            bio: '', // Default empty bio. // 기본 빈 자기소개.
            gender:
                0, // Default gender (e.g., 0 for unspecified). // 기본 성별 (예: 0은 미지정).
            likeCount: 0,
            dislikeCount: 0,
            sumCount: 0,
            verified:
                false, // New users are not verified by default. // 신규 사용자는 기본적으로 인증되지 않음.
          );
    } catch (e) {
      // If any step fails, log the error and rethrow to allow higher-level error handling.
      // 단계 중 하나라도 실패하면 오류를 기록하고 상위 수준에서 오류를 처리할 수 있도록 다시 던집니다.
      // Consider more sophisticated error handling or rollback mechanisms for production.
      // 프로덕션 환경에서는 더 정교한 오류 처리 또는 롤백 메커니즘을 고려하십시오.
      dev.log(
          'Error initializing app user $uid: $e'); // Replace with proper logging. // 적절한 로깅으로 대체하십시오.
      rethrow;
    }
  }
}

@riverpod
AppUserCheckService appUserCheckService(Ref ref) {
  return AppUserCheckService(ref);
}

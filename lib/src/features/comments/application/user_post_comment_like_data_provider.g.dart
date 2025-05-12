// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_post_comment_like_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userPostCommentLikeDataHash() =>
    r'97a599fd7d807bccdaadd42f610a0b99954f6352';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$UserPostCommentLikeData
    extends BuildlessAutoDisposeAsyncNotifier<List<PostCommentLike>> {
  late final String commentId;
  late final String uid;

  FutureOr<List<PostCommentLike>> build({
    required String commentId,
    required String uid,
  });
}

/// See also [UserPostCommentLikeData].
@ProviderFor(UserPostCommentLikeData)
const userPostCommentLikeDataProvider = UserPostCommentLikeDataFamily();

/// See also [UserPostCommentLikeData].
class UserPostCommentLikeDataFamily
    extends Family<AsyncValue<List<PostCommentLike>>> {
  /// See also [UserPostCommentLikeData].
  const UserPostCommentLikeDataFamily();

  /// See also [UserPostCommentLikeData].
  UserPostCommentLikeDataProvider call({
    required String commentId,
    required String uid,
  }) {
    return UserPostCommentLikeDataProvider(
      commentId: commentId,
      uid: uid,
    );
  }

  @override
  UserPostCommentLikeDataProvider getProviderOverride(
    covariant UserPostCommentLikeDataProvider provider,
  ) {
    return call(
      commentId: provider.commentId,
      uid: provider.uid,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userPostCommentLikeDataProvider';
}

/// See also [UserPostCommentLikeData].
class UserPostCommentLikeDataProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserPostCommentLikeData,
        List<PostCommentLike>> {
  /// See also [UserPostCommentLikeData].
  UserPostCommentLikeDataProvider({
    required String commentId,
    required String uid,
  }) : this._internal(
          () => UserPostCommentLikeData()
            ..commentId = commentId
            ..uid = uid,
          from: userPostCommentLikeDataProvider,
          name: r'userPostCommentLikeDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userPostCommentLikeDataHash,
          dependencies: UserPostCommentLikeDataFamily._dependencies,
          allTransitiveDependencies:
              UserPostCommentLikeDataFamily._allTransitiveDependencies,
          commentId: commentId,
          uid: uid,
        );

  UserPostCommentLikeDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.commentId,
    required this.uid,
  }) : super.internal();

  final String commentId;
  final String uid;

  @override
  FutureOr<List<PostCommentLike>> runNotifierBuild(
    covariant UserPostCommentLikeData notifier,
  ) {
    return notifier.build(
      commentId: commentId,
      uid: uid,
    );
  }

  @override
  Override overrideWith(UserPostCommentLikeData Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserPostCommentLikeDataProvider._internal(
        () => create()
          ..commentId = commentId
          ..uid = uid,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        commentId: commentId,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserPostCommentLikeData,
      List<PostCommentLike>> createElement() {
    return _UserPostCommentLikeDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPostCommentLikeDataProvider &&
        other.commentId == commentId &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, commentId.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserPostCommentLikeDataRef
    on AutoDisposeAsyncNotifierProviderRef<List<PostCommentLike>> {
  /// The parameter `commentId` of this provider.
  String get commentId;

  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserPostCommentLikeDataProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserPostCommentLikeData,
        List<PostCommentLike>> with UserPostCommentLikeDataRef {
  _UserPostCommentLikeDataProviderElement(super.provider);

  @override
  String get commentId => (origin as UserPostCommentLikeDataProvider).commentId;
  @override
  String get uid => (origin as UserPostCommentLikeDataProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_post_like_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userPostLikeDataHash() => r'521cf2d60b5e32018c20f63d806499e237a8db27';

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

abstract class _$UserPostLikeData
    extends BuildlessAutoDisposeAsyncNotifier<List<PostLike>> {
  late final String postId;
  late final String uid;

  FutureOr<List<PostLike>> build({
    required String postId,
    required String uid,
  });
}

/// See also [UserPostLikeData].
@ProviderFor(UserPostLikeData)
const userPostLikeDataProvider = UserPostLikeDataFamily();

/// See also [UserPostLikeData].
class UserPostLikeDataFamily extends Family<AsyncValue<List<PostLike>>> {
  /// See also [UserPostLikeData].
  const UserPostLikeDataFamily();

  /// See also [UserPostLikeData].
  UserPostLikeDataProvider call({
    required String postId,
    required String uid,
  }) {
    return UserPostLikeDataProvider(
      postId: postId,
      uid: uid,
    );
  }

  @override
  UserPostLikeDataProvider getProviderOverride(
    covariant UserPostLikeDataProvider provider,
  ) {
    return call(
      postId: provider.postId,
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
  String? get name => r'userPostLikeDataProvider';
}

/// See also [UserPostLikeData].
class UserPostLikeDataProvider extends AutoDisposeAsyncNotifierProviderImpl<
    UserPostLikeData, List<PostLike>> {
  /// See also [UserPostLikeData].
  UserPostLikeDataProvider({
    required String postId,
    required String uid,
  }) : this._internal(
          () => UserPostLikeData()
            ..postId = postId
            ..uid = uid,
          from: userPostLikeDataProvider,
          name: r'userPostLikeDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userPostLikeDataHash,
          dependencies: UserPostLikeDataFamily._dependencies,
          allTransitiveDependencies:
              UserPostLikeDataFamily._allTransitiveDependencies,
          postId: postId,
          uid: uid,
        );

  UserPostLikeDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
    required this.uid,
  }) : super.internal();

  final String postId;
  final String uid;

  @override
  FutureOr<List<PostLike>> runNotifierBuild(
    covariant UserPostLikeData notifier,
  ) {
    return notifier.build(
      postId: postId,
      uid: uid,
    );
  }

  @override
  Override overrideWith(UserPostLikeData Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserPostLikeDataProvider._internal(
        () => create()
          ..postId = postId
          ..uid = uid,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserPostLikeData, List<PostLike>>
      createElement() {
    return _UserPostLikeDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPostLikeDataProvider &&
        other.postId == postId &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserPostLikeDataRef
    on AutoDisposeAsyncNotifierProviderRef<List<PostLike>> {
  /// The parameter `postId` of this provider.
  String get postId;

  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserPostLikeDataProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserPostLikeData,
        List<PostLike>> with UserPostLikeDataRef {
  _UserPostLikeDataProviderElement(super.provider);

  @override
  String get postId => (origin as UserPostLikeDataProvider).postId;
  @override
  String get uid => (origin as UserPostLikeDataProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

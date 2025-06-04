// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_post_dislike_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userPostDislikeDataHash() =>
    r'f615baa80b614a3fad788ae6187536b4dacda441';

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

abstract class _$UserPostDislikeData
    extends BuildlessAutoDisposeAsyncNotifier<List<PostLike>> {
  late final String postId;
  late final String uid;

  FutureOr<List<PostLike>> build({
    required String postId,
    required String uid,
  });
}

/// See also [UserPostDislikeData].
@ProviderFor(UserPostDislikeData)
const userPostDislikeDataProvider = UserPostDislikeDataFamily();

/// See also [UserPostDislikeData].
class UserPostDislikeDataFamily extends Family<AsyncValue<List<PostLike>>> {
  /// See also [UserPostDislikeData].
  const UserPostDislikeDataFamily();

  /// See also [UserPostDislikeData].
  UserPostDislikeDataProvider call({
    required String postId,
    required String uid,
  }) {
    return UserPostDislikeDataProvider(
      postId: postId,
      uid: uid,
    );
  }

  @override
  UserPostDislikeDataProvider getProviderOverride(
    covariant UserPostDislikeDataProvider provider,
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
  String? get name => r'userPostDislikeDataProvider';
}

/// See also [UserPostDislikeData].
class UserPostDislikeDataProvider extends AutoDisposeAsyncNotifierProviderImpl<
    UserPostDislikeData, List<PostLike>> {
  /// See also [UserPostDislikeData].
  UserPostDislikeDataProvider({
    required String postId,
    required String uid,
  }) : this._internal(
          () => UserPostDislikeData()
            ..postId = postId
            ..uid = uid,
          from: userPostDislikeDataProvider,
          name: r'userPostDislikeDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userPostDislikeDataHash,
          dependencies: UserPostDislikeDataFamily._dependencies,
          allTransitiveDependencies:
              UserPostDislikeDataFamily._allTransitiveDependencies,
          postId: postId,
          uid: uid,
        );

  UserPostDislikeDataProvider._internal(
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
    covariant UserPostDislikeData notifier,
  ) {
    return notifier.build(
      postId: postId,
      uid: uid,
    );
  }

  @override
  Override overrideWith(UserPostDislikeData Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserPostDislikeDataProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<UserPostDislikeData, List<PostLike>>
      createElement() {
    return _UserPostDislikeDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPostDislikeDataProvider &&
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
mixin UserPostDislikeDataRef
    on AutoDisposeAsyncNotifierProviderRef<List<PostLike>> {
  /// The parameter `postId` of this provider.
  String get postId;

  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserPostDislikeDataProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserPostDislikeData,
        List<PostLike>> with UserPostDislikeDataRef {
  _UserPostDislikeDataProviderElement(super.provider);

  @override
  String get postId => (origin as UserPostDislikeDataProvider).postId;
  @override
  String get uid => (origin as UserPostDislikeDataProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

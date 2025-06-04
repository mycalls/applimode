// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postsRepositoryHash() => r'd68ea794e1d217eff7c1a7c7d30fd3504db41cca';

/// See also [postsRepository].
@ProviderFor(postsRepository)
final postsRepositoryProvider = Provider<PostsRepository>.internal(
  postsRepository,
  name: r'postsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PostsRepositoryRef = ProviderRef<PostsRepository>;
String _$postFutureHash() => r'925d2b9c27645134940ea9861890f8c86da5522c';

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

/// See also [postFuture].
@ProviderFor(postFuture)
const postFutureProvider = PostFutureFamily();

/// See also [postFuture].
class PostFutureFamily extends Family<AsyncValue<Post?>> {
  /// See also [postFuture].
  const PostFutureFamily();

  /// See also [postFuture].
  PostFutureProvider call(
    String id,
  ) {
    return PostFutureProvider(
      id,
    );
  }

  @override
  PostFutureProvider getProviderOverride(
    covariant PostFutureProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'postFutureProvider';
}

/// See also [postFuture].
class PostFutureProvider extends AutoDisposeFutureProvider<Post?> {
  /// See also [postFuture].
  PostFutureProvider(
    String id,
  ) : this._internal(
          (ref) => postFuture(
            ref as PostFutureRef,
            id,
          ),
          from: postFutureProvider,
          name: r'postFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postFutureHash,
          dependencies: PostFutureFamily._dependencies,
          allTransitiveDependencies:
              PostFutureFamily._allTransitiveDependencies,
          id: id,
        );

  PostFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Post?> Function(PostFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostFutureProvider._internal(
        (ref) => create(ref as PostFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Post?> createElement() {
    return _PostFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostFutureProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostFutureRef on AutoDisposeFutureProviderRef<Post?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PostFutureProviderElement extends AutoDisposeFutureProviderElement<Post?>
    with PostFutureRef {
  _PostFutureProviderElement(super.provider);

  @override
  String get id => (origin as PostFutureProvider).id;
}

String _$postStreamHash() => r'ed2dca018507a9e1be49fd23da960d2d7c698519';

/// See also [postStream].
@ProviderFor(postStream)
const postStreamProvider = PostStreamFamily();

/// See also [postStream].
class PostStreamFamily extends Family<AsyncValue<Post?>> {
  /// See also [postStream].
  const PostStreamFamily();

  /// See also [postStream].
  PostStreamProvider call(
    String id,
  ) {
    return PostStreamProvider(
      id,
    );
  }

  @override
  PostStreamProvider getProviderOverride(
    covariant PostStreamProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'postStreamProvider';
}

/// See also [postStream].
class PostStreamProvider extends AutoDisposeStreamProvider<Post?> {
  /// See also [postStream].
  PostStreamProvider(
    String id,
  ) : this._internal(
          (ref) => postStream(
            ref as PostStreamRef,
            id,
          ),
          from: postStreamProvider,
          name: r'postStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postStreamHash,
          dependencies: PostStreamFamily._dependencies,
          allTransitiveDependencies:
              PostStreamFamily._allTransitiveDependencies,
          id: id,
        );

  PostStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<Post?> Function(PostStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostStreamProvider._internal(
        (ref) => create(ref as PostStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Post?> createElement() {
    return _PostStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostStreamProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostStreamRef on AutoDisposeStreamProviderRef<Post?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PostStreamProviderElement extends AutoDisposeStreamProviderElement<Post?>
    with PostStreamRef {
  _PostStreamProviderElement(super.provider);

  @override
  String get id => (origin as PostStreamProvider).id;
}

String _$mainPostsFutureHash() => r'267ea740990d273e33cff59ab5ac8e521a8967a5';

/// See also [mainPostsFuture].
@ProviderFor(mainPostsFuture)
final mainPostsFutureProvider = AutoDisposeFutureProvider<List<Post>>.internal(
  mainPostsFuture,
  name: r'mainPostsFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mainPostsFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MainPostsFutureRef = AutoDisposeFutureProviderRef<List<Post>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

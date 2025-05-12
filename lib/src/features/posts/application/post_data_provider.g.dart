// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postDataHash() => r'60b86f7f306eeab5da23675b1b028447c8c59d69';

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

abstract class _$PostData extends BuildlessAutoDisposeAsyncNotifier<Post?> {
  late final PostArgs arg;

  FutureOr<Post?> build(
    PostArgs arg,
  );
}

/// See also [PostData].
@ProviderFor(PostData)
const postDataProvider = PostDataFamily();

/// See also [PostData].
class PostDataFamily extends Family<AsyncValue<Post?>> {
  /// See also [PostData].
  const PostDataFamily();

  /// See also [PostData].
  PostDataProvider call(
    PostArgs arg,
  ) {
    return PostDataProvider(
      arg,
    );
  }

  @override
  PostDataProvider getProviderOverride(
    covariant PostDataProvider provider,
  ) {
    return call(
      provider.arg,
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
  String? get name => r'postDataProvider';
}

/// See also [PostData].
class PostDataProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PostData, Post?> {
  /// See also [PostData].
  PostDataProvider(
    PostArgs arg,
  ) : this._internal(
          () => PostData()..arg = arg,
          from: postDataProvider,
          name: r'postDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postDataHash,
          dependencies: PostDataFamily._dependencies,
          allTransitiveDependencies: PostDataFamily._allTransitiveDependencies,
          arg: arg,
        );

  PostDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.arg,
  }) : super.internal();

  final PostArgs arg;

  @override
  FutureOr<Post?> runNotifierBuild(
    covariant PostData notifier,
  ) {
    return notifier.build(
      arg,
    );
  }

  @override
  Override overrideWith(PostData Function() create) {
    return ProviderOverride(
      origin: this,
      override: PostDataProvider._internal(
        () => create()..arg = arg,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        arg: arg,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PostData, Post?> createElement() {
    return _PostDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostDataProvider && other.arg == arg;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, arg.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostDataRef on AutoDisposeAsyncNotifierProviderRef<Post?> {
  /// The parameter `arg` of this provider.
  PostArgs get arg;
}

class _PostDataProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PostData, Post?>
    with PostDataRef {
  _PostDataProviderElement(super.provider);

  @override
  PostArgs get arg => (origin as PostDataProvider).arg;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

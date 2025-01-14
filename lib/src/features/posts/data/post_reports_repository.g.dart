// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_reports_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postReportsRepositoryHash() =>
    r'05eb68b06d9692041af2286bc96e9fc103ed18b4';

/// See also [postReportsRepository].
@ProviderFor(postReportsRepository)
final postReportsRepositoryProvider =
    AutoDisposeProvider<PostReportsRepository>.internal(
  postReportsRepository,
  name: r'postReportsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postReportsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PostReportsRepositoryRef
    = AutoDisposeProviderRef<PostReportsRepository>;
String _$postReportFutureHash() => r'1e8de49ca94553c39b5b54a74c970ecc8fd8243b';

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

/// See also [postReportFuture].
@ProviderFor(postReportFuture)
const postReportFutureProvider = PostReportFutureFamily();

/// See also [postReportFuture].
class PostReportFutureFamily extends Family<AsyncValue<PostReport?>> {
  /// See also [postReportFuture].
  const PostReportFutureFamily();

  /// See also [postReportFuture].
  PostReportFutureProvider call(
    String id,
  ) {
    return PostReportFutureProvider(
      id,
    );
  }

  @override
  PostReportFutureProvider getProviderOverride(
    covariant PostReportFutureProvider provider,
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
  String? get name => r'postReportFutureProvider';
}

/// See also [postReportFuture].
class PostReportFutureProvider extends AutoDisposeFutureProvider<PostReport?> {
  /// See also [postReportFuture].
  PostReportFutureProvider(
    String id,
  ) : this._internal(
          (ref) => postReportFuture(
            ref as PostReportFutureRef,
            id,
          ),
          from: postReportFutureProvider,
          name: r'postReportFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postReportFutureHash,
          dependencies: PostReportFutureFamily._dependencies,
          allTransitiveDependencies:
              PostReportFutureFamily._allTransitiveDependencies,
          id: id,
        );

  PostReportFutureProvider._internal(
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
    FutureOr<PostReport?> Function(PostReportFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostReportFutureProvider._internal(
        (ref) => create(ref as PostReportFutureRef),
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
  AutoDisposeFutureProviderElement<PostReport?> createElement() {
    return _PostReportFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostReportFutureProvider && other.id == id;
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
mixin PostReportFutureRef on AutoDisposeFutureProviderRef<PostReport?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PostReportFutureProviderElement
    extends AutoDisposeFutureProviderElement<PostReport?>
    with PostReportFutureRef {
  _PostReportFutureProviderElement(super.provider);

  @override
  String get id => (origin as PostReportFutureProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

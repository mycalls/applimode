// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postCommentReportsRepositoryHash() =>
    r'97daef198ac1ac97e6ade9d58f213695f29a5696';

/// See also [postCommentReportsRepository].
@ProviderFor(postCommentReportsRepository)
final postCommentReportsRepositoryProvider =
    AutoDisposeProvider<PostCommentReportsRepository>.internal(
  postCommentReportsRepository,
  name: r'postCommentReportsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postCommentReportsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PostCommentReportsRepositoryRef
    = AutoDisposeProviderRef<PostCommentReportsRepository>;
String _$postCommentReportFutureHash() =>
    r'c6db27e5cdd04194332985ef7644a7b1277c6e9b';

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

/// See also [postCommentReportFuture].
@ProviderFor(postCommentReportFuture)
const postCommentReportFutureProvider = PostCommentReportFutureFamily();

/// See also [postCommentReportFuture].
class PostCommentReportFutureFamily
    extends Family<AsyncValue<PostCommentReport?>> {
  /// See also [postCommentReportFuture].
  const PostCommentReportFutureFamily();

  /// See also [postCommentReportFuture].
  PostCommentReportFutureProvider call(
    String id,
  ) {
    return PostCommentReportFutureProvider(
      id,
    );
  }

  @override
  PostCommentReportFutureProvider getProviderOverride(
    covariant PostCommentReportFutureProvider provider,
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
  String? get name => r'postCommentReportFutureProvider';
}

/// See also [postCommentReportFuture].
class PostCommentReportFutureProvider
    extends AutoDisposeFutureProvider<PostCommentReport?> {
  /// See also [postCommentReportFuture].
  PostCommentReportFutureProvider(
    String id,
  ) : this._internal(
          (ref) => postCommentReportFuture(
            ref as PostCommentReportFutureRef,
            id,
          ),
          from: postCommentReportFutureProvider,
          name: r'postCommentReportFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postCommentReportFutureHash,
          dependencies: PostCommentReportFutureFamily._dependencies,
          allTransitiveDependencies:
              PostCommentReportFutureFamily._allTransitiveDependencies,
          id: id,
        );

  PostCommentReportFutureProvider._internal(
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
    FutureOr<PostCommentReport?> Function(PostCommentReportFutureRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostCommentReportFutureProvider._internal(
        (ref) => create(ref as PostCommentReportFutureRef),
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
  AutoDisposeFutureProviderElement<PostCommentReport?> createElement() {
    return _PostCommentReportFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostCommentReportFutureProvider && other.id == id;
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
mixin PostCommentReportFutureRef
    on AutoDisposeFutureProviderRef<PostCommentReport?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PostCommentReportFutureProviderElement
    extends AutoDisposeFutureProviderElement<PostCommentReport?>
    with PostCommentReportFutureRef {
  _PostCommentReportFutureProviderElement(super.provider);

  @override
  String get id => (origin as PostCommentReportFutureProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

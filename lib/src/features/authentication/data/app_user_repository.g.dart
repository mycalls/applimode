// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appUserRepositoryHash() => r'8890477e717c841288e37a53f4fdb58ff928d3d4';

/// See also [appUserRepository].
@ProviderFor(appUserRepository)
final appUserRepositoryProvider = Provider<AppUserRepository>.internal(
  appUserRepository,
  name: r'appUserRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appUserRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppUserRepositoryRef = ProviderRef<AppUserRepository>;
String _$appUserFutureHash() => r'a53ebafc72e0d77d5abfc30c35d90cabf9a0c7f4';

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

/// See also [appUserFuture].
@ProviderFor(appUserFuture)
const appUserFutureProvider = AppUserFutureFamily();

/// See also [appUserFuture].
class AppUserFutureFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [appUserFuture].
  const AppUserFutureFamily();

  /// See also [appUserFuture].
  AppUserFutureProvider call(
    String uid,
  ) {
    return AppUserFutureProvider(
      uid,
    );
  }

  @override
  AppUserFutureProvider getProviderOverride(
    covariant AppUserFutureProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'appUserFutureProvider';
}

/// See also [appUserFuture].
class AppUserFutureProvider extends FutureProvider<AppUser?> {
  /// See also [appUserFuture].
  AppUserFutureProvider(
    String uid,
  ) : this._internal(
          (ref) => appUserFuture(
            ref as AppUserFutureRef,
            uid,
          ),
          from: appUserFutureProvider,
          name: r'appUserFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$appUserFutureHash,
          dependencies: AppUserFutureFamily._dependencies,
          allTransitiveDependencies:
              AppUserFutureFamily._allTransitiveDependencies,
          uid: uid,
        );

  AppUserFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    FutureOr<AppUser?> Function(AppUserFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AppUserFutureProvider._internal(
        (ref) => create(ref as AppUserFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  FutureProviderElement<AppUser?> createElement() {
    return _AppUserFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AppUserFutureProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AppUserFutureRef on FutureProviderRef<AppUser?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _AppUserFutureProviderElement extends FutureProviderElement<AppUser?>
    with AppUserFutureRef {
  _AppUserFutureProviderElement(super.provider);

  @override
  String get uid => (origin as AppUserFutureProvider).uid;
}

String _$appUserStreamHash() => r'b9776fde9ee85618609922a08315ebf6ccae64ae';

/// See also [appUserStream].
@ProviderFor(appUserStream)
const appUserStreamProvider = AppUserStreamFamily();

/// See also [appUserStream].
class AppUserStreamFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [appUserStream].
  const AppUserStreamFamily();

  /// See also [appUserStream].
  AppUserStreamProvider call(
    String uid,
  ) {
    return AppUserStreamProvider(
      uid,
    );
  }

  @override
  AppUserStreamProvider getProviderOverride(
    covariant AppUserStreamProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'appUserStreamProvider';
}

/// See also [appUserStream].
class AppUserStreamProvider extends AutoDisposeStreamProvider<AppUser?> {
  /// See also [appUserStream].
  AppUserStreamProvider(
    String uid,
  ) : this._internal(
          (ref) => appUserStream(
            ref as AppUserStreamRef,
            uid,
          ),
          from: appUserStreamProvider,
          name: r'appUserStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$appUserStreamHash,
          dependencies: AppUserStreamFamily._dependencies,
          allTransitiveDependencies:
              AppUserStreamFamily._allTransitiveDependencies,
          uid: uid,
        );

  AppUserStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    Stream<AppUser?> Function(AppUserStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AppUserStreamProvider._internal(
        (ref) => create(ref as AppUserStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<AppUser?> createElement() {
    return _AppUserStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AppUserStreamProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AppUserStreamRef on AutoDisposeStreamProviderRef<AppUser?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _AppUserStreamProviderElement
    extends AutoDisposeStreamProviderElement<AppUser?> with AppUserStreamRef {
  _AppUserStreamProviderElement(super.provider);

  @override
  String get uid => (origin as AppUserStreamProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appUserDataHash() => r'bc5e9e641f1ba9b757b3ec4337ec62211a586fef';

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

abstract class _$AppUserData
    extends BuildlessAutoDisposeAsyncNotifier<AppUser?> {
  late final String appUserId;

  FutureOr<AppUser?> build(
    String appUserId,
  );
}

/// See also [AppUserData].
@ProviderFor(AppUserData)
const appUserDataProvider = AppUserDataFamily();

/// See also [AppUserData].
class AppUserDataFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [AppUserData].
  const AppUserDataFamily();

  /// See also [AppUserData].
  AppUserDataProvider call(
    String appUserId,
  ) {
    return AppUserDataProvider(
      appUserId,
    );
  }

  @override
  AppUserDataProvider getProviderOverride(
    covariant AppUserDataProvider provider,
  ) {
    return call(
      provider.appUserId,
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
  String? get name => r'appUserDataProvider';
}

/// See also [AppUserData].
class AppUserDataProvider
    extends AutoDisposeAsyncNotifierProviderImpl<AppUserData, AppUser?> {
  /// See also [AppUserData].
  AppUserDataProvider(
    String appUserId,
  ) : this._internal(
          () => AppUserData()..appUserId = appUserId,
          from: appUserDataProvider,
          name: r'appUserDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$appUserDataHash,
          dependencies: AppUserDataFamily._dependencies,
          allTransitiveDependencies:
              AppUserDataFamily._allTransitiveDependencies,
          appUserId: appUserId,
        );

  AppUserDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.appUserId,
  }) : super.internal();

  final String appUserId;

  @override
  FutureOr<AppUser?> runNotifierBuild(
    covariant AppUserData notifier,
  ) {
    return notifier.build(
      appUserId,
    );
  }

  @override
  Override overrideWith(AppUserData Function() create) {
    return ProviderOverride(
      origin: this,
      override: AppUserDataProvider._internal(
        () => create()..appUserId = appUserId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        appUserId: appUserId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AppUserData, AppUser?>
      createElement() {
    return _AppUserDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AppUserDataProvider && other.appUserId == appUserId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, appUserId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AppUserDataRef on AutoDisposeAsyncNotifierProviderRef<AppUser?> {
  /// The parameter `appUserId` of this provider.
  String get appUserId;
}

class _AppUserDataProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AppUserData, AppUser?>
    with AppUserDataRef {
  _AppUserDataProviderElement(super.provider);

  @override
  String get appUserId => (origin as AppUserDataProvider).appUserId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

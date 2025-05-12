// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_post_comment_dislike_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userPostCommentDislikeDataHash() =>
    r'bbb20c585e60f1c040f176d565bc30601ca670eb';

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

abstract class _$UserPostCommentDislikeData
    extends BuildlessAutoDisposeAsyncNotifier<List<PostCommentLike>> {
  late final String commentId;
  late final String uid;

  FutureOr<List<PostCommentLike>> build({
    required String commentId,
    required String uid,
  });
}

/// See also [UserPostCommentDislikeData].
@ProviderFor(UserPostCommentDislikeData)
const userPostCommentDislikeDataProvider = UserPostCommentDislikeDataFamily();

/// See also [UserPostCommentDislikeData].
class UserPostCommentDislikeDataFamily
    extends Family<AsyncValue<List<PostCommentLike>>> {
  /// See also [UserPostCommentDislikeData].
  const UserPostCommentDislikeDataFamily();

  /// See also [UserPostCommentDislikeData].
  UserPostCommentDislikeDataProvider call({
    required String commentId,
    required String uid,
  }) {
    return UserPostCommentDislikeDataProvider(
      commentId: commentId,
      uid: uid,
    );
  }

  @override
  UserPostCommentDislikeDataProvider getProviderOverride(
    covariant UserPostCommentDislikeDataProvider provider,
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
  String? get name => r'userPostCommentDislikeDataProvider';
}

/// See also [UserPostCommentDislikeData].
class UserPostCommentDislikeDataProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserPostCommentDislikeData,
        List<PostCommentLike>> {
  /// See also [UserPostCommentDislikeData].
  UserPostCommentDislikeDataProvider({
    required String commentId,
    required String uid,
  }) : this._internal(
          () => UserPostCommentDislikeData()
            ..commentId = commentId
            ..uid = uid,
          from: userPostCommentDislikeDataProvider,
          name: r'userPostCommentDislikeDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userPostCommentDislikeDataHash,
          dependencies: UserPostCommentDislikeDataFamily._dependencies,
          allTransitiveDependencies:
              UserPostCommentDislikeDataFamily._allTransitiveDependencies,
          commentId: commentId,
          uid: uid,
        );

  UserPostCommentDislikeDataProvider._internal(
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
    covariant UserPostCommentDislikeData notifier,
  ) {
    return notifier.build(
      commentId: commentId,
      uid: uid,
    );
  }

  @override
  Override overrideWith(UserPostCommentDislikeData Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserPostCommentDislikeDataProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<UserPostCommentDislikeData,
      List<PostCommentLike>> createElement() {
    return _UserPostCommentDislikeDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPostCommentDislikeDataProvider &&
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
mixin UserPostCommentDislikeDataRef
    on AutoDisposeAsyncNotifierProviderRef<List<PostCommentLike>> {
  /// The parameter `commentId` of this provider.
  String get commentId;

  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserPostCommentDislikeDataProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserPostCommentDislikeData,
        List<PostCommentLike>> with UserPostCommentDislikeDataRef {
  _UserPostCommentDislikeDataProviderElement(super.provider);

  @override
  String get commentId =>
      (origin as UserPostCommentDislikeDataProvider).commentId;
  @override
  String get uid => (origin as UserPostCommentDislikeDataProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

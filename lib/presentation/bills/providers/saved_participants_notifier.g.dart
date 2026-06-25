// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_participants_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cross-bill participant library. Source of truth lives on the server
/// (`public.user_saved_participants`) and is mirrored to a local
/// SharedPreferences cache for offline-first suggestions.
///
/// Read path: `build()` returns the local cache immediately so the split
/// dialog can render chips before any network round trip. A fire-and-forget
/// refresh from the server runs in parallel and patches the cache + state
/// when it completes.
///
/// Write path: [bump] optimistically patches the cache + state, then fires
/// the server `bump_saved_participant` RPC. The local patch is optimistic
/// (best-effort UX); the server RPC is authoritative.

@ProviderFor(SavedParticipantsNotifier)
const savedParticipantsProvider = SavedParticipantsNotifierProvider._();

/// Cross-bill participant library. Source of truth lives on the server
/// (`public.user_saved_participants`) and is mirrored to a local
/// SharedPreferences cache for offline-first suggestions.
///
/// Read path: `build()` returns the local cache immediately so the split
/// dialog can render chips before any network round trip. A fire-and-forget
/// refresh from the server runs in parallel and patches the cache + state
/// when it completes.
///
/// Write path: [bump] optimistically patches the cache + state, then fires
/// the server `bump_saved_participant` RPC. The local patch is optimistic
/// (best-effort UX); the server RPC is authoritative.
final class SavedParticipantsNotifierProvider
    extends
        $AsyncNotifierProvider<
          SavedParticipantsNotifier,
          List<SavedParticipant>
        > {
  /// Cross-bill participant library. Source of truth lives on the server
  /// (`public.user_saved_participants`) and is mirrored to a local
  /// SharedPreferences cache for offline-first suggestions.
  ///
  /// Read path: `build()` returns the local cache immediately so the split
  /// dialog can render chips before any network round trip. A fire-and-forget
  /// refresh from the server runs in parallel and patches the cache + state
  /// when it completes.
  ///
  /// Write path: [bump] optimistically patches the cache + state, then fires
  /// the server `bump_saved_participant` RPC. The local patch is optimistic
  /// (best-effort UX); the server RPC is authoritative.
  const SavedParticipantsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedParticipantsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedParticipantsNotifierHash();

  @$internal
  @override
  SavedParticipantsNotifier create() => SavedParticipantsNotifier();
}

String _$savedParticipantsNotifierHash() =>
    r'254d53e8ac517695bf1adacb1c5093f9ecb85f44';

/// Cross-bill participant library. Source of truth lives on the server
/// (`public.user_saved_participants`) and is mirrored to a local
/// SharedPreferences cache for offline-first suggestions.
///
/// Read path: `build()` returns the local cache immediately so the split
/// dialog can render chips before any network round trip. A fire-and-forget
/// refresh from the server runs in parallel and patches the cache + state
/// when it completes.
///
/// Write path: [bump] optimistically patches the cache + state, then fires
/// the server `bump_saved_participant` RPC. The local patch is optimistic
/// (best-effort UX); the server RPC is authoritative.

abstract class _$SavedParticipantsNotifier
    extends $AsyncNotifier<List<SavedParticipant>> {
  FutureOr<List<SavedParticipant>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<SavedParticipant>>, List<SavedParticipant>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SavedParticipant>>,
                List<SavedParticipant>
              >,
              AsyncValue<List<SavedParticipant>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

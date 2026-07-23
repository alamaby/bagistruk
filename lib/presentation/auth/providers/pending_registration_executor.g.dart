// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_registration_executor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PendingRegistrationExecutor)
const pendingRegistrationExecutorProvider =
    PendingRegistrationExecutorProvider._();

final class PendingRegistrationExecutorProvider
    extends $AsyncNotifierProvider<PendingRegistrationExecutor, void> {
  const PendingRegistrationExecutorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingRegistrationExecutorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingRegistrationExecutorHash();

  @$internal
  @override
  PendingRegistrationExecutor create() => PendingRegistrationExecutor();
}

String _$pendingRegistrationExecutorHash() =>
    r'6871a1c6094577334c98c995abb992fe565e8906';

abstract class _$PendingRegistrationExecutor extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

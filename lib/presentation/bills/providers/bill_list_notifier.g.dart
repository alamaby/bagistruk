// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Async-loaded list of bills for the current user. Uses [AsyncValue] so the
/// UI gets standard loading / data / error rendering for free.

@ProviderFor(BillListNotifier)
const billListProvider = BillListNotifierProvider._();

/// Async-loaded list of bills for the current user. Uses [AsyncValue] so the
/// UI gets standard loading / data / error rendering for free.
final class BillListNotifierProvider
    extends $AsyncNotifierProvider<BillListNotifier, List<Bill>> {
  /// Async-loaded list of bills for the current user. Uses [AsyncValue] so the
  /// UI gets standard loading / data / error rendering for free.
  const BillListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'billListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$billListNotifierHash();

  @$internal
  @override
  BillListNotifier create() => BillListNotifier();
}

String _$billListNotifierHash() => r'b2b4b794a33d7e43fca0eb09ad5b8ac1fd73f19a';

/// Async-loaded list of bills for the current user. Uses [AsyncValue] so the
/// UI gets standard loading / data / error rendering for free.

abstract class _$BillListNotifier extends $AsyncNotifier<List<Bill>> {
  FutureOr<List<Bill>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Bill>>, List<Bill>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Bill>>, List<Bill>>,
              AsyncValue<List<Bill>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(DeletedBillListNotifier)
const deletedBillListProvider = DeletedBillListNotifierProvider._();

final class DeletedBillListNotifierProvider
    extends $AsyncNotifierProvider<DeletedBillListNotifier, List<DeletedBill>> {
  const DeletedBillListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deletedBillListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deletedBillListNotifierHash();

  @$internal
  @override
  DeletedBillListNotifier create() => DeletedBillListNotifier();
}

String _$deletedBillListNotifierHash() =>
    r'056968a4cc41d8b6e95f23e2befa10b6fdb0325c';

abstract class _$DeletedBillListNotifier
    extends $AsyncNotifier<List<DeletedBill>> {
  FutureOr<List<DeletedBill>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<DeletedBill>>, List<DeletedBill>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<DeletedBill>>, List<DeletedBill>>,
              AsyncValue<List<DeletedBill>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

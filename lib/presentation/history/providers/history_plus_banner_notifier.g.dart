// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_plus_banner_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HistoryPlusBanner)
const historyPlusBannerProvider = HistoryPlusBannerProvider._();

final class HistoryPlusBannerProvider
    extends $AsyncNotifierProvider<HistoryPlusBanner, bool> {
  const HistoryPlusBannerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyPlusBannerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyPlusBannerHash();

  @$internal
  @override
  HistoryPlusBanner create() => HistoryPlusBanner();
}

String _$historyPlusBannerHash() => r'9a380ab65721204cf4e731189fee33c82844e2b3';

abstract class _$HistoryPlusBanner extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

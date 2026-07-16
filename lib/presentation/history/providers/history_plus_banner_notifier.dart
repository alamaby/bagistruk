import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/providers.dart';

part 'history_plus_banner_notifier.g.dart';

@Riverpod(keepAlive: true)
class HistoryPlusBanner extends _$HistoryPlusBanner {
  @override
  Future<bool> build() async {
    final prefs = await ref.watch(historyPlusBannerPreferencesProvider.future);
    return prefs.isDismissed();
  }

  Future<void> dismiss() async {
    final prefs = await ref.read(historyPlusBannerPreferencesProvider.future);
    await prefs.dismiss();
    state = const AsyncData(true);
  }
}

class PlusFeatureLimits {
  const PlusFeatureLimits._();

  static const anonymousHistoryDays = 0;
  static const freeHistoryDays = 7;
  static const plusHistoryDays = 90;

  static int historyDays({required String? planCode}) => switch (planCode) {
    'plus' => plusHistoryDays,
    'free' => freeHistoryDays,
    _ => anonymousHistoryDays,
  };

  static DateTime? historyCutoff({required String? planCode, DateTime? now}) {
    final days = historyDays(planCode: planCode);
    if (days <= 0) return null;
    final base = (now ?? DateTime.now()).toUtc();
    return base.subtract(Duration(days: days));
  }
}

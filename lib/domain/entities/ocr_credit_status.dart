class OcrCreditStatus {
  const OcrCreditStatus({
    required this.planCode,
    required this.balance,
    required this.monthlyAllowance,
    required this.adsEnabled,
    required this.plusFeaturesEnabled,
    this.currentPeriodEnd,
    this.anonymousDeviceUsed = 0,
    this.anonymousDeviceLimit = 0,
  });

  final String planCode;
  final int balance;
  final int monthlyAllowance;
  final DateTime? currentPeriodEnd;
  final bool adsEnabled;
  final bool plusFeaturesEnabled;
  final int anonymousDeviceUsed;
  final int anonymousDeviceLimit;

  bool get isAnonymous => planCode == 'anonymous';
  bool get isFree => planCode == 'free';
  bool get isPlus => planCode == 'plus';

  factory OcrCreditStatus.fromJson(Map<String, dynamic> json) {
    final periodEnd = json['current_period_end'];
    return OcrCreditStatus(
      planCode: json['plan_code']?.toString() ?? 'free',
      balance: _readInt(json['balance']),
      monthlyAllowance: _readInt(json['monthly_allowance']),
      currentPeriodEnd: periodEnd == null
          ? null
          : DateTime.tryParse(periodEnd.toString()),
      adsEnabled: _readBool(json['ads_enabled'], fallback: true),
      plusFeaturesEnabled: _readBool(json['plus_features_enabled']),
      anonymousDeviceUsed: _readInt(json['anonymous_device_used']),
      anonymousDeviceLimit: _readInt(json['anonymous_device_limit']),
    );
  }

  static int _readInt(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _readBool(Object? value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value == null) return fallback;
    return value.toString().toLowerCase() == 'true';
  }
}

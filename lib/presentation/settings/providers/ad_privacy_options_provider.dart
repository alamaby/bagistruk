import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ads/ad_service.dart';

final adPrivacyOptionsRequiredProvider = FutureProvider<bool>((ref) {
  return AdService.isPrivacyOptionsRequired();
});

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/ads/ad_config.dart';
import '../../../core/ads/ad_service.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../presentation/settings/providers/profile_notifier.dart';
import '../../credits/providers/ocr_credit_status_provider.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key, required this.placement});

  final BannerAdPlacement placement;

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final creditStatusAsync = ref.watch(ocrCreditStatusProvider);
    if (creditStatusAsync.isLoading) return const SizedBox.shrink();
    final creditStatus = switch (creditStatusAsync) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (creditStatus?.adsEnabled == false) return const SizedBox.shrink();

    // Re-load the banner when the profile's `isAdult` flag changes so the
    // next ad request carries the updated UMP underage tag. We listen
    // rather than watch so we only act on changes, not on initial build.
    ref.listen<UserProfile?>(
      profileProvider.select(
        (s) => switch (s) {
          AsyncData(:final value) => value,
          _ => null,
        },
      ),
      (prev, next) {
        final wasMinor = !(prev?.isAdult ?? false);
        final isMinor = !(next?.isAdult ?? false);
        if (wasMinor != isMinor && _loaded) {
          _ad?.dispose();
          _ad = null;
          _loaded = false;
          _load();
        }
      },
    );

    final ad = _ad;
    if (!_loaded || ad == null) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Center(
          child: SizedBox(
            width: ad.size.width.toDouble(),
            height: ad.size.height.toDouble(),
            child: AdWidget(ad: ad),
          ),
        ),
      ),
    );
  }

  void _load() {
    unawaited(_loadAd());
  }

  Future<void> _loadAd() async {
    final unitId = AdConfig.bannerAdUnitId(widget.placement);
    if (!AdConfig.adsEnabled || unitId == null) return;

    final canRequestAds = await AdService.canRequestAds();
    if (!mounted || !canRequestAds) return;

    final ad = BannerAd(
      adUnitId: unitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _ad = null;
            _loaded = false;
          });
        },
      ),
    );

    _ad = ad;
    unawaited(ad.load());
  }
}

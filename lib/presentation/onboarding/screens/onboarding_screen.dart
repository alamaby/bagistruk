import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/error/result.dart';
import '../../../core/router/routes.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../providers/onboarding_notifier.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, this.isReplay = false});

  final bool isReplay;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;
  bool _submitting = false;

  bool get _busy => _submitting;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Top bar: skip button (first-run only) + page indicator
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        activeDotColor: Theme.of(context).colorScheme.primary,
                        dotColor: Theme.of(context).colorScheme.outlineVariant,
                        dotHeight: 8.h,
                        dotWidth: 8.w,
                        expansionFactor: 3,
                      ),
                    ),
                    if (!widget.isReplay)
                      TextButton(
                        onPressed: _busy ? null : () => _finish(),
                        child: Text(l10n.onboardingSkip),
                      )
                    else
                      SizedBox(width: 64.w),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  physics: _busy
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  onPageChanged: (i) => setState(() => _index = i),
                  children: [
                    _page(
                      l10n.onboardingTitle1,
                      l10n.onboardingBody1,
                      Icons.document_scanner,
                    ),
                    _page(
                      l10n.onboardingTitle2,
                      l10n.onboardingBody2,
                      Icons.people_alt,
                    ),
                    _page(
                      l10n.onboardingTitle3,
                      l10n.onboardingBody3,
                      Icons.send,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24.r),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _busy
                        ? null
                        : _index == 2
                            ? _finish
                            : () => _controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                ),
                    child: _busy
                        ? SizedBox(
                            height: 20.r,
                            width: 20.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            _index == 2
                                ? (widget.isReplay
                                    ? l10n.onboardingReplayFinish
                                    : l10n.onboardingFinish)
                                : l10n.onboardingNext,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _page(String title, String body, IconData icon) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 100.r, color: scheme.primary),
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _finish() async {
    if (widget.isReplay) {
      if (mounted) context.pop();
      return;
    }

    setState(() => _submitting = true);
    final res = await ref
        .read(onboardingProvider.notifier)
        .completeOnboarding();
    if (!mounted) return;

    setState(() => _submitting = false);

    switch (res) {
      case Success<void>():
        context.go(Routes.scan);
      case ResultFailure<void>():
        _showError(AppL10n.of(context).onboardingSaveError);
    }
  }

  void _showError(String message) {
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: scheme.errorContainer,
          content: Text(
            message,
            style: TextStyle(color: scheme.onErrorContainer),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class SmoothPageIndicator extends StatelessWidget {
  const SmoothPageIndicator({
    super.key,
    required this.controller,
    required this.count,
    required this.effect,
  });

  final PageController controller;
  final int count;
  final ExpandingDotsEffect effect;

  @override
  Widget build(BuildContext context) {
    return _SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: effect,
    );
  }
}

class ExpandingDotsEffect {
  const ExpandingDotsEffect({
    required this.activeDotColor,
    required this.dotColor,
    required this.dotHeight,
    required this.dotWidth,
    required this.expansionFactor,
  });

  final Color activeDotColor;
  final Color dotColor;
  final double dotHeight;
  final double dotWidth;
  final int expansionFactor;
}

class _SmoothPageIndicator extends StatefulWidget {
  const _SmoothPageIndicator({
    required this.controller,
    required this.count,
    required this.effect,
  });

  final PageController controller;
  final int count;
  final ExpandingDotsEffect effect;

  @override
  State<_SmoothPageIndicator> createState() => _SmoothPageIndicatorState();
}

class _SmoothPageIndicatorState extends State<_SmoothPageIndicator> {
  int _current = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    final page = widget.controller.page?.round() ?? 0;
    if (page != _current) setState(() => _current = page);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.count, (i) {
        final isActive = i == _current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          width: isActive
              ? widget.effect.dotWidth * widget.effect.expansionFactor
              : widget.effect.dotWidth,
          height: widget.effect.dotHeight,
          decoration: BoxDecoration(
            color:
                isActive ? widget.effect.activeDotColor : widget.effect.dotColor,
            borderRadius: BorderRadius.circular(999.r),
          ),
        );
      }),
    );
  }
}

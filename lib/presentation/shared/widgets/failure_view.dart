import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/error/failure.dart';
import '../../../l10n/generated/app_l10n.dart';

class FailureView extends StatelessWidget {
  const FailureView({super.key, required this.failure, this.onRetry});
  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppL10n.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: scheme.error, size: 48.r),
            SizedBox(height: 12.h),
            Text(
              _label(failure, l10n),
              style: TextStyle(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 16.h),
              FilledButton.tonal(
                onPressed: onRetry,
                child: Text(l10n.failureRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _label(Failure f, AppL10n l10n) => switch (f) {
    NetworkFailure(:final message) => l10n.failurePrefixNetwork(message),
    ServerFailure(:final message, :final code) => code != null
        ? l10n.failurePrefixServer(code.toString(), message)
        : l10n.failurePrefixServerNoCode(message),
    ParsingFailure(:final message) => l10n.failurePrefixParsing(message),
    AuthFailure(:final message) => l10n.failurePrefixAuth(message),
    UnknownFailure(:final error) => l10n.failurePrefixUnexpected(error.toString()),
  };
}

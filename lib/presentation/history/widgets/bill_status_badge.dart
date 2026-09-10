import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entities/bill_payment_status.dart';

/// Compact status badge for history rows: a tinted circular icon whose color
/// encodes the payment status at a glance. The text label stays in the row
/// subtitle — color alone is never the only signal.
class BillStatusBadge extends StatelessWidget {
  const BillStatusBadge({
    super.key,
    required this.status,
    required this.semanticLabel,
  });

  final BillPaymentStatus status;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (icon, color) = switch (status) {
      BillPaymentStatus.unassigned => (
        Icons.call_split_outlined,
        scheme.outline,
      ),
      BillPaymentStatus.unpaid => (
        Icons.schedule_outlined,
        scheme.error,
      ),
      BillPaymentStatus.partial => (
        Icons.pie_chart_outline,
        scheme.tertiary,
      ),
      BillPaymentStatus.settled => (
        Icons.check_circle_outline,
        scheme.primary,
      ),
    };
    return Tooltip(
      message: semanticLabel,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20.r, color: color),
      ),
    );
  }
}

import 'package:bagistruk/domain/entities/bill_payment_status.dart';
import 'package:bagistruk/presentation/history/widgets/bill_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/widget_test_harness.dart';

void main() {
  Future<void> pumpBadge(WidgetTester tester, BillPaymentStatus status) async {
    setTestViewport(tester);
    await tester.pumpWidget(
      buildTestApp(
        child: BillStatusBadge(status: status, semanticLabel: 'label-$status'),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('BillStatusBadge', () {
    testWidgets('each status maps to a distinct icon', (tester) async {
      final icons = <BillPaymentStatus, IconData>{
        BillPaymentStatus.unassigned: Icons.call_split_outlined,
        BillPaymentStatus.unpaid: Icons.schedule_outlined,
        BillPaymentStatus.partial: Icons.pie_chart_outline,
        BillPaymentStatus.settled: Icons.check_circle_outline,
      };
      for (final entry in icons.entries) {
        await pumpBadge(tester, entry.key);
        expect(find.byIcon(entry.value), findsOneWidget);
      }
    });

    testWidgets('carries the text label as tooltip for accessibility', (
      tester,
    ) async {
      await pumpBadge(tester, BillPaymentStatus.partial);

      expect(find.byTooltip('label-BillPaymentStatus.partial'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';

import '../../../core/format/currency_formatter.dart';
import '../../../l10n/generated/app_l10n.dart';

Future<String?> showCurrencyPickerDialog(BuildContext context, String current) {
  return showDialog<String>(
    context: context,
    builder: (ctx) {
      final l10n = AppL10n.of(ctx);
      return AlertDialog(
        title: Text(l10n.currencyLabel),
        contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.sizeOf(ctx).height * 0.62,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final code in CurrencyFormatter.supported)
                RadioListTile<String>(
                  value: code,
                  groupValue: current,
                  onChanged: (v) => Navigator.of(ctx).pop(v),
                  title: Text(
                    CurrencyFormatter.displayName(code),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

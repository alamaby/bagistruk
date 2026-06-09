import 'package:flutter/material.dart';

import '../../../core/format/currency_formatter.dart';
import '../../../l10n/generated/app_l10n.dart';

Future<String?> showCurrencyPickerDialog(BuildContext context, String current) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => _CurrencyPickerDialog(current: current),
  );
}

class _CurrencyPickerDialog extends StatefulWidget {
  const _CurrencyPickerDialog({required this.current});

  final String current;

  @override
  State<_CurrencyPickerDialog> createState() => _CurrencyPickerDialogState();
}

class _CurrencyPickerDialogState extends State<_CurrencyPickerDialog> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final filtered = CurrencyFormatter.definitions
        .where(
          (definition) => CurrencyFormatter.matchesQuery(definition, _query),
        )
        .toList(growable: false);

    return AlertDialog(
      title: Text(l10n.currencyLabel),
      contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.sizeOf(context).height * 0.62,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: l10n.cancelAction,
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close),
                        ),
                  hintText: l10n.currencySearchHint,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          l10n.currencySearchEmpty,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final definition = filtered[index];
                        return RadioListTile<String>(
                          value: definition.code,
                          groupValue: widget.current,
                          onChanged: (v) => Navigator.of(context).pop(v),
                          title: Text(
                            definition.displayName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

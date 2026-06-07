import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

import '../../../core/error/result.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/transfer_bank_info.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../../credits/providers/ocr_credit_status_provider.dart';
import '../providers/transfer_bank_info_provider.dart';

class TransferBankInfoScreen extends ConsumerStatefulWidget {
  const TransferBankInfoScreen({super.key});

  @override
  ConsumerState<TransferBankInfoScreen> createState() =>
      _TransferBankInfoScreenState();
}

class _TransferBankInfoScreenState
    extends ConsumerState<TransferBankInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankName = TextEditingController();
  final _accountName = TextEditingController();
  final _accountNumber = TextEditingController();
  bool _initialized = false;
  bool _saving = false;

  @override
  void dispose() {
    _bankName.dispose();
    _accountName.dispose();
    _accountNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final bankAsync = ref.watch(transferBankInfoProvider);
    final creditStatus = switch (ref.watch(ocrCreditStatusProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final isPlus = creditStatus?.isPlus ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.transferBankScreenTitle)),
      body: SafeArea(
        child: bankAsync.when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _MessageView(
            icon: Icons.error_outline,
            message: l10n.errorGeneric,
            actionLabel: l10n.retry,
            onAction: () => ref.invalidate(transferBankInfoProvider),
          ),
          data: (info) {
            _initFields(info);
            return ListView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              children: [
                if (!isPlus) ...[
                  _LockedPlusCard(l10n: l10n),
                  SizedBox(height: 12.h),
                ],
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _bankName,
                        enabled: isPlus && !_saving,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.transferBankNameLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) => _requiredWhenAnyFilled(
                          value,
                          l10n.transferBankRequired,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        controller: _accountName,
                        enabled: isPlus && !_saving,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.transferAccountNameLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) => _requiredWhenAnyFilled(
                          value,
                          l10n.transferBankRequired,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        controller: _accountNumber,
                        enabled: isPlus && !_saving,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: l10n.transferAccountNumberLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) => _requiredWhenAnyFilled(
                          value,
                          l10n.transferBankRequired,
                        ),
                        onFieldSubmitted: (_) {
                          if (isPlus) _save();
                        },
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.transferBankShareHint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      FilledButton.icon(
                        onPressed: isPlus && !_saving ? _save : null,
                        icon: _saving
                            ? SizedBox.square(
                                dimension: 18.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(l10n.saveAction),
                      ),
                      SizedBox(height: 8.h),
                      OutlinedButton.icon(
                        onPressed: isPlus && !_saving ? _clear : null,
                        icon: const Icon(Icons.delete_outline),
                        label: Text(l10n.transferBankClear),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _initFields(TransferBankInfo? info) {
    if (_initialized) return;
    _bankName.text = info?.bankName ?? '';
    _accountName.text = info?.accountName ?? '';
    _accountNumber.text = info?.accountNumber ?? '';
    _initialized = true;
  }

  String? _requiredWhenAnyFilled(String? value, String message) {
    if (!_hasAnyValue()) return null;
    return value == null || value.trim().isEmpty ? message : null;
  }

  bool _hasAnyValue() =>
      _bankName.text.trim().isNotEmpty ||
      _accountName.text.trim().isNotEmpty ||
      _accountNumber.text.trim().isNotEmpty;

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final info = _hasAnyValue()
        ? TransferBankInfo(
            bankName: _bankName.text.trim(),
            accountName: _accountName.text.trim(),
            accountNumber: _accountNumber.text.trim(),
          )
        : null;
    final res = await ref
        .read(profileRepositoryProvider)
        .updateTransferBankInfo(info);
    if (!mounted) return;
    setState(() => _saving = false);
    if (res is Success<void>) {
      ref.invalidate(transferBankInfoProvider);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(AppL10n.of(context).transferBankSaved)),
        );
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(AppL10n.of(context).errorGeneric)),
        );
    }
  }

  Future<void> _clear() async {
    _bankName.clear();
    _accountName.clear();
    _accountNumber.clear();
    await _save();
  }
}

class _LockedPlusCard extends StatelessWidget {
  const _LockedPlusCard({required this.l10n});

  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.workspace_premium_outlined,
            color: scheme.onPrimaryContainer,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              l10n.transferBankPlusOnly,
              style: TextStyle(color: scheme.onPrimaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40.r),
            SizedBox(height: 12.h),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 12.h),
            FilledButton.tonal(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

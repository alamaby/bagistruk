import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/error/result.dart';
import '../../../core/router/routes.dart';
import '../../../data/providers.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../../credits/providers/ocr_credit_status_provider.dart';
import '../../settings/providers/profile_notifier.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../providers/ocr_notifier.dart';
import '../utils/ocr_messages.dart';
import '../widgets/receipt_preview_component.dart';

/// Placeholder capture flow — wires together image_picker, the preview
/// component, and the OCR notifier so the foundation is end-to-end clickable.
/// Final UI/copy will land in a follow-up.
class ReceiptCaptureScreen extends ConsumerStatefulWidget {
  const ReceiptCaptureScreen({super.key});

  @override
  ConsumerState<ReceiptCaptureScreen> createState() =>
      _ReceiptCaptureScreenState();
}

class _ReceiptCaptureScreenState extends ConsumerState<ReceiptCaptureScreen> {
  final _picker = ImagePicker();
  final List<XFile> _images = [];
  ReceiptPreviewMode _mode = ReceiptPreviewMode.carousel;

  // Local "starting" flag supaya tombol langsung bereaksi saat di-tap.
  // Tanpa ini ada delay terlihat: bytes loading + downscale (~ratusan ms)
  // berjalan sebelum OcrNotifier sempat set state ke processing.
  bool _starting = false;

  Future<void> _addFromGallery() async {
    final picked = await _picker.pickMultiImage(imageQuality: 90);
    if (picked.isEmpty) return;
    setState(() => _images.addAll(picked));
  }

  Future<void> _addFromCamera() async {
    final l10n = AppL10n.of(context);
    while (true) {
      final shot = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      if (shot == null) return;
      if (!mounted) return;
      setState(() => _images.add(shot));

      final again = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(l10n.scanCameraContinuePrompt),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.scanCameraDone),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.scanCameraTakeAnother),
            ),
          ],
        ),
      );
      if (again != true) return;
      if (!mounted) return;
    }
  }

  Future<void> _showAddPhotoSheet() async {
    final l10n = AppL10n.of(context);
    final source = await showModalBottomSheet<_PhotoSource>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 8.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.scanSourceSheetTitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(l10n.scanSourceCamera),
              onTap: () => Navigator.of(ctx).pop(_PhotoSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.scanSourceGallery),
              onTap: () => Navigator.of(ctx).pop(_PhotoSource.gallery),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    switch (source) {
      case _PhotoSource.camera:
        await _addFromCamera();
      case _PhotoSource.gallery:
        await _addFromGallery();
    }
  }

  Future<void> _process() async {
    setState(() => _starting = true);
    // Tunggu satu frame paint dulu — tanpa ini, await pertama langsung
    // melanjutkan ke file IO + isolate dispatch sebelum engine sempat render
    // overlay loading, jadi user melihat tombol "membeku" beberapa ratus ms.
    await SchedulerBinding.instance.endOfFrame;
    try {
      // Lazy session bootstrap: pastikan ada `auth.uid()` sebelum OCR &
      // insert bill. Idempotent — kalau session login email/anon sudah ada,
      // tidak melakukan apa-apa.
      final ensured = await ref.read(authRepositoryProvider).ensureSignedIn();
      if (ensured is ResultFailure<String> && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal siapkan sesi: ${ensured.failure}')),
        );
        return;
      }
      final canScan = await _checkOcrCredit();
      if (!canScan) return;
      final bytes = await Future.wait(_images.map((f) => f.readAsBytes()));
      // Pass currency dari profile user supaya Edge Function bisa pakai
      // konvensi locale yg tepat saat parsing harga (mis. IDR gunakan '.'
      // sebagai pemisah ribuan, bukan desimal). Fallback ke 'IDR' jika
      // profile belum siap — sesuai pasar utama aplikasi.
      final currency =
          ref.read(profileProvider).value?.defaultCurrency ?? 'IDR';
      await ref.read(ocrProvider.notifier).process(bytes, currency: currency);
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  Future<bool> _checkOcrCredit() async {
    final res = await ref.read(profileRepositoryProvider).getOcrCreditStatus();
    if (!mounted) return false;

    switch (res) {
      case Success(:final data):
        if (data.balance > 0) return true;
        await _showNoCreditDialog(
          planCode: data.planCode,
          monthlyAllowance: data.monthlyAllowance,
        );
        return false;
      case ResultFailure(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal cek credit scan: $failure')),
        );
        return false;
    }
  }

  Future<void> _showNoCreditDialog({
    required String planCode,
    required int monthlyAllowance,
  }) {
    final isAnonymous = planCode == 'anonymous';
    final title = isAnonymous
        ? 'Batas scan gratis tercapai'
        : 'Credit scan bulan ini habis';
    final body = isAnonymous
        ? 'Kamu sudah memakai 5 credit scan sebagai pengguna anonim. Daftar '
              'akun untuk mendapat 20 credit gratis setiap bulan.'
        : planCode == 'plus'
        ? 'Kamu sudah memakai $monthlyAllowance credit Plus bulan ini. Credit '
              'akan tersedia lagi pada periode berikutnya.'
        : 'Kamu sudah memakai $monthlyAllowance credit gratis bulan ini. '
              'Upgrade ke Plus untuk 50 credit/bulan, tanpa iklan, dan fitur '
              'khusus Plus.';
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Nanti'),
          ),
          if (isAnonymous)
            FilledButton.icon(
              icon: const Icon(Icons.person_add_alt_1),
              onPressed: () {
                Navigator.of(ctx).pop();
                context.goNamed(Routes.registerName);
              },
              label: const Text('Daftar'),
            )
          else if (planCode == 'free')
            FilledButton.icon(
              icon: const Icon(Icons.workspace_premium),
              onPressed: () => Navigator.of(ctx).pop(),
              label: const Text('Plus segera hadir'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OcrState>(ocrProvider, (prev, next) {
      if (next is OcrSuccess && prev is! OcrSuccess) {
        final result = next.result;
        // Safety net: provider lama yang belum kenal `is_receipt` bisa lolos
        // dengan items kosong + confidence sangat rendah. Edge Function juga
        // sudah memfilter kasus ini, tapi double-guard di client agar user
        // tidak masuk BillReviewScreen kosong tanpa konteks.
        if (result.items.isEmpty && result.confidence < 0.3) {
          ref.read(ocrProvider.notifier).reset();
          final scheme = Theme.of(context).colorScheme;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: scheme.errorContainer,
                behavior: SnackBarBehavior.floating,
                content: Text(
                  AppL10n.of(context).scanNotReceiptHint,
                  style: TextStyle(
                    color: scheme.onErrorContainer,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          return;
        }
        ref.invalidate(ocrCreditStatusProvider);
        ref.read(ocrProvider.notifier).reset();
        context.pushNamed(Routes.billReviewName, extra: result);
      }
      if (next is OcrFailure) {
        final msg = friendlyOcrMessage(next.failure);
        final scheme = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              backgroundColor: scheme.errorContainer,
              behavior: SnackBarBehavior.floating,
              content: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: scheme.onErrorContainer,
                    size: 20.r,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      msg.title,
                      style: TextStyle(
                        color: scheme.onErrorContainer,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
      }
    });
    final state = ref.watch(ocrProvider);
    final busy = _starting || state is OcrProcessing;
    final scanActive = _images.isNotEmpty && !busy;
    final l10n = AppL10n.of(context);
    return AppScaffold(
      title: l10n.scanScreenTitle,
      actions: [
        IconButton(
          icon: Icon(
            _mode == ReceiptPreviewMode.carousel
                ? Icons.grid_view
                : Icons.view_carousel,
          ),
          onPressed: () => setState(
            () => _mode = _mode == ReceiptPreviewMode.carousel
                ? ReceiptPreviewMode.grid
                : ReceiptPreviewMode.carousel,
          ),
        ),
      ],
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ReceiptPreviewComponent(
                  images: _images,
                  mode: _mode,
                  busy: busy,
                  onRemove: (i) => setState(() => _images.removeAt(i)),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            if (state is OcrFailure)
              _ErrorCard(
                message: friendlyOcrMessage(state.failure),
                onDismiss: () => ref.read(ocrProvider.notifier).reset(),
              )
            else
              _StatusLabel(state: state, starting: _starting),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: busy ? null : _showAddPhotoSheet,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: Text(l10n.scanAddPhotos),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child:
                        FilledButton.icon(
                              key: ValueKey<bool>(scanActive),
                              onPressed: scanActive ? _process : null,
                              icon: busy
                                  ? SizedBox(
                                      width: 16.w,
                                      height: 16.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.auto_awesome),
                              label: Text(
                                busy ? l10n.scanInProgress : l10n.scanAction,
                              ),
                            )
                            .animate(target: scanActive ? 1 : 0)
                            .fadeIn(duration: 300.ms)
                            .slideY(
                              begin: 0.3,
                              end: 0,
                              duration: 300.ms,
                              curve: Curves.easeOut,
                            ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _PhotoSource { camera, gallery }

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.state, required this.starting});
  final OcrState state;
  final bool starting;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isProcessing = starting || state is OcrProcessing;
    final text = starting && state is! OcrProcessing
        ? 'Memproses gambar…'
        : switch (state) {
            OcrIdle() => 'Add photos and tap Scan',
            OcrProcessing(:final imageCount) =>
              'Scanning $imageCount image(s)…',
            OcrSuccess(:final result) =>
              '${result.items.length} items detected via ${result.providerUsed}',
            OcrFailure() => '',
          };
    final label = Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        color: scheme.onSurfaceVariant,
        fontWeight: isProcessing ? FontWeight.w600 : FontWeight.w400,
      ),
    );
    if (!isProcessing) return label;
    return label
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 1200.ms, color: scheme.primary);
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.onDismiss});

  final OcrMessage message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: scheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: scheme.error.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_off_rounded,
              color: scheme.onErrorContainer,
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: scheme.onErrorContainer,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  message.body,
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.4,
                    color: scheme.onErrorContainer.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 4.w),
          IconButton(
            tooltip: 'Tutup',
            visualDensity: VisualDensity.compact,
            iconSize: 18.r,
            onPressed: onDismiss,
            icon: Icon(Icons.close, color: scheme.onErrorContainer),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1, end: 0);
  }
}

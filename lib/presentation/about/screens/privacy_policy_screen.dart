import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../l10n/generated/app_l10n.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const String effectiveDate = '2026-05-10';

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final isId = Localizations.localeOf(context).languageCode == 'id';
    final sections = isId ? _sectionsId : _sectionsEn;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyPolicyTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
        children: [
          Text(
            isId
                ? 'Tanggal efektif: $effectiveDate'
                : 'Effective date: $effectiveDate',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16.h),
          for (final section in sections) ...[
            Text(
              section.heading,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              section.body,
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 20.h),
          ],
        ],
      ),
    );
  }
}

class _Section {
  const _Section(this.heading, this.body);
  final String heading;
  final String body;
}

const List<_Section> _sectionsId = [
  _Section(
    'Ringkasan',
    'BagiStruk adalah aplikasi pembagi tagihan (split bill) yang memindai struk '
        'menggunakan OCR. Kami hanya mengumpulkan data yang diperlukan agar fitur '
        'aplikasi berfungsi dan tidak menjual data pengguna kepada pihak ketiga.',
  ),
  _Section(
    'Data yang Dikumpulkan',
    '• Email dan kredensial autentikasi (saat Anda mendaftar atau login).\n'
        '• Nama peserta yang Anda masukkan untuk setiap tagihan.\n'
        '• Foto struk yang Anda unggah untuk diproses OCR.\n'
        '• Isi tagihan: item, harga, pajak, service, riwayat pembagian.\n'
        '• Informasi perangkat dasar yang dikirim otomatis oleh framework '
        '(versi OS, model perangkat) untuk diagnostik.',
  ),
  _Section(
    'Izin yang Dipakai',
    '• KAMERA: untuk memotret struk via image_picker.\n'
        '• READ_MEDIA_IMAGES: untuk memilih foto struk dari galeri.\n'
        '• INTERNET / ACCESS_NETWORK_STATE: untuk komunikasi dengan backend Supabase.',
  ),
  _Section(
    'Penyimpanan & Pemrosesan',
    'Data disimpan di Supabase (database PostgreSQL terkelola dan storage objek). '
        'Foto struk diproses oleh Supabase Edge Functions yang memanggil layanan '
        'OCR pihak ketiga (Google Gemini dan/atau OpenRouter). API key untuk '
        'layanan tersebut hanya berada di sisi server dan tidak pernah '
        'didistribusikan dalam aplikasi klien.',
  ),
  _Section(
    'Pihak Ketiga',
    '• Supabase (autentikasi, database, storage).\n'
        '• Penyedia OCR (Google Gemini / OpenRouter) untuk memproses gambar struk.\n'
        'Kami tidak menggunakan SDK analitik atau iklan pihak ketiga.',
  ),
  _Section(
    'Hak Pengguna',
    'Anda dapat menghapus akun dan seluruh data terkait kapan saja dengan '
        'menghubungi kontak dukungan di bawah. Untuk pengguna anonim, data hanya '
        'tersimpan selama sesi perangkat aktif.',
  ),
  _Section(
    'Perubahan Kebijakan',
    'Kebijakan ini dapat diperbarui sewaktu-waktu. Versi terbaru selalu '
        'tersedia di halaman ini di dalam aplikasi.',
  ),
  _Section(
    'Kontak',
    'Pertanyaan atau permintaan terkait privasi: alam.aby.b@gmail.com',
  ),
];

const List<_Section> _sectionsEn = [
  _Section(
    'Summary',
    'BagiStruk is a split-bill app that scans receipts using OCR. We only collect '
        'data necessary for the app to function, and we do not sell user data to '
        'third parties.',
  ),
  _Section(
    'Data Collected',
    '• Email and auth credentials (when you sign up or sign in).\n'
        '• Participant names you enter for each bill.\n'
        '• Receipt photos you upload for OCR processing.\n'
        '• Bill contents: items, prices, taxes, service charges, split history.\n'
        '• Basic device info automatically sent by the framework (OS version, '
        'device model) for diagnostics.',
  ),
  _Section(
    'Permissions Used',
    '• CAMERA: to capture receipt photos via image_picker.\n'
        '• READ_MEDIA_IMAGES: to pick receipt photos from gallery.\n'
        '• INTERNET / ACCESS_NETWORK_STATE: for Supabase backend communication.',
  ),
  _Section(
    'Storage & Processing',
    'Data is stored in Supabase (managed PostgreSQL and object storage). Receipt '
        'photos are processed by Supabase Edge Functions that call third-party '
        'OCR services (Google Gemini and/or OpenRouter). API keys for those '
        'services live only on the server side and are never bundled into the '
        'client app.',
  ),
  _Section(
    'Third Parties',
    '• Supabase (authentication, database, storage).\n'
        '• OCR providers (Google Gemini / OpenRouter) for receipt image processing.\n'
        'We do not use third-party analytics or advertising SDKs.',
  ),
  _Section(
    'User Rights',
    'You may delete your account and all associated data at any time by '
        'contacting the support email below. For anonymous users, data is only '
        'kept while the device session is active.',
  ),
  _Section(
    'Policy Changes',
    'This policy may be updated from time to time. The latest version is '
        'always available on this page within the app.',
  ),
  _Section(
    'Contact',
    'For privacy questions or requests: alam.aby.b@gmail.com',
  ),
];

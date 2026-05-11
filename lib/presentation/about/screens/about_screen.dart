import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/router/routes.dart';
import '../../../l10n/generated/app_l10n.dart';

// Placeholder URLs — ganti dengan URL final saat sudah tersedia.
const String kWebsiteUrl = '#';
const String kGithubUrl = '#';
const String kLinkedinUrl = '#';
const String kBuyMeACoffeeUrl = '#';
const String kSaweriaUrl = '#';
const String kPatreonUrl = '#';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        children: [
          _Header(),
          const Divider(),
          _SectionHeader(l10n.aboutSectionApp),
          _LinkTile(
            icon: Icons.public_outlined,
            label: l10n.aboutWebsite,
            url: kWebsiteUrl,
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.aboutPrivacyPolicy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(Routes.privacyPolicyName),
          ),
          const Divider(),
          _SectionHeader(l10n.aboutSectionAuthor),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n.aboutAuthorName),
          ),
          _LinkTile(
            icon: Icons.code,
            label: l10n.aboutGithub,
            url: kGithubUrl,
          ),
          _LinkTile(
            icon: Icons.work_outline,
            label: l10n.aboutLinkedin,
            url: kLinkedinUrl,
          ),
          const Divider(),
          _SectionHeader(l10n.aboutSectionSupport),
          _LinkTile(
            icon: Icons.local_cafe_outlined,
            label: l10n.aboutBuyMeACoffee,
            url: kBuyMeACoffeeUrl,
          ),
          _LinkTile(
            icon: Icons.volunteer_activism_outlined,
            label: l10n.aboutSaweria,
            url: kSaweriaUrl,
          ),
          _LinkTile(
            icon: Icons.favorite_outline,
            label: l10n.aboutPatreon,
            url: kPatreonUrl,
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              '© ${DateTime.now().year} ${l10n.aboutAuthorName}',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppL10n.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.asset(
              'assets/images/app_logo.png',
              width: 96.w,
              height: 96.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'BagiStruk',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final info = snapshot.data;
              final versionText = info == null
                  ? '...'
                  : '${info.version}+${info.buildNumber}';
              return Text(
                '${l10n.aboutVersionLabel} $versionText',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.label,
    required this.url,
  });

  final IconData icon;
  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: () => _open(context, url),
    );
  }

  Future<void> _open(BuildContext context, String url) async {
    final l10n = AppL10n.of(context);
    if (url == '#' || url.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.linkUnavailable)));
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok =
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.linkUnavailable)));
    }
  }
}

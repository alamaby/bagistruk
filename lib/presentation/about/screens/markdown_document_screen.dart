import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/generated/app_l10n.dart';
import '../../shared/widgets/loading_view.dart';

class MarkdownDocumentScreen extends StatelessWidget {
  const MarkdownDocumentScreen({
    super.key,
    required this.title,
    required this.assetPath,
  });

  final String title;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(
                  l10n.linkUnavailable,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            );
          }

          return Markdown(
            data: snapshot.data!,
            selectable: true,
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
            styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
              h1: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              h2: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              p: theme.textTheme.bodyMedium,
              listBullet: theme.textTheme.bodyMedium,
              blockquoteDecoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onTapLink: (_, href, _) => _openLink(href),
          );
        },
      ),
    );
  }

  Future<void> _openLink(String? href) async {
    if (href == null || href.isEmpty) return;
    final uri = Uri.tryParse(href);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

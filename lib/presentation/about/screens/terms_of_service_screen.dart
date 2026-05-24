import 'package:flutter/material.dart';

import '../../../l10n/generated/app_l10n.dart';
import 'markdown_document_screen.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  static const String _assetPath = 'docs/terms-of-service.md';

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return MarkdownDocumentScreen(
      title: l10n.termsOfServiceTitle,
      assetPath: _assetPath,
    );
  }
}

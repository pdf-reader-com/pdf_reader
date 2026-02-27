import 'package:flutter/material.dart';
import 'package:pdf_reader/l10n/app_localizations.dart';
import 'package:pdf_reader/pages/pdfcraft_page.dart';
import 'package:pdf_reader/services/pdfcraft_server.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ListTile(
          title: Text(
            l.toolsTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(l.toolsSubtitle),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.build_circle_outlined),
          title: Text(l.toolsPdfCraft),
          subtitle: Text(l.toolsPdfCraftSubtitle),
          onTap: () async {
            await PdfCraftServer.ensureStarted();
            if (!context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const PdfCraftPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.picture_as_pdf),
          title: Text(l.toolsMergePdf),
          subtitle: Text(l.toolsMergePdfSubtitle),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.toolsMergePdfSubtitle)),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.text_fields),
          title: Text(l.toolsExtractText),
          subtitle: Text(l.toolsExtractTextSubtitle),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.toolsExtractTextSubtitle)),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.translate),
          title: Text(l.toolsTranslateFile),
          subtitle: Text(l.toolsTranslateFileSubtitle),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.toolsTranslateFileSubtitle)),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(l.toolsReadingSettings),
          subtitle: Text(l.toolsReadingSettingsSubtitle),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.toolsReadingSettingsSubtitle)),
            );
          },
        ),
      ],
    );
  }
}


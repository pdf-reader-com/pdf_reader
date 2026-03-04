import 'package:flutter/material.dart';
import 'package:pdf_reader/l10n/app_localizations.dart';
import 'package:pdf_reader/pages/pandoc_page.dart';
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
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const PdfCraftPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: Text(l.toolsPandoc),
          subtitle: Text(l.toolsPandocSubtitle),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const PandocPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:pdf_reader/l10n/app_localizations.dart';

import '../main.dart';
import 'language_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ListTile(
          title: Text(
            l.settingsTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(l.settingsLanguageTitle),
          subtitle: Text(l.settingsLanguageSubtitle),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const LanguageSettingsPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}


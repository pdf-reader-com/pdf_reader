import 'package:flutter/material.dart';
import 'package:pdf_reader/l10n/app_localizations.dart';

import '../main.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
     final appState = MyApp.of(context);
     final overrideLocale = appState?.overrideLocale;
     final isFollowSystem = overrideLocale == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.languageSettingsTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            leading: const Icon(Icons.phone_iphone),
            title: Text(l.languageFollowSystem),
            subtitle: Text(l.languageFollowSystemSubtitle),
            trailing: isFollowSystem ? const Icon(Icons.check) : null,
            selected: isFollowSystem,
            onTap: () {
              MyApp.of(context)?.setLocale(null);
            },
          ),
          const Divider(),
          _buildLanguageTile(
            context,
            'English',
            const Locale('en'),
            overrideLocale,
          ),
          _buildLanguageTile(
            context,
            'العربية',
            const Locale('ar'),
            overrideLocale,
          ),
          _buildLanguageTile(
            context,
            'Deutsch',
            const Locale('de'),
            overrideLocale,
          ),
          _buildLanguageTile(
            context,
            'Español',
            const Locale('es'),
            overrideLocale,
          ),
          _buildLanguageTile(
            context,
            'Français',
            const Locale('fr'),
            overrideLocale,
          ),
          _buildLanguageTile(
            context,
            'Italiano',
            const Locale('it'),
            overrideLocale,
          ),
          _buildLanguageTile(
            context,
            '日本語',
            const Locale('ja'),
            overrideLocale,
          ),
          _buildLanguageTile(
            context,
            '한국어',
            const Locale('ko'),
            overrideLocale,
          ),
          _buildLanguageTile(
            context,
            'Русский',
            const Locale('ru'),
            overrideLocale,
          ),
          _buildLanguageTile(
            context,
            '简体中文',
            const Locale('zh'),
            overrideLocale,
          ),
          _buildLanguageTile(
            context,
            '繁體中文（台灣）',
            const Locale('zh', 'TW'),
            overrideLocale,
          ),
        ],
      ),
    );
  }

  ListTile _buildLanguageTile(
    BuildContext context,
    String name,
    Locale locale,
    Locale? selectedLocale,
  ) {
    final isSelected = selectedLocale != null &&
        selectedLocale.languageCode == locale.languageCode &&
        (selectedLocale.countryCode ?? '') == (locale.countryCode ?? '');

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(name),
      trailing: isSelected ? const Icon(Icons.check) : null,
      selected: isSelected,
      onTap: () {
        MyApp.of(context)?.setLocale(locale);
      },
    );
  }
}


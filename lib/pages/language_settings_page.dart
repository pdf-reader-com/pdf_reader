import 'package:flutter/material.dart';

import '../main.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('语言设置'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            leading: const Icon(Icons.phone_iphone),
            title: const Text('跟随系统'),
            subtitle: const Text('使用系统语言（无匹配时显示英语）'),
            onTap: () {
              MyApp.of(context)?.setLocale(null);
            },
          ),
          const Divider(),
          _buildLanguageTile(context, 'English', const Locale('en')),
          _buildLanguageTile(context, 'العربية', const Locale('ar')),
          _buildLanguageTile(context, 'Deutsch', const Locale('de')),
          _buildLanguageTile(context, 'Español', const Locale('es')),
          _buildLanguageTile(context, 'Français', const Locale('fr')),
          _buildLanguageTile(context, 'Italiano', const Locale('it')),
          _buildLanguageTile(context, '日本語', const Locale('ja')),
          _buildLanguageTile(context, '한국어', const Locale('ko')),
          _buildLanguageTile(context, 'Русский', const Locale('ru')),
          _buildLanguageTile(context, '简体中文', const Locale('zh')),
          _buildLanguageTile(context, '繁體中文（台灣）', const Locale('zh', 'TW')),
        ],
      ),
    );
  }

  ListTile _buildLanguageTile(BuildContext context, String name, Locale locale) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(name),
      onTap: () {
        MyApp.of(context)?.setLocale(locale);
      },
    );
  }
}


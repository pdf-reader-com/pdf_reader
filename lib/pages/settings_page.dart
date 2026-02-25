import 'package:flutter/material.dart';

import '../main.dart';
import 'language_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        const ListTile(
          title: Text(
            '设置',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('语言设置'),
          subtitle: const Text('界面语言'),
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


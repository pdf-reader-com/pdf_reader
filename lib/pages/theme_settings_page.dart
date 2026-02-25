import 'package:flutter/material.dart';
import 'package:pdf_reader/l10n/app_localizations.dart';

import '../main.dart';

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  late ThemeMode _themeMode;
  late Color _seedColor;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final appState = MyApp.of(context);
      _themeMode = appState?.themeMode ?? ThemeMode.system;
      _seedColor = appState?.seedColor ?? Colors.blue;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final appState = MyApp.of(context);

    final colors = <Color>[
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l.themeSettingsTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            leading: const Icon(Icons.phone_iphone),
            title: Text(l.themeFollowSystem),
            trailing:
                _themeMode == ThemeMode.system ? const Icon(Icons.check) : null,
            selected: _themeMode == ThemeMode.system,
            onTap: () {
              appState?.setThemeMode(ThemeMode.system);
              setState(() {
                _themeMode = ThemeMode.system;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.light_mode),
            title: Text(l.themeLight),
            trailing:
                _themeMode == ThemeMode.light ? const Icon(Icons.check) : null,
            selected: _themeMode == ThemeMode.light,
            onTap: () {
              appState?.setThemeMode(ThemeMode.light);
              setState(() {
                _themeMode = ThemeMode.light;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(l.themeDark),
            trailing:
                _themeMode == ThemeMode.dark ? const Icon(Icons.check) : null,
            selected: _themeMode == ThemeMode.dark,
            onTap: () {
              appState?.setThemeMode(ThemeMode.dark);
              setState(() {
                _themeMode = ThemeMode.dark;
              });
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              l.themeColorTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(l.themeColorSubtitle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final color in colors)
                  _ThemeColorDot(
                    color: color,
                    selected: _seedColor.value == color.value,
                    onTap: () {
                      appState?.setSeedColor(color);
                      setState(() {
                        _seedColor = color;
                      });
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeColorDot extends StatelessWidget {
  const _ThemeColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.onBackground;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(
                  color: borderColor,
                  width: 3,
                )
              : null,
        ),
        alignment: Alignment.center,
        child: selected
            ? Icon(
                Icons.check,
                color: ThemeData.estimateBrightnessForColor(color) ==
                        Brightness.dark
                    ? Colors.white
                    : Colors.black,
              )
            : null,
      ),
    );
  }
}


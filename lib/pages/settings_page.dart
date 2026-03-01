import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_reader/l10n/app_localizations.dart';

import 'about_page.dart';
import 'language_settings_page.dart';
import 'theme_settings_page.dart';

const _androidChannel = MethodChannel('com.pdf_reader/pdf_reader');

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  bool? _hasAllFilesAccess;
  bool _loadingAccess = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (Platform.isAndroid) {
      _checkAllFilesAccess();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && Platform.isAndroid) {
      _checkAllFilesAccess();
    }
  }

  Future<void> _checkAllFilesAccess() async {
    if (!Platform.isAndroid) {
      return;
    }
    setState(() => _loadingAccess = true);
    try {
      final value = await _androidChannel.invokeMethod<bool>('hasAllFilesAccess');
      if (mounted) {
        setState(() {
          _hasAllFilesAccess = value ?? false;
          _loadingAccess = false;
        });
      }
    } on PlatformException catch (_) {
      if (mounted) {
        setState(() {
          _hasAllFilesAccess = false;
          _loadingAccess = false;
        });
      }
    }
  }

  Future<void> _requestAllFilesAccess() async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      await _androidChannel.invokeMethod<void>('requestAllFilesAccess');
      // 用户会跳转到系统设置，返回后 didChangeAppLifecycleState 会触发重新检测
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.settingsAllFilesAccessRequestFailed}: ${e.message ?? ""}')),
        );
      }
    }
  }

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
        if (Platform.isAndroid) ...[
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: Text(l.settingsAllFilesAccessTitle),
            subtitle: Text(
              _loadingAccess
                  ? l.settingsAllFilesAccessChecking
                  : (_hasAllFilesAccess == true
                      ? l.settingsAllFilesAccessGranted
                      : l.settingsAllFilesAccessSubtitle),
            ),
            trailing: _hasAllFilesAccess == true
                ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                : FilledButton(
                    onPressed: _loadingAccess ? null : _requestAllFilesAccess,
                    child: Text(l.settingsAllFilesAccessRequest),
                  ),
          ),
          const Divider(),
        ],
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
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: Text(l.settingsThemeTitle),
          subtitle: Text(l.settingsThemeSubtitle),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ThemeSettingsPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(l.settingsAboutTitle),
          subtitle: Text(l.settingsAboutSubtitle),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const AboutPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}


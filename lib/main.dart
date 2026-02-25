import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pdf_reader/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf_reader/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _prefsKeyLocale = 'app_locale';

  Locale? _overrideLocale;

  Locale? get overrideLocale => _overrideLocale;

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKeyLocale);
    if (code == null || code.isEmpty) {
      setState(() {
        _overrideLocale = null;
      });
      return;
    }

    final parts = code.split('_');
    setState(() {
      _overrideLocale =
          parts.length == 2 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
    });
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();

    if (locale == null) {
      await prefs.remove(_prefsKeyLocale);
    } else {
      final code = (locale.countryCode == null || locale.countryCode!.isEmpty)
          ? locale.languageCode
          : '${locale.languageCode}_${locale.countryCode}';
      await prefs.setString(_prefsKeyLocale, code);
    }

    setState(() {
      _overrideLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _overrideLocale,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      home: const ReaderHomePage(),
    );
  }
}
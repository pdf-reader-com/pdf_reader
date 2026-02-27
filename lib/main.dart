import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pdf_reader/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf_reader/pages/home_page.dart';
import 'package:pdf_reader/services/pdfcraft_server.dart';

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
  static const _prefsKeyThemeMode = 'app_theme_mode';
  static const _prefsKeyThemeSeedColor = 'app_theme_seed_color';

  Locale? _overrideLocale;
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = Colors.blue;

  Locale? get overrideLocale => _overrideLocale;
  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
    _loadSavedTheme();
    _initPdfCraftServer();
  }

  Future<void> _initPdfCraftServer() async {
    try {
      await PdfCraftServer.ensureStarted();
    } catch (_) {
      // 启动失败时静默忽略，避免影响主应用
    }
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

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_prefsKeyThemeMode);
    final colorValue = prefs.getInt(_prefsKeyThemeSeedColor);

    setState(() {
      _themeMode = _decodeThemeMode(modeIndex);
      _seedColor = colorValue != null ? Color(colorValue) : Colors.blue;
    });
  }

  ThemeMode _decodeThemeMode(int? index) {
    switch (index) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      case 0:
      default:
        return ThemeMode.system;
    }
  }

  int _encodeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 1;
      case ThemeMode.dark:
        return 2;
      case ThemeMode.system:
      default:
        return 0;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKeyThemeMode, _encodeThemeMode(mode));
    setState(() {
      _themeMode = mode;
    });
  }

  Future<void> setSeedColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKeyThemeSeedColor, color.value);
    setState(() {
      _seedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
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
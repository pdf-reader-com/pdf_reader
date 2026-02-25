// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Dokumentenleser';

  @override
  String get tabAllFiles => 'Alle Dateien';

  @override
  String get tabRecent => 'Zuletzt';

  @override
  String get tabBookmarks => 'Lesezeichen';

  @override
  String get tabTools => 'Werkzeuge';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterPdf => 'PDF';

  @override
  String get filterDoc => 'Dokumente';

  @override
  String get filterTxt => 'Text';

  @override
  String get filterMarkdown => 'Markdown';

  @override
  String get sectionTitleAllFiles => 'Alle Dateien';

  @override
  String get sectionTitleRecent => 'Zuletzt geöffnet';

  @override
  String get sectionTitleBookmarks => 'Dateien mit Lesezeichen';

  @override
  String get emptyFiles =>
      'Keine Dateien vorhanden.\n\nÜber die Ordnerschaltfläche oben rechts kannst du ein Verzeichnis zum Scannen wählen.';

  @override
  String get scanTooltip => 'Dateien in einem Verzeichnis scannen';

  @override
  String get scanProgress => 'Dateien werden gescannt, bitte warten…';

  @override
  String scanIndexedCount(int count) {
    return '$count Dateien indiziert';
  }

  @override
  String get scanFailed => 'Scan fehlgeschlagen';

  @override
  String get fileTypePdf => 'PDF';

  @override
  String get fileTypeDoc => 'Dokument';

  @override
  String get fileTypeTxt => 'Text';

  @override
  String get fileTypeMarkdown => 'Markdown';

  @override
  String get fileTypeOther => 'Andere';

  @override
  String get bookmark => 'Lesezeichen';

  @override
  String get share => 'Teilen';

  @override
  String get shareTodo => 'Teilen-Funktion wird noch implementiert';

  @override
  String get more => 'Mehr';

  @override
  String get loadFailed => 'Laden fehlgeschlagen';

  @override
  String get cannotResolvePath => 'Dateipfad kann nicht aufgelöst werden';

  @override
  String get loadMarkdownFailed => 'Markdown konnte nicht geladen werden';

  @override
  String get loadTextFailed => 'Text konnte nicht geladen werden';

  @override
  String get previewUnsupportedDoc =>
      'Die Vorschau für diesen Dokumenttyp wird noch nicht unterstützt.\nDu kannst über „Mehr“ oben rechts eine andere App zum Öffnen wählen.';

  @override
  String get previewUnsupportedFile =>
      'Die Vorschau für diesen Dateityp wird nicht unterstützt.\n\nPfad:';

  @override
  String get moreOpenWithOther => 'Mit anderer App öffnen';

  @override
  String get moreOpenWithOtherTodo => 'Externes Öffnen wird noch implementiert';

  @override
  String get moreExportConvert => 'Exportieren / Konvertieren';

  @override
  String get moreExportConvertTodo =>
      'Export- und Konvertierungsfunktion wird noch implementiert';

  @override
  String get moreDelete => 'Datei löschen';

  @override
  String get moreDeleteTodo => 'Löschfunktion wird noch implementiert';

  @override
  String get toolsTitle => 'Werkzeuge';

  @override
  String get toolsSubtitle =>
      'Verschiedene Aktionen für Dateien (Platzhalter-Demo)';

  @override
  String get toolsMergePdf => 'PDFs zusammenführen';

  @override
  String get toolsMergePdfSubtitle =>
      'Mehrere PDF-Dateien auswählen und zu einer zusammenführen';

  @override
  String get toolsExtractText => 'Text extrahieren';

  @override
  String get toolsExtractTextSubtitle => 'Text aus PDFs / Bildern extrahieren';

  @override
  String get toolsTranslateFile => 'Aktuelle Datei übersetzen';

  @override
  String get toolsTranslateFileSubtitle =>
      'Externe Dienste zum Übersetzen des Inhalts verwenden';

  @override
  String get toolsReadingSettings => 'Leseeinstellungen';

  @override
  String get toolsReadingSettingsSubtitle =>
      'Schriftgröße, Thema, Blättermodus usw.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Interface language';

  @override
  String get languageSettingsTitle => 'Language';

  @override
  String get languageFollowSystem => 'Follow system';

  @override
  String get languageFollowSystemSubtitle =>
      'Use system language (fall back to English if unsupported)';
}

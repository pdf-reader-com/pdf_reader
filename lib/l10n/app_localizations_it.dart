// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Lettore di documenti';

  @override
  String get tabAllFiles => 'Tutti i file';

  @override
  String get tabRecent => 'Recenti';

  @override
  String get tabBookmarks => 'Preferiti';

  @override
  String get tabTools => 'Strumenti';

  @override
  String get filterAll => 'Tutti';

  @override
  String get filterPdf => 'PDF';

  @override
  String get filterEpub => 'EPUB';

  @override
  String get filterDoc => 'Documenti';

  @override
  String get filterTxt => 'Testo';

  @override
  String get filterMarkdown => 'Markdown';

  @override
  String get sectionTitleAllFiles => 'Tutti i file';

  @override
  String get sectionTitleRecent => 'Aperti di recente';

  @override
  String get sectionTitleBookmarks => 'File preferiti';

  @override
  String get emptyFiles =>
      'Nessun file al momento.\n\nPuoi usare il pulsante cartella in alto a destra per analizzare una cartella.';

  @override
  String get scanTooltip => 'Analizza i file in una cartella';

  @override
  String get scanProgress => 'Analisi dei file in corso, attendere…';

  @override
  String scanIndexedCount(int count) {
    return '$count file indicizzati';
  }

  @override
  String get scanFailed => 'Analisi non riuscita';

  @override
  String get fileTypePdf => 'PDF';

  @override
  String get fileTypeEpub => 'EPUB';

  @override
  String get fileTypeDoc => 'Documento';

  @override
  String get fileTypeTxt => 'Testo';

  @override
  String get fileTypeMarkdown => 'Markdown';

  @override
  String get fileTypeOther => 'Altro';

  @override
  String get bookmark => 'Preferito';

  @override
  String get share => 'Condividi';

  @override
  String get shareTodo =>
      'La funzione di condivisione deve ancora essere implementata';

  @override
  String get more => 'Altro';

  @override
  String get loadFailed => 'Caricamento non riuscito';

  @override
  String get cannotResolvePath => 'Impossibile risolvere il percorso del file';

  @override
  String get loadMarkdownFailed => 'Caricamento di Markdown non riuscito';

  @override
  String get loadTextFailed => 'Caricamento del testo non riuscito';

  @override
  String get previewUnsupportedDoc =>
      'L’anteprima per questo tipo di documento non è ancora supportata.\nPuoi toccare \"Altro\" in alto a destra per aprirlo con un’altra app.';

  @override
  String get previewUnsupportedFile =>
      'L’anteprima per questo tipo di file non è supportata.\n\nPercorso:';

  @override
  String get moreOpenWithOther => 'Apri con un’altra app';

  @override
  String get moreOpenWithOtherTodo =>
      'L’apertura esterna deve ancora essere implementata';

  @override
  String get moreExportConvert => 'Esporta / Converti';

  @override
  String get moreExportConvertTodo =>
      'Le funzioni di esportazione e conversione devono ancora essere implementate';

  @override
  String get moreDelete => 'Elimina file';

  @override
  String get moreDeleteTodo =>
      'La funzione di eliminazione deve ancora essere implementata';

  @override
  String get deleteConfirmTitle => 'Eliminare il file?';

  @override
  String get deleteConfirmMessage =>
      'Questo file verrà eliminato definitivamente. L\'azione non può essere annullata.';

  @override
  String get shareFailed => 'Condivisione non riuscita';

  @override
  String get openWithOtherFailed => 'Impossibile aprire con un\'altra app';

  @override
  String get deleteFailed => 'Eliminazione del file non riuscita';

  @override
  String get cannotDeleteFile => 'Questo file non può essere eliminato da qui.';

  @override
  String get toolsTitle => 'Strumenti';

  @override
  String get toolsSubtitle =>
      'Esegui varie operazioni sui file (demo di esempio)';

  @override
  String get toolsMergePdf => 'Unisci PDF';

  @override
  String get toolsMergePdfSubtitle =>
      'Seleziona più file PDF e uniscili in uno solo';

  @override
  String get toolsExtractText => 'Estrai testo';

  @override
  String get toolsExtractTextSubtitle => 'Estrai testo da PDF / immagini';

  @override
  String get toolsTranslateFile => 'Traduci file corrente';

  @override
  String get toolsTranslateFileSubtitle =>
      'Usa servizi esterni per tradurre il contenuto';

  @override
  String get toolsReadingSettings => 'Impostazioni di lettura';

  @override
  String get toolsReadingSettingsSubtitle =>
      'Dimensione del carattere, tema, modalità di scorrimento, ecc.';

  @override
  String get toolsPdfCraft => 'PDFCraft';

  @override
  String get toolsPdfCraftSubtitle =>
      'Strumenti PDF integrati (unisci, dividi, converti, ecc.)';

  @override
  String get settingsTitle => 'Impostazioni';

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

  @override
  String get settingsThemeTitle => 'Appearance';

  @override
  String get settingsThemeSubtitle => 'Theme and colors';

  @override
  String get themeSettingsTitle => 'Appearance';

  @override
  String get themeFollowSystem => 'Follow system';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeColorTitle => 'Primary color';

  @override
  String get themeColorSubtitle => 'Accent color for interface';

  @override
  String get settingsAboutTitle => 'About';

  @override
  String get settingsAboutSubtitle => 'Version and source code';

  @override
  String get settingsAllFilesAccessTitle => 'All files access';

  @override
  String get settingsAllFilesAccessSubtitle =>
      'Grant to scan all supported files on device';

  @override
  String get settingsAllFilesAccessGranted => 'Granted';

  @override
  String get settingsAllFilesAccessRequest => 'Grant access';

  @override
  String get settingsAllFilesAccessChecking => 'Checking…';

  @override
  String get settingsAllFilesAccessRequestFailed => 'Failed to open settings';

  @override
  String get scanAllFilesTooltip => 'Scan all files on device';

  @override
  String get scanAllFilesPermissionDenied =>
      'All files access was denied. Scan cancelled.';

  @override
  String get scanAllFilesProgress => 'Scanning all files…';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutAppName => 'App name';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutBuildNumber => 'Build';

  @override
  String get aboutPackageName => 'Package';

  @override
  String aboutLoadError(String error) {
    return 'Failed to load app info: $error';
  }

  @override
  String get aboutOpenSourceLabel => 'Source code';

  @override
  String get aboutOpenSourceHint => 'This project is open source at';

  @override
  String get aboutSourceLinkLabel => 'GitHub';

  @override
  String get openInSystemBrowser => 'Open in system browser';

  @override
  String get removeFromList => 'Remove from list';

  @override
  String get select => 'Select';

  @override
  String get cancelSelect => 'Cancel';

  @override
  String get batchRemoveFromList => 'Remove from list';

  @override
  String batchRemoveConfirm(int count) {
    return 'Remove $count item(s) from list? Files on disk will not be deleted.';
  }

  @override
  String get removedFromList => 'Removed from list';

  @override
  String get selectAll => 'Select all';

  @override
  String get deselectAll => 'Deselect all';

  @override
  String get searchFilesHint => 'Search by filename';
}

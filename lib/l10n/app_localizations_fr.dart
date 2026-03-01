// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Lecteur de documents';

  @override
  String get tabAllFiles => 'Tous les fichiers';

  @override
  String get tabRecent => 'Récents';

  @override
  String get tabBookmarks => 'Favoris';

  @override
  String get tabTools => 'Outils';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterPdf => 'PDF';

  @override
  String get filterEpub => 'EPUB';

  @override
  String get filterDoc => 'Documents';

  @override
  String get filterTxt => 'Texte';

  @override
  String get filterMarkdown => 'Markdown';

  @override
  String get sectionTitleAllFiles => 'Tous les fichiers';

  @override
  String get sectionTitleRecent => 'Récemment ouverts';

  @override
  String get sectionTitleBookmarks => 'Fichiers favoris';

  @override
  String get emptyFiles =>
      'Aucun fichier pour le moment.\n\nVous pouvez utiliser le bouton de dossier en haut à droite pour analyser un répertoire.';

  @override
  String get scanTooltip => 'Analyser les fichiers d’un répertoire';

  @override
  String get scanProgress => 'Analyse des fichiers, veuillez patienter…';

  @override
  String scanIndexedCount(int count) {
    return '$count fichiers indexés';
  }

  @override
  String get scanFailed => 'Échec de l’analyse';

  @override
  String get fileTypePdf => 'PDF';

  @override
  String get fileTypeEpub => 'EPUB';

  @override
  String get fileTypeDoc => 'Document';

  @override
  String get fileTypeTxt => 'Texte';

  @override
  String get fileTypeMarkdown => 'Markdown';

  @override
  String get fileTypeOther => 'Autre';

  @override
  String get bookmark => 'Favori';

  @override
  String get share => 'Partager';

  @override
  String get shareTodo => 'La fonction de partage reste à implémenter';

  @override
  String get more => 'Plus';

  @override
  String get loadFailed => 'Échec du chargement';

  @override
  String get cannotResolvePath => 'Impossible de résoudre le chemin du fichier';

  @override
  String get loadMarkdownFailed => 'Échec du chargement du Markdown';

  @override
  String get loadTextFailed => 'Échec du chargement du texte';

  @override
  String get previewUnsupportedDoc =>
      'La prévisualisation de ce type de document n’est pas encore prise en charge.\nVous pouvez appuyer sur « Plus » en haut à droite pour l’ouvrir avec une autre application.';

  @override
  String get previewUnsupportedFile =>
      'La prévisualisation de ce type de fichier n’est pas prise en charge.\n\nChemin :';

  @override
  String get moreOpenWithOther => 'Ouvrir avec une autre application';

  @override
  String get moreOpenWithOtherTodo => 'L’ouverture externe reste à implémenter';

  @override
  String get moreExportConvert => 'Exporter / Convertir';

  @override
  String get moreExportConvertTodo =>
      'Les fonctions d’export et de conversion restent à implémenter';

  @override
  String get moreDelete => 'Supprimer le fichier';

  @override
  String get moreDeleteTodo => 'La fonction de suppression reste à implémenter';

  @override
  String get deleteConfirmTitle => 'Supprimer le fichier ?';

  @override
  String get deleteConfirmMessage =>
      'Ce fichier sera définitivement supprimé. Cette action est irréversible.';

  @override
  String get shareFailed => 'Échec du partage';

  @override
  String get openWithOtherFailed =>
      'Impossible d\'ouvrir avec une autre application';

  @override
  String get deleteFailed => 'Échec de la suppression du fichier';

  @override
  String get cannotDeleteFile => 'Ce fichier ne peut pas être supprimé ici.';

  @override
  String get toolsTitle => 'Outils';

  @override
  String get toolsSubtitle =>
      'Effectuer diverses opérations sur les fichiers (démo de remplacement)';

  @override
  String get toolsMergePdf => 'Fusionner des PDF';

  @override
  String get toolsMergePdfSubtitle =>
      'Sélectionnez plusieurs fichiers PDF et fusionnez-les en un seul';

  @override
  String get toolsExtractText => 'Extraire le texte';

  @override
  String get toolsExtractTextSubtitle =>
      'Extraire du texte à partir de PDFs / images';

  @override
  String get toolsTranslateFile => 'Traduire le fichier actuel';

  @override
  String get toolsTranslateFileSubtitle =>
      'Utiliser des services externes pour traduire le contenu';

  @override
  String get toolsReadingSettings => 'Paramètres de lecture';

  @override
  String get toolsReadingSettingsSubtitle =>
      'Taille de police, thème, mode de défilement, etc.';

  @override
  String get toolsPdfCraft => 'PDFCraft';

  @override
  String get toolsPdfCraftSubtitle =>
      'Outils PDF intégrés (fusionner, diviser, convertir, etc.)';

  @override
  String get settingsTitle => 'Paramètres';

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

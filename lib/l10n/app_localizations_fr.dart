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

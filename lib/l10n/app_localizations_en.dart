// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Document Reader';

  @override
  String get tabAllFiles => 'All Files';

  @override
  String get tabRecent => 'Recent';

  @override
  String get tabBookmarks => 'Bookmarks';

  @override
  String get tabTools => 'Tools';

  @override
  String get filterAll => 'All';

  @override
  String get filterPdf => 'PDF';

  @override
  String get filterDoc => 'Documents';

  @override
  String get filterTxt => 'Text';

  @override
  String get filterMarkdown => 'Markdown';

  @override
  String get sectionTitleAllFiles => 'All Files';

  @override
  String get sectionTitleRecent => 'Recently Opened';

  @override
  String get sectionTitleBookmarks => 'Bookmarked Files';

  @override
  String get emptyFiles =>
      'No files yet.\n\nYou can tap the folder button in the top-right corner to scan a directory.';

  @override
  String get scanTooltip => 'Scan files in a directory';

  @override
  String get scanProgress => 'Scanning files, please wait…';

  @override
  String scanIndexedCount(int count) {
    return 'Indexed $count files';
  }

  @override
  String get scanFailed => 'Scan failed';

  @override
  String get fileTypePdf => 'PDF';

  @override
  String get fileTypeDoc => 'Document';

  @override
  String get fileTypeTxt => 'Text';

  @override
  String get fileTypeMarkdown => 'Markdown';

  @override
  String get fileTypeOther => 'Other';

  @override
  String get bookmark => 'Bookmark';

  @override
  String get share => 'Share';

  @override
  String get shareTodo => 'Share feature to be implemented';

  @override
  String get more => 'More';

  @override
  String get loadFailed => 'Failed to load';

  @override
  String get cannotResolvePath => 'Cannot resolve file path';

  @override
  String get loadMarkdownFailed => 'Failed to load Markdown';

  @override
  String get loadTextFailed => 'Failed to load text';

  @override
  String get previewUnsupportedDoc =>
      'Preview of this document type is not supported yet.\nYou can tap \"More\" in the top-right corner to open it with another app.';

  @override
  String get previewUnsupportedFile =>
      'Preview of this file type is not supported.\n\nPath:';

  @override
  String get moreOpenWithOther => 'Open with another app';

  @override
  String get moreOpenWithOtherTodo => 'External open feature to be implemented';

  @override
  String get moreExportConvert => 'Export / Convert';

  @override
  String get moreExportConvertTodo =>
      'Export and format conversion feature to be implemented';

  @override
  String get moreDelete => 'Delete file';

  @override
  String get moreDeleteTodo => 'Delete feature to be implemented';

  @override
  String get toolsTitle => 'Tools';

  @override
  String get toolsSubtitle =>
      'Perform various operations on files (placeholder demo)';

  @override
  String get toolsMergePdf => 'Merge PDFs';

  @override
  String get toolsMergePdfSubtitle =>
      'Select multiple PDF files and merge them into one';

  @override
  String get toolsExtractText => 'Extract text';

  @override
  String get toolsExtractTextSubtitle => 'Extract text from PDFs / images';

  @override
  String get toolsTranslateFile => 'Translate current file';

  @override
  String get toolsTranslateFileSubtitle =>
      'Use external services to translate content';

  @override
  String get toolsReadingSettings => 'Reading settings';

  @override
  String get toolsReadingSettingsSubtitle =>
      'Font size, theme, page turning mode, etc.';

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
}

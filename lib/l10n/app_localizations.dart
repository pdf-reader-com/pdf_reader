import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ru'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Document Reader'**
  String get appTitle;

  /// No description provided for @tabAllFiles.
  ///
  /// In en, this message translates to:
  /// **'All Files'**
  String get tabAllFiles;

  /// No description provided for @tabRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get tabRecent;

  /// No description provided for @tabBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get tabBookmarks;

  /// No description provided for @tabTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tabTools;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get filterPdf;

  /// No description provided for @filterDoc.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get filterDoc;

  /// No description provided for @filterTxt.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get filterTxt;

  /// No description provided for @filterMarkdown.
  ///
  /// In en, this message translates to:
  /// **'Markdown'**
  String get filterMarkdown;

  /// No description provided for @sectionTitleAllFiles.
  ///
  /// In en, this message translates to:
  /// **'All Files'**
  String get sectionTitleAllFiles;

  /// No description provided for @sectionTitleRecent.
  ///
  /// In en, this message translates to:
  /// **'Recently Opened'**
  String get sectionTitleRecent;

  /// No description provided for @sectionTitleBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked Files'**
  String get sectionTitleBookmarks;

  /// No description provided for @emptyFiles.
  ///
  /// In en, this message translates to:
  /// **'No files yet.\n\nYou can tap the folder button in the top-right corner to scan a directory.'**
  String get emptyFiles;

  /// No description provided for @scanTooltip.
  ///
  /// In en, this message translates to:
  /// **'Scan files in a directory'**
  String get scanTooltip;

  /// No description provided for @scanProgress.
  ///
  /// In en, this message translates to:
  /// **'Scanning files, please wait…'**
  String get scanProgress;

  /// No description provided for @scanIndexedCount.
  ///
  /// In en, this message translates to:
  /// **'Indexed {count} files'**
  String scanIndexedCount(int count);

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan failed'**
  String get scanFailed;

  /// No description provided for @fileTypePdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get fileTypePdf;

  /// No description provided for @fileTypeDoc.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get fileTypeDoc;

  /// No description provided for @fileTypeTxt.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get fileTypeTxt;

  /// No description provided for @fileTypeMarkdown.
  ///
  /// In en, this message translates to:
  /// **'Markdown'**
  String get fileTypeMarkdown;

  /// No description provided for @fileTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get fileTypeOther;

  /// No description provided for @bookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get bookmark;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareTodo.
  ///
  /// In en, this message translates to:
  /// **'Share feature to be implemented'**
  String get shareTodo;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get loadFailed;

  /// No description provided for @cannotResolvePath.
  ///
  /// In en, this message translates to:
  /// **'Cannot resolve file path'**
  String get cannotResolvePath;

  /// No description provided for @loadMarkdownFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load Markdown'**
  String get loadMarkdownFailed;

  /// No description provided for @loadTextFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load text'**
  String get loadTextFailed;

  /// No description provided for @previewUnsupportedDoc.
  ///
  /// In en, this message translates to:
  /// **'Preview of this document type is not supported yet.\nYou can tap \"More\" in the top-right corner to open it with another app.'**
  String get previewUnsupportedDoc;

  /// No description provided for @previewUnsupportedFile.
  ///
  /// In en, this message translates to:
  /// **'Preview of this file type is not supported.\n\nPath:'**
  String get previewUnsupportedFile;

  /// No description provided for @moreOpenWithOther.
  ///
  /// In en, this message translates to:
  /// **'Open with another app'**
  String get moreOpenWithOther;

  /// No description provided for @moreOpenWithOtherTodo.
  ///
  /// In en, this message translates to:
  /// **'External open feature to be implemented'**
  String get moreOpenWithOtherTodo;

  /// No description provided for @moreExportConvert.
  ///
  /// In en, this message translates to:
  /// **'Export / Convert'**
  String get moreExportConvert;

  /// No description provided for @moreExportConvertTodo.
  ///
  /// In en, this message translates to:
  /// **'Export and format conversion feature to be implemented'**
  String get moreExportConvertTodo;

  /// No description provided for @moreDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete file'**
  String get moreDelete;

  /// No description provided for @moreDeleteTodo.
  ///
  /// In en, this message translates to:
  /// **'Delete feature to be implemented'**
  String get moreDeleteTodo;

  /// No description provided for @toolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get toolsTitle;

  /// No description provided for @toolsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Perform various operations on files (placeholder demo)'**
  String get toolsSubtitle;

  /// No description provided for @toolsMergePdf.
  ///
  /// In en, this message translates to:
  /// **'Merge PDFs'**
  String get toolsMergePdf;

  /// No description provided for @toolsMergePdfSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select multiple PDF files and merge them into one'**
  String get toolsMergePdfSubtitle;

  /// No description provided for @toolsExtractText.
  ///
  /// In en, this message translates to:
  /// **'Extract text'**
  String get toolsExtractText;

  /// No description provided for @toolsExtractTextSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Extract text from PDFs / images'**
  String get toolsExtractTextSubtitle;

  /// No description provided for @toolsTranslateFile.
  ///
  /// In en, this message translates to:
  /// **'Translate current file'**
  String get toolsTranslateFile;

  /// No description provided for @toolsTranslateFileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use external services to translate content'**
  String get toolsTranslateFileSubtitle;

  /// No description provided for @toolsReadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Reading settings'**
  String get toolsReadingSettings;

  /// No description provided for @toolsReadingSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Font size, theme, page turning mode, etc.'**
  String get toolsReadingSettingsSubtitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Interface language'**
  String get settingsLanguageSubtitle;

  /// No description provided for @languageSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettingsTitle;

  /// No description provided for @languageFollowSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get languageFollowSystem;

  /// No description provided for @languageFollowSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use system language (fall back to English if unsupported)'**
  String get languageFollowSystemSubtitle;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsThemeTitle;

  /// No description provided for @settingsThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Theme and colors'**
  String get settingsThemeSubtitle;

  /// No description provided for @themeSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get themeSettingsTitle;

  /// No description provided for @themeFollowSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get themeFollowSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Primary color'**
  String get themeColorTitle;

  /// No description provided for @themeColorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Accent color for interface'**
  String get themeColorSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

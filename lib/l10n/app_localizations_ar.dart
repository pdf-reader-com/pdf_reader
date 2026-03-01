// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'قارئ المستندات';

  @override
  String get tabAllFiles => 'كل الملفات';

  @override
  String get tabRecent => 'الأخيرة';

  @override
  String get tabBookmarks => 'الإشارات المرجعية';

  @override
  String get tabTools => 'الأدوات';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterPdf => 'PDF';

  @override
  String get filterEpub => 'EPUB';

  @override
  String get filterDoc => 'المستندات';

  @override
  String get filterTxt => 'نص';

  @override
  String get filterMarkdown => 'Markdown';

  @override
  String get sectionTitleAllFiles => 'كل الملفات';

  @override
  String get sectionTitleRecent => 'تم فتحها مؤخرًا';

  @override
  String get sectionTitleBookmarks => 'الملفات ذات الإشارات المرجعية';

  @override
  String get emptyFiles =>
      'لا توجد ملفات بعد.\n\nيمكنك الضغط على زر المجلد في أعلى اليمين لمسح مجلد.';

  @override
  String get scanTooltip => 'مسح الملفات في مجلد';

  @override
  String get scanProgress => 'جارٍ مسح الملفات، يرجى الانتظار…';

  @override
  String scanIndexedCount(int count) {
    return 'تم فهرسة $count من الملفات';
  }

  @override
  String get scanFailed => 'فشل المسح';

  @override
  String get fileTypePdf => 'PDF';

  @override
  String get fileTypeEpub => 'EPUB';

  @override
  String get fileTypeDoc => 'مستند';

  @override
  String get fileTypeTxt => 'نص';

  @override
  String get fileTypeMarkdown => 'Markdown';

  @override
  String get fileTypeOther => 'أخرى';

  @override
  String get bookmark => 'إشارة مرجعية';

  @override
  String get share => 'مشاركة';

  @override
  String get shareTodo => 'ميزة المشاركة قيد التنفيذ';

  @override
  String get more => 'المزيد';

  @override
  String get loadFailed => 'فشل التحميل';

  @override
  String get cannotResolvePath => 'تعذّر حل مسار الملف';

  @override
  String get loadMarkdownFailed => 'فشل تحميل Markdown';

  @override
  String get loadTextFailed => 'فشل تحميل النص';

  @override
  String get previewUnsupportedDoc =>
      'معاينة هذا النوع من المستندات غير مدعومة بعد.\nيمكنك الضغط على \"المزيد\" في أعلى اليمين لفتحه بواسطة تطبيق آخر.';

  @override
  String get previewUnsupportedFile =>
      'معاينة هذا النوع من الملفات غير مدعومة.\n\nالمسار:';

  @override
  String get moreOpenWithOther => 'فتح باستخدام تطبيق آخر';

  @override
  String get moreOpenWithOtherTodo => 'ميزة الفتح الخارجي قيد التنفيذ';

  @override
  String get moreExportConvert => 'تصدير / تحويل';

  @override
  String get moreExportConvertTodo => 'ميزة التصدير والتحويل قيد التنفيذ';

  @override
  String get moreDelete => 'حذف الملف';

  @override
  String get moreDeleteTodo => 'ميزة الحذف قيد التنفيذ';

  @override
  String get toolsTitle => 'الأدوات';

  @override
  String get toolsSubtitle => 'إجراء عمليات مختلفة على الملفات (عرض تجريبي)';

  @override
  String get toolsMergePdf => 'دمج ملفات PDF';

  @override
  String get toolsMergePdfSubtitle => 'اختر عدة ملفات PDF وادمجها في ملف واحد';

  @override
  String get toolsExtractText => 'استخراج النص';

  @override
  String get toolsExtractTextSubtitle => 'استخراج النص من ملفات PDF / الصور';

  @override
  String get toolsTranslateFile => 'ترجمة الملف الحالي';

  @override
  String get toolsTranslateFileSubtitle =>
      'استخدام خدمات خارجية لترجمة المحتوى';

  @override
  String get toolsReadingSettings => 'إعدادات القراءة';

  @override
  String get toolsReadingSettingsSubtitle =>
      'حجم الخط، النمط، طريقة التقليب، وغير ذلك';

  @override
  String get toolsPdfCraft => 'PDFCraft';

  @override
  String get toolsPdfCraftSubtitle =>
      'أدوات PDF مدمجة (دمج، تقسيم، تحويل، إلخ)';

  @override
  String get settingsTitle => 'الإعدادات';

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

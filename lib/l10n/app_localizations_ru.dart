// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Чтение документов';

  @override
  String get tabAllFiles => 'Все файлы';

  @override
  String get tabRecent => 'Недавние';

  @override
  String get tabBookmarks => 'Закладки';

  @override
  String get tabTools => 'Инструменты';

  @override
  String get filterAll => 'Все';

  @override
  String get filterPdf => 'PDF';

  @override
  String get filterEpub => 'EPUB';

  @override
  String get filterDoc => 'Документы';

  @override
  String get filterTxt => 'Текст';

  @override
  String get filterMarkdown => 'Markdown';

  @override
  String get sectionTitleAllFiles => 'Все файлы';

  @override
  String get sectionTitleRecent => 'Недавно открытые';

  @override
  String get sectionTitleBookmarks => 'Файлы с закладками';

  @override
  String get emptyFiles =>
      'Пока нет файлов.\n\nВы можете нажать кнопку папки в правом верхнем углу, чтобы просканировать каталог.';

  @override
  String get scanTooltip => 'Сканировать файлы в каталоге';

  @override
  String get scanProgress => 'Идёт сканирование файлов, пожалуйста, подождите…';

  @override
  String scanIndexedCount(int count) {
    return 'Проиндексировано файлов: $count';
  }

  @override
  String get scanFailed => 'Сканирование не удалось';

  @override
  String get fileTypePdf => 'PDF';

  @override
  String get fileTypeEpub => 'EPUB';

  @override
  String get fileTypeDoc => 'Документ';

  @override
  String get fileTypeTxt => 'Текст';

  @override
  String get fileTypeMarkdown => 'Markdown';

  @override
  String get fileTypeOther => 'Другое';

  @override
  String get bookmark => 'Закладка';

  @override
  String get share => 'Поделиться';

  @override
  String get shareTodo => 'Функция «Поделиться» будет реализована позже';

  @override
  String get more => 'Ещё';

  @override
  String get loadFailed => 'Не удалось загрузить';

  @override
  String get cannotResolvePath => 'Не удалось определить путь к файлу';

  @override
  String get loadMarkdownFailed => 'Не удалось загрузить Markdown';

  @override
  String get loadTextFailed => 'Не удалось загрузить текст';

  @override
  String get previewUnsupportedDoc =>
      'Предпросмотр этого типа документа пока не поддерживается.\nВы можете нажать «Ещё» в правом верхнем углу, чтобы открыть его в другом приложении.';

  @override
  String get previewUnsupportedFile =>
      'Предпросмотр этого типа файла не поддерживается.\n\nПуть:';

  @override
  String get moreOpenWithOther => 'Открыть в другом приложении';

  @override
  String get moreOpenWithOtherTodo =>
      'Функция внешнего открытия будет реализована позже';

  @override
  String get moreExportConvert => 'Экспорт / Конвертация';

  @override
  String get moreExportConvertTodo =>
      'Функции экспорта и конвертации будут реализованы позже';

  @override
  String get moreDelete => 'Удалить файл';

  @override
  String get moreDeleteTodo => 'Функция удаления будет реализована позже';

  @override
  String get deleteConfirmTitle => 'Удалить файл?';

  @override
  String get deleteConfirmMessage =>
      'Файл будет удалён безвозвратно. Это действие нельзя отменить.';

  @override
  String get shareFailed => 'Ошибка отправки';

  @override
  String get openWithOtherFailed => 'Не удалось открыть в другом приложении';

  @override
  String get deleteFailed => 'Не удалось удалить файл';

  @override
  String get cannotDeleteFile => 'Этот файл нельзя удалить отсюда.';

  @override
  String get toolsTitle => 'Инструменты';

  @override
  String get toolsSubtitle => 'Различные операции с файлами (демо-заглушка)';

  @override
  String get toolsMergePdf => 'Объединить PDF';

  @override
  String get toolsMergePdfSubtitle =>
      'Выберите несколько PDF-файлов и объедините их в один';

  @override
  String get toolsExtractText => 'Извлечь текст';

  @override
  String get toolsExtractTextSubtitle => 'Извлечь текст из PDF / изображений';

  @override
  String get toolsTranslateFile => 'Перевести текущий файл';

  @override
  String get toolsTranslateFileSubtitle =>
      'Использовать внешние сервисы для перевода содержимого';

  @override
  String get toolsReadingSettings => 'Настройки чтения';

  @override
  String get toolsReadingSettingsSubtitle =>
      'Размер шрифта, тема, способ перелистывания и другое';

  @override
  String get toolsPdfCraft => 'PDFCraft';

  @override
  String get toolsPdfCraftSubtitle =>
      'Встроенные PDF-инструменты (объединение, разделение, конвертация и т.д.)';

  @override
  String get settingsTitle => 'Настройки';

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

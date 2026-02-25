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

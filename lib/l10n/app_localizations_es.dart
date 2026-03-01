// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Lector de documentos';

  @override
  String get tabAllFiles => 'Todos los archivos';

  @override
  String get tabRecent => 'Recientes';

  @override
  String get tabBookmarks => 'Marcadores';

  @override
  String get tabTools => 'Herramientas';

  @override
  String get filterAll => 'Todo';

  @override
  String get filterPdf => 'PDF';

  @override
  String get filterEpub => 'EPUB';

  @override
  String get filterDoc => 'Documentos';

  @override
  String get filterTxt => 'Texto';

  @override
  String get filterMarkdown => 'Markdown';

  @override
  String get sectionTitleAllFiles => 'Todos los archivos';

  @override
  String get sectionTitleRecent => 'Abiertos recientemente';

  @override
  String get sectionTitleBookmarks => 'Archivos marcados';

  @override
  String get emptyFiles =>
      'Aún no hay archivos.\n\nPuedes usar el botón de carpeta en la esquina superior derecha para escanear un directorio.';

  @override
  String get scanTooltip => 'Escanear archivos en un directorio';

  @override
  String get scanProgress => 'Escaneando archivos, espera por favor…';

  @override
  String scanIndexedCount(int count) {
    return '$count archivos indexados';
  }

  @override
  String get scanFailed => 'Error al escanear';

  @override
  String get fileTypePdf => 'PDF';

  @override
  String get fileTypeEpub => 'EPUB';

  @override
  String get fileTypeDoc => 'Documento';

  @override
  String get fileTypeTxt => 'Texto';

  @override
  String get fileTypeMarkdown => 'Markdown';

  @override
  String get fileTypeOther => 'Otros';

  @override
  String get bookmark => 'Marcador';

  @override
  String get share => 'Compartir';

  @override
  String get shareTodo =>
      'La función de compartir está pendiente de implementación';

  @override
  String get more => 'Más';

  @override
  String get loadFailed => 'Error al cargar';

  @override
  String get cannotResolvePath => 'No se puede resolver la ruta del archivo';

  @override
  String get loadMarkdownFailed => 'Error al cargar Markdown';

  @override
  String get loadTextFailed => 'Error al cargar el texto';

  @override
  String get previewUnsupportedDoc =>
      'Todavía no se admite la vista previa de este tipo de documento.\nPuedes pulsar \"Más\" en la esquina superior derecha para abrirlo con otra aplicación.';

  @override
  String get previewUnsupportedFile =>
      'No se admite la vista previa de este tipo de archivo.\n\nRuta:';

  @override
  String get moreOpenWithOther => 'Abrir con otra aplicación';

  @override
  String get moreOpenWithOtherTodo =>
      'Abrir externamente está pendiente de implementación';

  @override
  String get moreExportConvert => 'Exportar / Convertir';

  @override
  String get moreExportConvertTodo =>
      'La función de exportar y convertir está pendiente de implementación';

  @override
  String get moreDelete => 'Eliminar archivo';

  @override
  String get moreDeleteTodo =>
      'La función de eliminar está pendiente de implementación';

  @override
  String get toolsTitle => 'Herramientas';

  @override
  String get toolsSubtitle =>
      'Realizar varias operaciones sobre los archivos (demo de ejemplo)';

  @override
  String get toolsMergePdf => 'Combinar PDFs';

  @override
  String get toolsMergePdfSubtitle =>
      'Selecciona varios archivos PDF y combínalos en uno';

  @override
  String get toolsExtractText => 'Extraer texto';

  @override
  String get toolsExtractTextSubtitle => 'Extraer texto de PDFs / imágenes';

  @override
  String get toolsTranslateFile => 'Traducir archivo actual';

  @override
  String get toolsTranslateFileSubtitle =>
      'Usar servicios externos para traducir el contenido';

  @override
  String get toolsReadingSettings => 'Ajustes de lectura';

  @override
  String get toolsReadingSettingsSubtitle =>
      'Tamaño de fuente, tema, modo de paso de página, etc.';

  @override
  String get toolsPdfCraft => 'PDFCraft';

  @override
  String get toolsPdfCraftSubtitle =>
      'Herramientas PDF integradas (combinar, dividir, convertir, etc.)';

  @override
  String get settingsTitle => 'Ajustes';

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

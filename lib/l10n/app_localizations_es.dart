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
}

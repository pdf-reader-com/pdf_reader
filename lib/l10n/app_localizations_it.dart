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
}

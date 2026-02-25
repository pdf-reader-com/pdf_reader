// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ドキュメントリーダー';

  @override
  String get tabAllFiles => 'すべてのファイル';

  @override
  String get tabRecent => '最近';

  @override
  String get tabBookmarks => 'ブックマーク';

  @override
  String get tabTools => 'ツール';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterPdf => 'PDF';

  @override
  String get filterDoc => 'ドキュメント';

  @override
  String get filterTxt => 'テキスト';

  @override
  String get filterMarkdown => 'Markdown';

  @override
  String get sectionTitleAllFiles => 'すべてのファイル';

  @override
  String get sectionTitleRecent => '最近開いたファイル';

  @override
  String get sectionTitleBookmarks => 'ブックマークされたファイル';

  @override
  String get emptyFiles => 'まだファイルがありません。\n\n右上のフォルダボタンをタップしてディレクトリをスキャンできます。';

  @override
  String get scanTooltip => 'ディレクトリ内のファイルをスキャン';

  @override
  String get scanProgress => 'ファイルをスキャンしています。しばらくお待ちください…';

  @override
  String scanIndexedCount(int count) {
    return '$count 個のファイルをインデックスしました';
  }

  @override
  String get scanFailed => 'スキャンに失敗しました';

  @override
  String get fileTypePdf => 'PDF';

  @override
  String get fileTypeDoc => 'ドキュメント';

  @override
  String get fileTypeTxt => 'テキスト';

  @override
  String get fileTypeMarkdown => 'Markdown';

  @override
  String get fileTypeOther => 'その他';

  @override
  String get bookmark => 'ブックマーク';

  @override
  String get share => '共有';

  @override
  String get shareTodo => '共有機能は実装予定です';

  @override
  String get more => 'その他';

  @override
  String get loadFailed => '読み込みに失敗しました';

  @override
  String get cannotResolvePath => 'ファイルパスを解決できません';

  @override
  String get loadMarkdownFailed => 'Markdown の読み込みに失敗しました';

  @override
  String get loadTextFailed => 'テキストの読み込みに失敗しました';

  @override
  String get previewUnsupportedDoc =>
      'この種類のドキュメントのプレビューはまだサポートされていません。\n右上の「その他」から別のアプリで開くことができます。';

  @override
  String get previewUnsupportedFile => 'この種類のファイルのプレビューはサポートされていません。\n\nパス：';

  @override
  String get moreOpenWithOther => '別のアプリで開く';

  @override
  String get moreOpenWithOtherTodo => '外部アプリで開く機能は実装予定です';

  @override
  String get moreExportConvert => 'エクスポート / 変換';

  @override
  String get moreExportConvertTodo => 'エクスポート／変換機能は実装予定です';

  @override
  String get moreDelete => 'ファイルを削除';

  @override
  String get moreDeleteTodo => '削除機能は実装予定です';

  @override
  String get toolsTitle => 'ツール';

  @override
  String get toolsSubtitle => 'ファイルに対してさまざまな処理を行う（プレースホルダーのデモ）';

  @override
  String get toolsMergePdf => 'PDF を結合';

  @override
  String get toolsMergePdfSubtitle => '複数の PDF ファイルを選択して 1 つに結合します';

  @override
  String get toolsExtractText => 'テキストを抽出';

  @override
  String get toolsExtractTextSubtitle => 'PDF / 画像からテキストを抽出';

  @override
  String get toolsTranslateFile => '現在のファイルを翻訳';

  @override
  String get toolsTranslateFileSubtitle => '外部サービスを使って内容を翻訳します';

  @override
  String get toolsReadingSettings => '閲覧設定';

  @override
  String get toolsReadingSettingsSubtitle => 'フォントサイズ、テーマ、ページ送り方法など';

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

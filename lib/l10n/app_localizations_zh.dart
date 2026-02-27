// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '文本阅读器';

  @override
  String get tabAllFiles => '所有文件';

  @override
  String get tabRecent => '最近';

  @override
  String get tabBookmarks => '书签';

  @override
  String get tabTools => '工具';

  @override
  String get filterAll => '全部';

  @override
  String get filterPdf => 'PDF';

  @override
  String get filterDoc => '文档';

  @override
  String get filterTxt => '文本';

  @override
  String get filterMarkdown => 'Markdown';

  @override
  String get sectionTitleAllFiles => '所有文件';

  @override
  String get sectionTitleRecent => '最近打开';

  @override
  String get sectionTitleBookmarks => '书签到的文件';

  @override
  String get emptyFiles => '暂无文件\n\n可以通过右上角文件夹按钮选择目录进行扫描';

  @override
  String get scanTooltip => '扫描目录中的文件';

  @override
  String get scanProgress => '正在扫描文件，请稍候…';

  @override
  String scanIndexedCount(int count) {
    return '已索引到 $count 个文件';
  }

  @override
  String get scanFailed => '扫描失败';

  @override
  String get fileTypePdf => 'PDF';

  @override
  String get fileTypeDoc => '文档';

  @override
  String get fileTypeTxt => '文本';

  @override
  String get fileTypeMarkdown => 'Markdown';

  @override
  String get fileTypeOther => '其他';

  @override
  String get bookmark => '书签';

  @override
  String get share => '分享';

  @override
  String get shareTodo => '分享功能待实现';

  @override
  String get more => '更多';

  @override
  String get loadFailed => '加载失败';

  @override
  String get cannotResolvePath => '无法解析文件路径';

  @override
  String get loadMarkdownFailed => '加载 Markdown 失败';

  @override
  String get loadTextFailed => '加载文本失败';

  @override
  String get previewUnsupportedDoc => '暂不支持直接预览此类文档。\n可以点击右上角“更多”选择使用其他应用打开。';

  @override
  String get previewUnsupportedFile => '暂不支持预览该文件类型。\n\n路径：';

  @override
  String get moreOpenWithOther => '使用其他应用打开';

  @override
  String get moreOpenWithOtherTodo => '外部打开功能待实现';

  @override
  String get moreExportConvert => '导出 / 转换';

  @override
  String get moreExportConvertTodo => '导出与格式转换功能待实现';

  @override
  String get moreDelete => '删除文件';

  @override
  String get moreDeleteTodo => '删除功能待实现';

  @override
  String get toolsTitle => '工具';

  @override
  String get toolsSubtitle => '对文件进行各种处理（示例占位）';

  @override
  String get toolsMergePdf => '合并 PDF';

  @override
  String get toolsMergePdfSubtitle => '选择多个 PDF 文件合并为一个';

  @override
  String get toolsExtractText => '提取文字';

  @override
  String get toolsExtractTextSubtitle => '从 PDF / 图片中提取文字';

  @override
  String get toolsTranslateFile => '翻译当前文件';

  @override
  String get toolsTranslateFileSubtitle => '调用外部服务对内容进行翻译';

  @override
  String get toolsReadingSettings => '阅读设置';

  @override
  String get toolsReadingSettingsSubtitle => '字体大小、主题、翻页方式等';

  @override
  String get toolsPdfCraft => 'PDFCraft';

  @override
  String get toolsPdfCraftSubtitle => '内置 PDF 工具（合并、拆分、转换等）';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguageTitle => '语言设置';

  @override
  String get settingsLanguageSubtitle => '界面语言';

  @override
  String get languageSettingsTitle => '语言设置';

  @override
  String get languageFollowSystem => '跟随系统';

  @override
  String get languageFollowSystemSubtitle => '使用系统语言（无匹配时显示英语）';

  @override
  String get settingsThemeTitle => '外观与主题';

  @override
  String get settingsThemeSubtitle => '暗色 / 浅色模式与配色';

  @override
  String get themeSettingsTitle => '外观与主题';

  @override
  String get themeFollowSystem => '跟随系统';

  @override
  String get themeLight => '浅色模式';

  @override
  String get themeDark => '深色模式';

  @override
  String get themeColorTitle => '主题配色';

  @override
  String get themeColorSubtitle => '界面主色和强调色';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '文字閱讀器';

  @override
  String get tabAllFiles => '所有檔案';

  @override
  String get tabRecent => '最近';

  @override
  String get tabBookmarks => '書籤';

  @override
  String get tabTools => '工具';

  @override
  String get filterAll => '全部';

  @override
  String get filterPdf => 'PDF';

  @override
  String get filterDoc => '文件';

  @override
  String get filterTxt => '文字';

  @override
  String get filterMarkdown => 'Markdown';

  @override
  String get sectionTitleAllFiles => '所有檔案';

  @override
  String get sectionTitleRecent => '最近開啟';

  @override
  String get sectionTitleBookmarks => '已加入書籤的檔案';

  @override
  String get emptyFiles => '暫無檔案\n\n可以透過右上角資料夾按鈕選擇目錄進行掃描';

  @override
  String get scanTooltip => '掃描目錄中的檔案';

  @override
  String get scanProgress => '正在掃描檔案，請稍候…';

  @override
  String scanIndexedCount(int count) {
    return '已索引 $count 個檔案';
  }

  @override
  String get scanFailed => '掃描失敗';

  @override
  String get fileTypePdf => 'PDF';

  @override
  String get fileTypeDoc => '文件';

  @override
  String get fileTypeTxt => '文字';

  @override
  String get fileTypeMarkdown => 'Markdown';

  @override
  String get fileTypeOther => '其他';

  @override
  String get bookmark => '書籤';

  @override
  String get share => '分享';

  @override
  String get shareTodo => '分享功能待實作';

  @override
  String get more => '更多';

  @override
  String get loadFailed => '載入失敗';

  @override
  String get cannotResolvePath => '無法解析檔案路徑';

  @override
  String get loadMarkdownFailed => '載入 Markdown 失敗';

  @override
  String get loadTextFailed => '載入文字失敗';

  @override
  String get previewUnsupportedDoc => '暫不支援直接預覽此類文件。\n可以點選右上角「更多」選擇使用其他應用程式開啟。';

  @override
  String get previewUnsupportedFile => '暫不支援預覽此檔案類型。\n\n路徑：';

  @override
  String get moreOpenWithOther => '使用其他應用程式開啟';

  @override
  String get moreOpenWithOtherTodo => '外部開啟功能待實作';

  @override
  String get moreExportConvert => '匯出 / 轉換';

  @override
  String get moreExportConvertTodo => '匯出與格式轉換功能待實作';

  @override
  String get moreDelete => '刪除檔案';

  @override
  String get moreDeleteTodo => '刪除功能待實作';

  @override
  String get toolsTitle => '工具';

  @override
  String get toolsSubtitle => '對檔案進行各種處理（示例占位）';

  @override
  String get toolsMergePdf => '合併 PDF';

  @override
  String get toolsMergePdfSubtitle => '選擇多個 PDF 檔案合併為一個';

  @override
  String get toolsExtractText => '擷取文字';

  @override
  String get toolsExtractTextSubtitle => '從 PDF / 圖片中擷取文字';

  @override
  String get toolsTranslateFile => '翻譯目前檔案';

  @override
  String get toolsTranslateFileSubtitle => '呼叫外部服務對內容進行翻譯';

  @override
  String get toolsReadingSettings => '閱讀設定';

  @override
  String get toolsReadingSettingsSubtitle => '字型大小、主題、翻頁方式等';

  @override
  String get toolsPdfCraft => 'PDFCraft';

  @override
  String get toolsPdfCraftSubtitle => '內建 PDF 工具（合併、分割、轉換等）';

  @override
  String get settingsTitle => '設定';
}

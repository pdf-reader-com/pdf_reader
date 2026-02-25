// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '문서 리더';

  @override
  String get tabAllFiles => '모든 파일';

  @override
  String get tabRecent => '최근';

  @override
  String get tabBookmarks => '즐겨찾기';

  @override
  String get tabTools => '도구';

  @override
  String get filterAll => '전체';

  @override
  String get filterPdf => 'PDF';

  @override
  String get filterDoc => '문서';

  @override
  String get filterTxt => '텍스트';

  @override
  String get filterMarkdown => 'Markdown';

  @override
  String get sectionTitleAllFiles => '모든 파일';

  @override
  String get sectionTitleRecent => '최근에 연 파일';

  @override
  String get sectionTitleBookmarks => '즐겨찾기한 파일';

  @override
  String get emptyFiles =>
      '아직 파일이 없습니다.\n\n오른쪽 상단의 폴더 버튼을 눌러 디렉터리를 스캔할 수 있습니다.';

  @override
  String get scanTooltip => '디렉터리의 파일 스캔';

  @override
  String get scanProgress => '파일을 스캔하는 중입니다. 잠시만 기다려 주세요…';

  @override
  String scanIndexedCount(int count) {
    return '$count개의 파일을 인덱싱했습니다';
  }

  @override
  String get scanFailed => '스캔 실패';

  @override
  String get fileTypePdf => 'PDF';

  @override
  String get fileTypeDoc => '문서';

  @override
  String get fileTypeTxt => '텍스트';

  @override
  String get fileTypeMarkdown => 'Markdown';

  @override
  String get fileTypeOther => '기타';

  @override
  String get bookmark => '즐겨찾기';

  @override
  String get share => '공유';

  @override
  String get shareTodo => '공유 기능은 추후 구현 예정입니다';

  @override
  String get more => '더보기';

  @override
  String get loadFailed => '불러오기에 실패했습니다';

  @override
  String get cannotResolvePath => '파일 경로를 확인할 수 없습니다';

  @override
  String get loadMarkdownFailed => 'Markdown 불러오기에 실패했습니다';

  @override
  String get loadTextFailed => '텍스트 불러오기에 실패했습니다';

  @override
  String get previewUnsupportedDoc =>
      '이 형식의 문서 미리보기는 아직 지원되지 않습니다.\n오른쪽 상단의 \"더보기\"를 눌러 다른 앱으로 열 수 있습니다.';

  @override
  String get previewUnsupportedFile => '이 형식의 파일 미리보기는 지원되지 않습니다.\n\n경로:';

  @override
  String get moreOpenWithOther => '다른 앱으로 열기';

  @override
  String get moreOpenWithOtherTodo => '외부 앱으로 열기 기능은 추후 구현 예정입니다';

  @override
  String get moreExportConvert => '내보내기 / 변환';

  @override
  String get moreExportConvertTodo => '내보내기 및 변환 기능은 추후 구현 예정입니다';

  @override
  String get moreDelete => '파일 삭제';

  @override
  String get moreDeleteTodo => '삭제 기능은 추후 구현 예정입니다';

  @override
  String get toolsTitle => '도구';

  @override
  String get toolsSubtitle => '파일에 다양한 작업 수행 (예시 데모)';

  @override
  String get toolsMergePdf => 'PDF 병합';

  @override
  String get toolsMergePdfSubtitle => '여러 개의 PDF 파일을 선택하여 하나로 병합합니다';

  @override
  String get toolsExtractText => '텍스트 추출';

  @override
  String get toolsExtractTextSubtitle => 'PDF / 이미지에서 텍스트 추출';

  @override
  String get toolsTranslateFile => '현재 파일 번역';

  @override
  String get toolsTranslateFileSubtitle => '외부 서비스를 사용해 내용을 번역합니다';

  @override
  String get toolsReadingSettings => '읽기 설정';

  @override
  String get toolsReadingSettingsSubtitle => '글꼴 크기, 테마, 페이지 넘김 방식 등';

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

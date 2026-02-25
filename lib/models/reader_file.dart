enum FileType {
  pdf,
  doc,
  txt,
  markdown,
  other,
}

class ReaderFile {
  ReaderFile({
    required this.name,
    required this.path,
    required this.type,
    required this.modifiedAt,
    this.isBookmarked = false,
    this.sizeInBytes,
    this.lastOpenedAt,
  });

  final String name;
  final String path;
  final FileType type;
  final DateTime modifiedAt;
  bool isBookmarked;
  final int? sizeInBytes;

  /// 最近一次打开时间，用于“最近”列表排序
  DateTime? lastOpenedAt;
}


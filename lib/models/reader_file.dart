import 'package:path/path.dart' as p;

enum FileType {
  pdf,
  epub,
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

  /// 仅从路径创建（用于从持久化的 recent/bookmark 恢复显示）
  static ReaderFile fromPath(
    String path, {
    DateTime? lastOpenedAt,
    bool isBookmarked = false,
  }) {
    final name = _basenameFromPath(path);
    final type = _typeFromPath(path);
    return ReaderFile(
      name: name,
      path: path,
      type: type,
      modifiedAt: DateTime.now(),
      isBookmarked: isBookmarked,
      lastOpenedAt: lastOpenedAt,
    );
  }

  static String _basenameFromPath(String path) {
    // content:// 或 file:// 的 path 可能含 %2F，取最后一段
    final uri = path;
    final lastSlash = uri.lastIndexOf('/');
    if (lastSlash >= 0 && lastSlash < uri.length - 1) {
      return Uri.decodeComponent(uri.substring(lastSlash + 1));
    }
    return p.basename(path);
  }

  static FileType _typeFromPath(String path) {
    final ext = p.extension(path).toLowerCase();
    if (ext.isEmpty && path.contains('.')) {
      final idx = path.lastIndexOf('.');
      if (idx >= 0) {
        final s = path.substring(idx).toLowerCase();
        if (s == '.pdf') return FileType.pdf;
        if (s == '.epub') return FileType.epub;
        if (s == '.doc' || s == '.docx' || s == '.xls' || s == '.xlsx' ||
            s == '.ppt' || s == '.pptx') {
          return FileType.doc;
        }
        if (s == '.txt') return FileType.txt;
        if (s == '.md' || s == '.markdown') return FileType.markdown;
      }
    }
    switch (ext) {
      case '.pdf':
        return FileType.pdf;
      case '.epub':
        return FileType.epub;
      case '.doc':
      case '.docx':
      case '.xls':
      case '.xlsx':
      case '.ppt':
      case '.pptx':
        return FileType.doc;
      case '.txt':
        return FileType.txt;
      case '.md':
      case '.markdown':
        return FileType.markdown;
      default:
        return FileType.other;
    }
  }

  Map<String, dynamic> toJson() => {
        'path': path,
        'name': name,
        'type': type.name,
        'modifiedAt': modifiedAt.millisecondsSinceEpoch,
        'sizeInBytes': sizeInBytes,
      };

  static ReaderFile? fromJson(Map<String, dynamic> json) {
    final path = json['path'] as String?;
    final name = json['name'] as String?;
    final typeStr = json['type'] as String?;
    final modifiedAt = json['modifiedAt'];
    final sizeInBytes = json['sizeInBytes'];
    if (path == null || name == null || typeStr == null) return null;
    FileType? type;
    for (final e in FileType.values) {
      if (e.name == typeStr) {
        type = e;
        break;
      }
    }
    if (type == null) return null;
    final ms = modifiedAt is int ? modifiedAt : null;
    return ReaderFile(
      name: name,
      path: path,
      type: type,
      modifiedAt: ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : DateTime.now(),
      sizeInBytes: sizeInBytes is int ? sizeInBytes : null,
    );
  }
}


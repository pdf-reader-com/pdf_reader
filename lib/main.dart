import 'dart:io';

import 'package:docx_file_viewer/docx_file_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Android 上通过 content URI 列出/打开文件时使用
const _androidChannel = MethodChannel('com.pdf_reader/pdf_reader');

/// 若为 Android content URI 则先复制到临时文件并返回路径，否则返回原 path
Future<String> _resolvePreviewPath(ReaderFile file) async {
  if (Platform.isAndroid && file.path.startsWith('content://')) {
    final path = await _androidChannel.invokeMethod<String>(
      'openContentUriToTemp',
      <String, dynamic>{'uri': file.path},
    );
    if (path != null && path.isNotEmpty) return path;
  }
  return file.path;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '文本阅读器',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ReaderHomePage(),
    );
  }
}

/// 文件类型
enum FileType {
  pdf,
  doc,
  txt,
  markdown,
  other,
}

/// 设备上的一个文件
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

class ReaderHomePage extends StatefulWidget {
  const ReaderHomePage({super.key});

  @override
  State<ReaderHomePage> createState() => _ReaderHomePageState();
}

class _ReaderHomePageState extends State<ReaderHomePage> {
  int _currentIndex = 0;
  FileType? _filterType;
  bool _isScanning = false;

  /// 当前索引到的所有文件
  final List<ReaderFile> _allFiles = [];

  /// 最近打开记录（path -> lastOpenedAt 毫秒时间戳）
  final Map<String, DateTime> _recentMap = {};

  /// 书签记录（path 集合）
  final Set<String> _bookmarkPaths = {};

  static const _prefsKeyRecent = 'reader_recent';
  static const _prefsKeyBookmarks = 'reader_bookmarks';

  @override
  void initState() {
    super.initState();
    _loadPersistentState();
  }

  Future<void> _loadPersistentState() async {
    final prefs = await SharedPreferences.getInstance();
    final recentRaw = prefs.getStringList(_prefsKeyRecent) ?? [];
    final bookmarkRaw = prefs.getStringList(_prefsKeyBookmarks) ?? [];

    // recent 采用 "path|timestamp" 的格式
    for (final entry in recentRaw) {
      final parts = entry.split('|');
      if (parts.length != 2) continue;
      final path = parts[0];
      final millis = int.tryParse(parts[1]);
      if (millis == null) continue;
      _recentMap[path] = DateTime.fromMillisecondsSinceEpoch(millis);
    }

    _bookmarkPaths
      ..clear()
      ..addAll(bookmarkRaw);
  }

  Future<void> _savePersistentState() async {
    final prefs = await SharedPreferences.getInstance();
    final recentRaw = _recentMap.entries
        .map((e) => '${e.key}|${e.value.millisecondsSinceEpoch}')
        .toList();
    await prefs.setStringList(_prefsKeyRecent, recentRaw);
    await prefs.setStringList(_prefsKeyBookmarks, _bookmarkPaths.toList());
  }

  List<ReaderFile> get _recentFiles {
    final files =
        _allFiles.where((f) => f.lastOpenedAt != null).toList(growable: false);
    files.sort((a, b) => b.lastOpenedAt!.compareTo(a.lastOpenedAt!));
    return files.take(50).toList();
  }

  List<ReaderFile> get _bookmarkedFiles =>
      _allFiles.where((f) => f.isBookmarked).toList();

  List<ReaderFile> _applyFilter(List<ReaderFile> files) {
    if (_filterType == null) return files;
    return files.where((f) => f.type == _filterType).toList();
  }

  void _onTapFile(ReaderFile file) async {
    setState(() {
      file.lastOpenedAt = DateTime.now();
      _recentMap[file.path] = file.lastOpenedAt!;
    });

    final updatedBookmark = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FilePreviewPage(
          file: file,
        ),
      ),
    );

    if (updatedBookmark != null) {
      setState(() {
        file.isBookmarked = updatedBookmark;
        if (file.isBookmarked) {
          _bookmarkPaths.add(file.path);
        } else {
          _bookmarkPaths.remove(file.path);
        }
      });
      _savePersistentState();
    }
  }

  void _onChangeFilter(FileType? type) {
    setState(() {
      _filterType = type;
    });
  }

  Future<void> _scanFiles() async {
    setState(() {
      _isScanning = true;
    });

    try {
      List<ReaderFile> found;
      if (Platform.isAndroid) {
        found = await _scanFilesAndroid();
      } else {
        found = await _scanFilesDesktop();
      }
      if (!mounted) return;

      setState(() {
        _allFiles
          ..clear()
          ..addAll(found);
        for (final f in _allFiles) {
          if (_recentMap.containsKey(f.path)) {
            f.lastOpenedAt = _recentMap[f.path];
          }
          f.isBookmarked = _bookmarkPaths.contains(f.path);
        }
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已索引到 ${found.length} 个文件')),
      );
      await _savePersistentState();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('扫描失败：$e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  /// Android：用系统目录选择器拿到 content tree URI，再通过 DocumentFile 递归列出文件
  Future<List<ReaderFile>> _scanFilesAndroid() async {
    final uri = await _androidChannel.invokeMethod<String>('pickDirectory');
    if (uri == null || uri.isEmpty) return [];

    final raw = await _androidChannel.invokeMethod<List<dynamic>>(
      'listFilesFromTreeUri',
      <String, dynamic>{'uri': uri},
    );
    if (raw == null) return [];

    final List<ReaderFile> found = [];
    for (final e in raw) {
      final map = e as Map<dynamic, dynamic>;
      final path = map['path'] as String?;
      final name = map['name'] as String?;
      final size = map['size'] as int?;
      final lastModified = map['lastModified'] as int?;
      final ext = (map['extension'] as String?) ?? '';
      if (path == null || name == null) continue;
      final type = _fileTypeFromExtension(ext.isEmpty ? p.extension(name) : ext);
      if (type == null) continue;
      found.add(
        ReaderFile(
          name: name,
          path: path,
          type: type,
          modifiedAt: lastModified != null
              ? DateTime.fromMillisecondsSinceEpoch(lastModified)
              : DateTime.now(),
          sizeInBytes: size,
        ),
      );
    }
    return found;
  }

  /// 桌面 / iOS：file_picker 返回真实路径，用 dart:io Directory 递归
  Future<List<ReaderFile>> _scanFilesDesktop() async {
    final rootPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: '选择一个目录以扫描文档',
    );
    if (rootPath == null) return [];

    final List<ReaderFile> found = [];
    final directory = Directory(rootPath);
    await for (final entity
        in directory.list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final ext = p.extension(entity.path).toLowerCase();
      final type = _fileTypeFromExtension(ext);
      if (type == null) continue;
      try {
        final stat = await entity.stat();
        found.add(
          ReaderFile(
            name: p.basename(entity.path),
            path: entity.path,
            type: type,
            modifiedAt: stat.modified,
            sizeInBytes: stat.size,
          ),
        );
      } catch (_) {}
    }
    return found;
  }

  FileType? _fileTypeFromExtension(String ext) {
    switch (ext) {
      case '.pdf':
        return FileType.pdf;
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
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    String title;

    switch (_currentIndex) {
      case 0:
        title = '所有文件';
        body = FileListView(
          title: '所有文件',
          files: _applyFilter(_allFiles),
          currentFilter: _filterType,
          onChangeFilter: _onChangeFilter,
          onTapFile: _onTapFile,
        );
        break;
      case 1:
        title = '最近';
        body = FileListView(
          title: '最近打开',
          files: _applyFilter(_recentFiles),
          currentFilter: _filterType,
          onChangeFilter: _onChangeFilter,
          onTapFile: _onTapFile,
        );
        break;
      case 2:
        title = '书签';
        body = FileListView(
          title: '书签到的文件',
          files: _applyFilter(_bookmarkedFiles),
          currentFilter: _filterType,
          onChangeFilter: _onChangeFilter,
          onTapFile: _onTapFile,
          emptyPlaceholder: const Text('还没有添加任何书签'),
        );
        break;
      case 3:
        title = '工具';
        body = const ToolsPage();
        break;
      default:
        title = '所有文件';
        body = Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          if (_currentIndex != 3)
            IconButton(
              tooltip: '扫描目录中的文件',
              icon: const Icon(Icons.folder_open),
              onPressed: _isScanning ? null : _scanFiles,
            ),
        ],
      ),
      body: Stack(
        children: [
          body,
          if (_isScanning)
            Container(
              color: Colors.black26,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      '正在扫描文件，请稍候…',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: '所有文件',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: '最近',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: '书签',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined),
            selectedIcon: Icon(Icons.build),
            label: '工具',
          ),
        ],
      ),
    );
  }
}

class FileListView extends StatelessWidget {
  const FileListView({
    super.key,
    required this.title,
    required this.files,
    required this.currentFilter,
    required this.onChangeFilter,
    required this.onTapFile,
    this.emptyPlaceholder,
  });

  final String title;
  final List<ReaderFile> files;
  final FileType? currentFilter;
  final void Function(FileType? type) onChangeFilter;
  final void Function(ReaderFile file) onTapFile;
  final Widget? emptyPlaceholder;

  @override
  Widget build(BuildContext context) {
    final filteredFiles = files;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              FilterChip(
                label: const Text('全部'),
                selected: currentFilter == null,
                onSelected: (_) => onChangeFilter(null),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('PDF'),
                selected: currentFilter == FileType.pdf,
                onSelected: (_) => onChangeFilter(FileType.pdf),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('文档'),
                selected: currentFilter == FileType.doc,
                onSelected: (_) => onChangeFilter(FileType.doc),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('文本'),
                selected: currentFilter == FileType.txt,
                onSelected: (_) => onChangeFilter(FileType.txt),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Markdown'),
                selected: currentFilter == FileType.markdown,
                onSelected: (_) => onChangeFilter(FileType.markdown),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: filteredFiles.isEmpty
              ? Center(
                  child: emptyPlaceholder ??
                      const Text(
                        '暂无文件\n\n可以通过右上角文件夹按钮选择目录进行扫描',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                )
              : ListView.separated(
                  itemCount: filteredFiles.length,
                  itemBuilder: (context, index) {
                    final file = filteredFiles[index];
                    return ListTile(
                      leading: Icon(_iconForType(file.type)),
                      title: Text(file.name),
                      subtitle: Text(
                        _subtitleForFile(file),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(
                        file.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: file.isBookmarked
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      onTap: () => onTapFile(file),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(height: 1),
                ),
        ),
      ],
    );
  }

  static IconData _iconForType(FileType type) {
    switch (type) {
      case FileType.pdf:
        return Icons.picture_as_pdf;
      case FileType.doc:
        return Icons.description;
      case FileType.txt:
        return Icons.notes;
      case FileType.markdown:
        return Icons.article_outlined;
      case FileType.other:
        return Icons.insert_drive_file;
    }
  }

  static String _subtitleForFile(ReaderFile file) {
    final typeLabel = switch (file.type) {
      FileType.pdf => 'PDF',
      FileType.doc => '文档',
      FileType.txt => '文本',
      FileType.markdown => 'Markdown',
      FileType.other => '其他',
    };

    return '$typeLabel · ${file.path}';
  }
}

class FilePreviewPage extends StatefulWidget {
  const FilePreviewPage({super.key, required this.file});

  final ReaderFile file;

  @override
  State<FilePreviewPage> createState() => _FilePreviewPageState();
}

class _FilePreviewPageState extends State<FilePreviewPage> {
  late final Future<String> _resolvedPathFuture;

  @override
  void initState() {
    super.initState();
    _resolvedPathFuture = _resolvePreviewPath(widget.file);
  }

  @override
  Widget build(BuildContext context) {
    final file = widget.file;

    return Scaffold(
      appBar: AppBar(
        title: Text(file.name),
        actions: [
          IconButton(
            tooltip: '书签',
            icon: Icon(
              file.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: () {
              setState(() {
                file.isBookmarked = !file.isBookmarked;
              });
            },
          ),
          IconButton(
            tooltip: '分享',
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('分享功能待实现')),
              );
            },
          ),
          IconButton(
            tooltip: '更多',
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showMoreActions(context, file);
            },
          ),
        ],
      ),
      body: _buildPreviewBody(file),
    );
  }

  Widget _buildPreviewBody(ReaderFile file) {
    return FutureBuilder<String>(
      future: _resolvedPathFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('加载失败：${snapshot.error}'),
          );
        }
        final path = snapshot.data;
        if (path == null || path.isEmpty) {
          return const Center(child: Text('无法解析文件路径'));
        }
        return _buildPreviewWithPath(file, path);
      },
    );
  }

  Widget _buildPreviewWithPath(ReaderFile file, String path) {
    switch (file.type) {
      case FileType.pdf:
        return PdfViewer.file(path);
      case FileType.markdown:
        return FutureBuilder<String>(
          future: File(path).readAsString(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('加载 Markdown 失败：${snapshot.error}'),
              );
            }
            return Markdown(
              data: snapshot.data ?? '',
            );
          },
        );
      case FileType.txt:
        return FutureBuilder<String>(
          future: File(path).readAsString(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('加载文本失败：${snapshot.error}'),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(snapshot.data ?? ''),
            );
          },
        );
      case FileType.doc:
        final ext = p.extension(file.name).toLowerCase();
        if (ext == '.docx') {
          return DocxViewWithSearch(
            file: File(path),
            config: DocxViewConfig(
              enableSearch: true,
              enableZoom: true,
              theme: DocxViewTheme.light(),
            ),
          );
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '暂不支持直接预览此类文档。\n'
              '可以点击右上角“更多”选择使用其他应用打开。',
              textAlign: TextAlign.center,
            ),
          ),
        );
      case FileType.other:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '暂不支持预览该文件类型。\n\n路径：${file.path}',
              textAlign: TextAlign.center,
            ),
          ),
        );
    }
  }

  void _showMoreActions(BuildContext context, ReaderFile file) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.open_in_new),
                title: const Text('使用其他应用打开'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('外部打开功能待实现')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('导出 / 转换'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('导出与格式转换功能待实现')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('删除文件'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('删除功能待实现')),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        const ListTile(
          title: Text(
            '工具',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('对文件进行各种处理（示例占位）'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.picture_as_pdf),
          title: const Text('合并 PDF'),
          subtitle: const Text('选择多个 PDF 文件合并为一个'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('合并 PDF 工具待实现')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.text_fields),
          title: const Text('提取文字'),
          subtitle: const Text('从 PDF / 图片中提取文字'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('文字提取工具待实现')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.translate),
          title: const Text('翻译当前文件'),
          subtitle: const Text('调用外部服务对内容进行翻译'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('翻译工具待实现')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('阅读设置'),
          subtitle: const Text('字体大小、主题、翻页方式等'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('设置页待实现')),
            );
          },
        ),
      ],
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart' hide FileType;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_reader/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/reader_file.dart';
import 'file_preview_page.dart';
import 'settings_page.dart';
import 'tools_page.dart';

/// Android 上通过 content URI 列出/打开文件时使用
const _androidChannel = MethodChannel('com.pdf_reader/pdf_reader');

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
  static const _fileListFileName = 'reader_file_list.json';

  Future<String> _fileListStoragePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, _fileListFileName);
  }

  @override
  void initState() {
    super.initState();
    _loadPersistentState();
  }

  Future<void> _loadPersistentState() async {
    final skipMemory = Platform.isMacOS || Platform.isIOS;

    if (!skipMemory) {
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

    // 恢复上次扫描的文件列表（仅 Android/Windows 等；macOS/iOS 不记忆）
    if (!skipMemory) {
      try {
        final path = await _fileListStoragePath();
        final file = File(path);
        if (await file.exists()) {
          final jsonStr = await file.readAsString();
          final list = jsonDecode(jsonStr) as List<dynamic>?;
          if (list != null) {
            final restored = <ReaderFile>[];
            for (final e in list) {
              final map = e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e as Map);
              final rf = ReaderFile.fromJson(map);
              if (rf == null) continue;
              if (!Platform.isAndroid) {
                if (!File(rf.path).existsSync()) continue;
              }
              rf.lastOpenedAt = _recentMap[rf.path];
              rf.isBookmarked = _bookmarkPaths.contains(rf.path);
              restored.add(rf);
            }
            if (mounted) {
              setState(() {
                _allFiles
                  ..clear()
                  ..addAll(restored);
              });
            }
          }
        }
      } catch (_) {
        // 首次启动或文件损坏时忽略
      }
    }
  }

  Future<void> _savePersistentState() async {
    final skipMemory = Platform.isMacOS || Platform.isIOS;
    if (!skipMemory) {
      final prefs = await SharedPreferences.getInstance();
      final recentRaw = _recentMap.entries
          .map((e) => '${e.key}|${e.value.millisecondsSinceEpoch}')
          .toList();
      await prefs.setStringList(_prefsKeyRecent, recentRaw);
      await prefs.setStringList(_prefsKeyBookmarks, _bookmarkPaths.toList());
    }

    // macOS/iOS 不持久化文件列表
    if (skipMemory) return;
    try {
      final path = await _fileListStoragePath();
      final list = _allFiles.map((f) => f.toJson()).toList();
      await File(path).writeAsString(jsonEncode(list));
    } catch (_) {}
  }

  List<ReaderFile> get _recentFiles {
    final fromAll =
        _allFiles.where((f) => f.lastOpenedAt != null).toList(growable: false);
    final pathSet = fromAll.map((e) => e.path).toSet();
    final synthetic = _recentMap.entries
        .where((e) => !pathSet.contains(e.key))
        .map((e) => ReaderFile.fromPath(e.key, lastOpenedAt: e.value))
        .toList();
    final combined = [...fromAll, ...synthetic];
    combined.sort((a, b) => (b.lastOpenedAt ?? DateTime(0)).compareTo(a.lastOpenedAt ?? DateTime(0)));
    return combined.take(50).toList();
  }

  List<ReaderFile> get _bookmarkedFiles {
    final fromAll = _allFiles.where((f) => f.isBookmarked).toList();
    final pathSet = fromAll.map((e) => e.path).toSet();
    final synthetic = _bookmarkPaths
        .where((p) => !pathSet.contains(p))
        .map((p) => ReaderFile.fromPath(p, isBookmarked: true))
        .toList();
    return [...fromAll, ...synthetic];
  }

  List<ReaderFile> _applyFilter(List<ReaderFile> files) {
    if (_filterType == null) return files;
    return files.where((f) => f.type == _filterType).toList();
  }

  void _onTapFile(ReaderFile file) async {
    setState(() {
      file.lastOpenedAt = DateTime.now();
      _recentMap[file.path] = file.lastOpenedAt!;
    });
    _savePersistentState(); // 打开即保存最近记录

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
        SnackBar(content: Text(AppLocalizations.of(context)!.scanIndexedCount(found.length))),
      );
      await _savePersistentState();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.scanFailed)),
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
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    Widget body;
    String title;

    switch (_currentIndex) {
      case 0:
        title = l.tabAllFiles;
        body = FileListView(
          title: l.sectionTitleAllFiles,
          files: _applyFilter(_allFiles),
          currentFilter: _filterType,
          onChangeFilter: _onChangeFilter,
          onTapFile: _onTapFile,
        );
        break;
      case 1:
        title = l.tabRecent;
        body = FileListView(
          title: l.sectionTitleRecent,
          files: _applyFilter(_recentFiles),
          currentFilter: _filterType,
          onChangeFilter: _onChangeFilter,
          onTapFile: _onTapFile,
        );
        break;
      case 2:
        title = l.tabBookmarks;
        body = FileListView(
          title: l.sectionTitleBookmarks,
          files: _applyFilter(_bookmarkedFiles),
          currentFilter: _filterType,
          onChangeFilter: _onChangeFilter,
          onTapFile: _onTapFile,
          emptyPlaceholder: Text(l.bookmark),
        );
        break;
      case 3:
        title = l.tabTools;
        body = const ToolsPage();
        break;
      case 4:
        title = l.settingsTitle;
        body = const SettingsPage();
        break;
      default:
        title = l.tabAllFiles;
        body = Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          if (_currentIndex != 3)
            IconButton(
              tooltip: l.scanTooltip,
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
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.folder_outlined),
            selectedIcon: const Icon(Icons.folder),
            label: l.tabAllFiles,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history),
            label: l.tabRecent,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark_border),
            selectedIcon: const Icon(Icons.bookmark),
            label: l.tabBookmarks,
          ),
          NavigationDestination(
            icon: const Icon(Icons.build_outlined),
            selectedIcon: const Icon(Icons.build),
            label: l.tabTools,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l.settingsTitle,
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
    final l = AppLocalizations.of(context)!;

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
                label: Text(l.filterAll),
                selected: currentFilter == null,
                onSelected: (_) => onChangeFilter(null),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(l.filterPdf),
                selected: currentFilter == FileType.pdf,
                onSelected: (_) => onChangeFilter(FileType.pdf),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(l.filterEpub),
                selected: currentFilter == FileType.epub,
                onSelected: (_) => onChangeFilter(FileType.epub),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(l.filterDoc),
                selected: currentFilter == FileType.doc,
                onSelected: (_) => onChangeFilter(FileType.doc),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(l.filterTxt),
                selected: currentFilter == FileType.txt,
                onSelected: (_) => onChangeFilter(FileType.txt),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(l.filterMarkdown),
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
                      Text(
                        l.emptyFiles,
                        style: const TextStyle(color: Colors.grey),
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
                        _subtitleForFile(context, file),
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
      case FileType.epub:
        return Icons.menu_book;
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

  static String _subtitleForFile(BuildContext context, ReaderFile file) {
    final l = AppLocalizations.of(context)!;
    final typeLabel = switch (file.type) {
      FileType.pdf => l.fileTypePdf,
      FileType.epub => l.fileTypeEpub,
      FileType.doc => l.fileTypeDoc,
      FileType.txt => l.fileTypeTxt,
      FileType.markdown => l.fileTypeMarkdown,
      FileType.other => l.fileTypeOther,
    };

    return '$typeLabel · ${file.path}';
  }
}


import 'dart:async';
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

/// 各平台通过此 MethodChannel 与原生通信（目录选择、content URI、初始打开文件等）
const _androidChannel = MethodChannel('com.pdf_reader/pdf_reader');
/// macOS/Android 用 EventChannel 在原生收到「打开文件」时主动推送路径或 URI（应用已运行时必走此路）
final _openFileEventChannel = EventChannel('com.pdf_reader/pdf_reader_events');

class ReaderHomePage extends StatefulWidget {
  const ReaderHomePage({super.key});

  @override
  State<ReaderHomePage> createState() => _ReaderHomePageState();
}

class _ReaderHomePageState extends State<ReaderHomePage>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  FileType? _filterType;
  bool _isScanning = false;

  /// 列表选择模式（用于批量从列表移除）
  bool _selectionMode = false;
  final Set<String> _selectedPaths = {};

  /// 点击「扫描全部」时未授权，已跳转设置；返回后若仍未授权则提示失败
  bool _pendingScanAllAfterResume = false;

  /// macOS/Android：监听「用本应用打开」推送的路径或 content URI，需在 dispose 中取消
  StreamSubscription<dynamic>? _openFileEventSubscription;

  /// 当前索引到的所有文件
  final List<ReaderFile> _allFiles = [];

  /// 文件列表按文件名搜索关键词（空表示不筛选，显示全部）
  String _fileSearchQuery = '';
  late final TextEditingController _searchController;

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
    _searchController = TextEditingController(text: _fileSearchQuery);
    _searchController.addListener(_onSearchControllerChanged);
    WidgetsBinding.instance.addObserver(this);
    _loadPersistentState();
    if (Platform.isMacOS || Platform.isAndroid) {
      _openFileEventSubscription = _openFileEventChannel
          .receiveBroadcastStream()
          .listen(_onOpenFileEvent, onError: (_) {});
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openInitialFileIfAny();
      if (Platform.isAndroid) _runBackgroundScanIfGranted();
    });
  }

  void _onSearchControllerChanged() {
    if (mounted && _searchController.text != _fileSearchQuery) {
      setState(() => _fileSearchQuery = _searchController.text);
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchControllerChanged);
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _openFileEventSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !_pendingScanAllAfterResume) return;
    _pendingScanAllAfterResume = false;
    if (!Platform.isAndroid || !mounted) return;
    _checkHasAllFilesAccess().then((granted) {
      if (!mounted) return;
      if (granted) {
        _scanAllFiles();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.scanAllFilesPermissionDenied)),
        );
      }
    });
  }

  /// macOS/Android 原生在「用本应用打开」时推送路径或 content URI 时调用
  void _onOpenFileEvent(dynamic path) {
    if (!mounted || path is! String || path.isEmpty) return;
    final file = ReaderFile.fromPath(path);
    if (file.type == FileType.other) return;
    _onTapFile(file);
  }

  /// 若由“用本应用打开”启动，则获取传入的文件并打开预览
  Future<void> _openInitialFileIfAny() async {
    if (!mounted) return;
    try {
      // Android：在 onCreate 中已保存 intent，稍作延迟后取一次，必要时再重试一次
      if (Platform.isAndroid) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      if (!mounted) return;
      String? uri = await _androidChannel.invokeMethod<String>('getInitialFileUri');
      // macOS：除 EventChannel 推送外，再轮询 getInitialFileUri 作为后备（系统可能先于监听交付）
      // iOS：系统可能在窗口显示后才交付文件，需多次延迟重试
      if ((uri == null || uri.isEmpty) && mounted && (Platform.isMacOS || Platform.isIOS)) {
        final delays = Platform.isMacOS ? [100, 200, 400, 800, 1600] : [100, 200, 400];
        for (final delay in delays) {
          await Future<void>.delayed(Duration(milliseconds: delay));
          if (!mounted) return;
          uri = await _androidChannel.invokeMethod<String>('getInitialFileUri');
          if (uri != null && uri.isNotEmpty) break;
        }
      } else if ((uri == null || uri.isEmpty) && Platform.isAndroid && mounted) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        if (!mounted) return;
        uri = await _androidChannel.invokeMethod<String>('getInitialFileUri');
      }
      if (uri == null || uri.isEmpty || !mounted) return;
      final file = ReaderFile.fromPath(uri);
      if (file.type == FileType.other) return;
      _onTapFile(file);
    } on PlatformException catch (_) {
      // 非 Android/iOS/macOS 或未实现时忽略
    } catch (_) {}
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
          onFileDeleted: () {
            _removeFromList(file);
          },
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

  /// 从当前列表移除单个项（仅从列表移除，不删磁盘文件）
  void _removeFromList(ReaderFile file) {
    setState(() {
      switch (_currentIndex) {
        case 0:
          _allFiles.removeWhere((f) => f.path == file.path);
          break;
        case 1:
          _recentMap.remove(file.path);
          for (final f in _allFiles) {
            if (f.path == file.path) f.lastOpenedAt = null;
          }
          break;
        case 2:
          _bookmarkPaths.remove(file.path);
          for (final f in _allFiles) {
            if (f.path == file.path) f.isBookmarked = false;
          }
          break;
      }
    });
    _savePersistentState();
  }

  /// 从当前列表批量移除（仅从列表移除，不删磁盘文件）
  void _removePathsFromList(List<String> paths) {
    setState(() {
      switch (_currentIndex) {
        case 0:
          _allFiles.removeWhere((f) => paths.contains(f.path));
          break;
        case 1:
          for (final path in paths) {
            _recentMap.remove(path);
            for (final f in _allFiles) {
              if (f.path == path) f.lastOpenedAt = null;
            }
          }
          break;
        case 2:
          for (final path in paths) {
            _bookmarkPaths.remove(path);
            for (final f in _allFiles) {
              if (f.path == path) f.isBookmarked = false;
            }
          }
          break;
      }
      _selectedPaths.clear();
      _selectionMode = false;
    });
    _savePersistentState();
  }

  Future<bool> _checkHasAllFilesAccess() async {
    if (!Platform.isAndroid) return false;
    try {
      final value = await _androidChannel.invokeMethod<bool>('hasAllFilesAccess');
      return value == true;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// 已授权时执行全盘扫描并增量合并：新文件加入列表，不存在的路径从列表移除
  Future<void> _scanAllFiles() async {
    if (!Platform.isAndroid) return;
    setState(() => _isScanning = true);
    try {
      final raw = await _androidChannel.invokeMethod<List<dynamic>>('listAllFilesFromStorage');
      if (raw == null || !mounted) {
        setState(() => _isScanning = false);
        return;
      }
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
      final existingByPath = {for (final f in _allFiles) f.path: f};
      final merged = <ReaderFile>[];
      for (final f in found) {
        final existing = existingByPath[f.path];
        if (existing != null) {
          existing.lastOpenedAt = _recentMap[f.path];
          existing.isBookmarked = _bookmarkPaths.contains(f.path);
          merged.add(existing);
        } else {
          f.lastOpenedAt = _recentMap[f.path];
          f.isBookmarked = _bookmarkPaths.contains(f.path);
          merged.add(f);
        }
      }
      if (mounted) {
        setState(() {
          _allFiles
            ..clear()
            ..addAll(merged);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.scanIndexedCount(merged.length))),
        );
        await _savePersistentState();
      }
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? AppLocalizations.of(context)!.scanFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  /// 若已获得全盘权限，后台执行一次增量扫描（新文件加入，已删除的从列表移除）
  Future<void> _runBackgroundScanIfGranted() async {
    if (!Platform.isAndroid || _isScanning) return;
    final granted = await _checkHasAllFilesAccess();
    if (!granted || !mounted) return;
    _scanAllFiles();
  }

  /// 所有文件页「扫描全部」：有权限则直接扫；无权限则请求，授权成功后扫，失败则提示
  Future<void> _onScanAllFilesTap() async {
    if (!Platform.isAndroid) return;
    final granted = await _checkHasAllFilesAccess();
    if (granted) {
      _scanAllFiles();
      return;
    }
    try {
      await _androidChannel.invokeMethod<void>('requestAllFilesAccess');
      _pendingScanAllAfterResume = true;
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.scanAllFilesPermissionDenied} ${e.message ?? ''}')),
        );
      }
    }
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
    if (_searchController.text != _fileSearchQuery) {
      _searchController.text = _fileSearchQuery;
    }
    final l = AppLocalizations.of(context)!;

    Widget body;
    String title;

    switch (_currentIndex) {
      case 0:
        title = l.tabAllFiles;
        body = FileListView(
          title: l.sectionTitleAllFiles,
          files: _applyFilter(_allFiles),
          searchController: _searchController,
          searchQuery: _fileSearchQuery,
          onSearchQueryChanged: (q) => setState(() => _fileSearchQuery = q),
          currentFilter: _filterType,
          onChangeFilter: _onChangeFilter,
          onTapFile: _onTapFile,
          selectionMode: _selectionMode,
          selectedPaths: _selectedPaths,
          onToggleSelect: (file) {
            setState(() {
              if (_selectedPaths.contains(file.path)) {
                _selectedPaths.remove(file.path);
              } else {
                _selectedPaths.add(file.path);
              }
            });
          },
          onSelectAll: () {
            setState(() {
              _selectedPaths.addAll(_applyFilter(_allFiles).map((f) => f.path));
            });
          },
          onDeselectAll: () {
            setState(() => _selectedPaths.clear());
          },
          onClearSelection: () {
            setState(() {
              _selectionMode = false;
              _selectedPaths.clear();
            });
          },
          onRemoveFromList: (file) {
            _removeFromList(file);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l.removedFromList)),
              );
            }
          },
        );
        break;
      case 1:
        title = l.tabRecent;
        body = FileListView(
          title: l.sectionTitleRecent,
          files: _applyFilter(_recentFiles),
          searchController: _searchController,
          searchQuery: _fileSearchQuery,
          onSearchQueryChanged: (q) => setState(() => _fileSearchQuery = q),
          currentFilter: _filterType,
          onChangeFilter: _onChangeFilter,
          onTapFile: _onTapFile,
          selectionMode: _selectionMode,
          selectedPaths: _selectedPaths,
          onToggleSelect: (file) {
            setState(() {
              if (_selectedPaths.contains(file.path)) {
                _selectedPaths.remove(file.path);
              } else {
                _selectedPaths.add(file.path);
              }
            });
          },
          onSelectAll: () {
            setState(() {
              _selectedPaths.addAll(_applyFilter(_recentFiles).map((f) => f.path));
            });
          },
          onDeselectAll: () {
            setState(() => _selectedPaths.clear());
          },
          onClearSelection: () {
            setState(() {
              _selectionMode = false;
              _selectedPaths.clear();
            });
          },
          onRemoveFromList: (file) {
            _removeFromList(file);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l.removedFromList)),
              );
            }
          },
        );
        break;
      case 2:
        title = l.tabBookmarks;
        body = FileListView(
          title: l.sectionTitleBookmarks,
          files: _applyFilter(_bookmarkedFiles),
          searchController: _searchController,
          searchQuery: _fileSearchQuery,
          onSearchQueryChanged: (q) => setState(() => _fileSearchQuery = q),
          currentFilter: _filterType,
          onChangeFilter: _onChangeFilter,
          onTapFile: _onTapFile,
          emptyPlaceholder: Text(l.bookmark),
          selectionMode: _selectionMode,
          selectedPaths: _selectedPaths,
          onToggleSelect: (file) {
            setState(() {
              if (_selectedPaths.contains(file.path)) {
                _selectedPaths.remove(file.path);
              } else {
                _selectedPaths.add(file.path);
              }
            });
          },
          onSelectAll: () {
            setState(() {
              _selectedPaths.addAll(_applyFilter(_bookmarkedFiles).map((f) => f.path));
            });
          },
          onDeselectAll: () {
            setState(() => _selectedPaths.clear());
          },
          onClearSelection: () {
            setState(() {
              _selectionMode = false;
              _selectedPaths.clear();
            });
          },
          onRemoveFromList: (file) {
            _removeFromList(file);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l.removedFromList)),
              );
            }
          },
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

    final isFileListTab = _currentIndex <= 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          if (isFileListTab && _selectionMode) ...[
            TextButton(
              onPressed: () {
                setState(() {
                  _selectionMode = false;
                  _selectedPaths.clear();
                });
              },
              child: Text(l.cancelSelect),
            ),
            TextButton(
              onPressed: _selectedPaths.isEmpty
                  ? null
                  : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(l.batchRemoveFromList),
                          content: Text(l.batchRemoveConfirm(_selectedPaths.length)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: Text(l.cancelSelect),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: Text(l.batchRemoveFromList),
                            ),
                          ],
                        ),
                      );
                      if (ok == true && mounted) {
                        _removePathsFromList(_selectedPaths.toList());
                        messenger.showSnackBar(
                          SnackBar(content: Text(l.removedFromList)),
                        );
                      }
                    },
              child: Text('${l.batchRemoveFromList}(${_selectedPaths.length})'),
            ),
          ] else if (isFileListTab) ...[
            IconButton(
              tooltip: l.select,
              icon: const Icon(Icons.checklist),
              onPressed: () {
                setState(() => _selectionMode = true);
              },
            ),
            if (Platform.isAndroid && _currentIndex == 0)
              IconButton(
                tooltip: l.scanAllFilesTooltip,
                icon: const Icon(Icons.search),
                onPressed: _isScanning ? null : _onScanAllFilesTap,
              ),
            IconButton(
              tooltip: l.scanTooltip,
              icon: const Icon(Icons.folder_open),
              onPressed: _isScanning ? null : _scanFiles,
            ),
          ] else if (_currentIndex != 3)
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
    this.searchController,
    this.searchQuery,
    this.onSearchQueryChanged,
    required this.currentFilter,
    required this.onChangeFilter,
    required this.onTapFile,
    this.emptyPlaceholder,
    this.selectionMode = false,
    this.selectedPaths = const {},
    this.onToggleSelect,
    this.onSelectAll,
    this.onDeselectAll,
    this.onClearSelection,
    this.onRemoveFromList,
  });

  final String title;
  final List<ReaderFile> files;
  /// 与 searchQuery 同步的输入框控制器（由首页持有并在清空时同步）
  final TextEditingController? searchController;
  /// 当前搜索关键词，用于清空按钮与筛选逻辑
  final String? searchQuery;
  final ValueChanged<String>? onSearchQueryChanged;
  final FileType? currentFilter;
  final void Function(FileType? type) onChangeFilter;
  final void Function(ReaderFile file) onTapFile;
  final Widget? emptyPlaceholder;
  final bool selectionMode;
  final Set<String> selectedPaths;
  final void Function(ReaderFile file)? onToggleSelect;
  final VoidCallback? onSelectAll;
  final VoidCallback? onDeselectAll;
  final VoidCallback? onClearSelection;
  final void Function(ReaderFile file)? onRemoveFromList;

  /// 按文件名关键词筛选；query 为空则返回原列表
  static List<ReaderFile> _applySearchByName(List<ReaderFile> files, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return files;
    return files.where((f) => f.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final query = searchQuery ?? '';
    final filteredFiles = _applySearchByName(files, query);

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
        if (searchController != null && onSearchQueryChanged != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              controller: searchController,
              onChanged: onSearchQueryChanged,
              decoration: InputDecoration(
                hintText: l.searchFilesHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => onSearchQueryChanged?.call(''),
                      ),
                isDense: true,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
        if (selectionMode && filteredFiles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: Text(l.selectAll),
                  onSelected: (_) => onSelectAll?.call(),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l.deselectAll),
                  onSelected: (_) => onDeselectAll?.call(),
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
                    final selected = selectedPaths.contains(file.path);
                    return ListTile(
                      leading: selectionMode
                          ? Checkbox(
                              value: selected,
                              onChanged: (_) => onToggleSelect?.call(file),
                            )
                          : Icon(_iconForType(file.type)),
                      title: Text(file.name),
                      subtitle: Text(
                        _subtitleForFile(context, file),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: selectionMode
                          ? null
                          : Icon(
                              file.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: file.isBookmarked
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                      onTap: () {
                        if (selectionMode) {
                          onToggleSelect?.call(file);
                        } else {
                          onTapFile(file);
                        }
                      },
                      onLongPress: selectionMode
                          ? null
                          : (onRemoveFromList != null
                              ? () {
                                  final removeCb = onRemoveFromList!;
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (ctx) => SafeArea(
                                      child: ListTile(
                                        leading: const Icon(Icons.remove_circle_outline),
                                        title: Text(l.removeFromList),
                                        onTap: () {
                                          Navigator.of(ctx).pop();
                                          removeCb(file);
                                        },
                                      ),
                                    ),
                                  );
                                }
                              : null),
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


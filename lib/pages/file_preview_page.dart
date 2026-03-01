import 'dart:io';

import 'package:docx_file_viewer/docx_file_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';
import 'package:pdf_reader/l10n/app_localizations.dart';

import '../models/reader_file.dart';

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
    final l = AppLocalizations.of(context)!;
    final file = widget.file;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop(file.isBookmarked);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(file.name),
          actions: [
            IconButton(
              tooltip: l.bookmark,
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
            tooltip: l.share,
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l.shareTodo)),
              );
            },
          ),
          IconButton(
            tooltip: l.more,
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showMoreActions(context, file);
            },
          ),
        ],
      ),
        body: _buildPreviewBody(file),
      ),
    );
  }

  Widget _buildPreviewBody(ReaderFile file) {
    return FutureBuilder<String>(
      future: _resolvedPathFuture,
      builder: (context, snapshot) {
        final l = AppLocalizations.of(context)!;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('${l.loadFailed}：${snapshot.error}'),
          );
        }
        final path = snapshot.data;
        if (path == null || path.isEmpty) {
          return Center(child: Text(l.cannotResolvePath));
        }
        return _buildPreviewWithPath(context, file, path);
      },
    );
  }

  Widget _buildPreviewWithPath(
      BuildContext context, ReaderFile file, String path) {
    final l = AppLocalizations.of(context)!;
    switch (file.type) {
      case FileType.pdf:
        return PdfViewer.file(path);
      case FileType.epub:
        return _EpubPreviewWidget(path: path);
      case FileType.markdown:
        return FutureBuilder<String>(
          future: File(path).readAsString(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('${l.loadMarkdownFailed}：${snapshot.error}'),
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
                child: Text('${l.loadTextFailed}：${snapshot.error}'),
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
              l.previewUnsupportedDoc,
              textAlign: TextAlign.center,
            ),
          ),
        );
      case FileType.other:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${l.previewUnsupportedFile}${file.path}',
              textAlign: TextAlign.center,
            ),
          ),
        );
    }
  }

  void _showMoreActions(BuildContext context, ReaderFile file) {
    final l = AppLocalizations.of(context)!;
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
                title: Text(l.moreOpenWithOther),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l.moreOpenWithOtherTodo)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(l.moreExportConvert),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l.moreExportConvertTodo)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(l.moreDelete),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l.moreDeleteTodo)),
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

/// 内嵌 EPUB 阅读器，使用 [flutter_epub_viewer]
class _EpubPreviewWidget extends StatefulWidget {
  const _EpubPreviewWidget({required this.path});

  final String path;

  @override
  State<_EpubPreviewWidget> createState() => _EpubPreviewWidgetState();
}

class _EpubPreviewWidgetState extends State<_EpubPreviewWidget> {
  final EpubController _epubController = EpubController();
  bool _isLoading = true;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final epubTheme = isDark ? EpubTheme.dark() : EpubTheme.light();

    return SafeArea(
      child: Column(
        children: [
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.transparent,
          ),
          Expanded(
            child: Stack(
              children: [
                EpubViewer(
                  epubSource: EpubSource.fromFile(File(widget.path)),
                  epubController: _epubController,
                  displaySettings: EpubDisplaySettings(
                    flow: EpubFlow.paginated,
                    useSnapAnimationAndroid: false,
                    snap: true,
                    theme: epubTheme,
                    allowScriptedContent: true,
                  ),
                  onChaptersLoaded: (_) {
                    if (mounted) setState(() => _isLoading = false);
                  },
                  onEpubLoaded: () {},
                  onRelocated: (value) {
                    if (mounted) setState(() => _progress = value.progress);
                  },
                ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


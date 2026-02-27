import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

/// 内置 HTTP 服务，用于托管 pdfcraft 静态页面（PDFCraft 工具站）。
class PdfCraftServer {
  PdfCraftServer._();

  static HttpServer? _server;
  static bool _started = false;
  static String? _assetsDirPath;

  /// 服务端口
  static const int port = 28765;

  /// 本地访问根地址，用于 InAppWebView 加载
  static String get baseUrl => 'http://127.0.0.1:$port/';

  /// 确保服务已启动。首次调用会启动 shelf 并托管 pdfcraft 资源。
  ///
  /// 由于 Flutter 资源打包在 APK/APP 内部，不能直接作为文件系统目录访问，
  /// 这里会将 pdfcraft 静态站点解压到「应用自己的持久数据目录」，
  /// 并缓存当前应用版本号，下次如果版本匹配则直接复用，无需重复解压。
  static Future<void> ensureStarted() async {
    if (_started) return;
    _started = true;

    try {
      final assetsDir = await _ensureAssetsExtracted();

      final handler = const Pipeline()
          .addMiddleware(logRequests())
          .addHandler(
            createStaticHandler(
              assetsDir,
              defaultDocument: 'index.html',
              listDirectories: false,
            ),
          );

      _server = await shelf_io.serve(
        handler,
        InternetAddress.loopbackIPv4,
        port,
      );
      debugPrint('PdfCraftServer listening on $baseUrl (assets from $assetsDir)');
    } catch (e, st) {
      _started = false;
      debugPrint('PdfCraftServer start error: $e\n$st');
      rethrow;
    }
  }

  /// 将 Flutter 资源包中的 pdfcraft 静态站点解压到应用持久目录，并返回该目录路径。
  ///
  /// - 优先从一个打包好的 `assets/web/pdfcraft/pdfcraft.zip` 解压（参考 h5p 的 zip 方案）；
  /// - 如果 zip 不存在，则回退到遍历 `assets/pdfcraft/` 目录的老方案；
  /// - 解压目标目录位于 `getApplicationSupportDirectory()/pdfcraft/content`；
  /// - 同时在 `getApplicationSupportDirectory()/pdfcraft/version.txt` 中记录当前应用版本；
  /// - 下次如果版本号一致且 content 目录存在，则直接复用，不再解压。
  static Future<String> _ensureAssetsExtracted() async {
    if (_assetsDirPath != null) return _assetsDirPath!;

    // 0. 计算应用持久目录 & 当前版本号
    final supportDir = await getApplicationSupportDirectory();
    final rootDir = Directory(p.join(supportDir.path, 'pdfcraft'));
    final contentDir = Directory(p.join(rootDir.path, 'content'));
    final versionFile = File(p.join(rootDir.path, 'version.txt'));
    await rootDir.create(recursive: true);

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = '${packageInfo.version}+${packageInfo.buildNumber}';

    String? storedVersion;
    if (await versionFile.exists()) {
      storedVersion = (await versionFile.readAsString()).trim();
    }

    // 如果版本号一致且内容目录存在，则直接复用
    if (storedVersion == currentVersion && await contentDir.exists()) {
      _assetsDirPath = contentDir.path;
      debugPrint(
        'PdfCraftServer: reuse extracted assets at ${_assetsDirPath!} for version $currentVersion',
      );
      return _assetsDirPath!;
    }

    // 如需重新解压，则先清理旧内容
    if (await contentDir.exists()) {
      try {
        await contentDir.delete(recursive: true);
      } catch (_) {}
    }
    await contentDir.create(recursive: true);

    // 1. 首选：从单一的 pdfcraft.zip 解压到持久 content 目录
    const zipAssetPath = 'assets/web/pdfcraft/pdfcraft.zip';
    try {
      final data = await rootBundle.load(zipAssetPath);
      final buffer = data.buffer;
      final bytes =
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      final archive = ZipDecoder().decodeBytes(bytes);

      for (final file in archive) {
        final filename = p.join(contentDir.path, file.name);
        if (file.isFile) {
          final outFile = File(filename);
          await outFile.parent.create(recursive: true);
          await outFile.writeAsBytes(
            (file.content as List<int>),
            flush: true,
          );
        } else {
          await Directory(filename).create(recursive: true);
        }
      }

      _assetsDirPath = contentDir.path;
      debugPrint(
        'PdfCraftServer: extracted pdfcraft.zip to ${_assetsDirPath!} for version $currentVersion',
      );
      await versionFile.writeAsString(currentVersion, flush: true);
      return _assetsDirPath!;
    } catch (e, st) {
      // zip 不存在或解压失败时，打印日志并回退到旧实现
      debugPrint(
        'PdfCraftServer: failed to load $zipAssetPath, '
        'fallback to assets/pdfcraft/. Error: $e\n$st',
      );
    }

    // 2. 回退方案：从 AssetManifest 中找到所有 `assets/pdfcraft/` 开头的资源逐个写到持久 content 目录
    const prefix = 'assets/pdfcraft/';
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifest =
        json.decode(manifestJson) as Map<String, dynamic>;

    final assetPaths = manifest.keys
        .where((key) => key is String && key.startsWith(prefix))
        .cast<String>()
        .toList();

    // 如果没有任何静态资源，则不要抛异常，生成一个简单的占位页面即可，避免整个功能崩溃。
    if (assetPaths.isEmpty) {
      final file = File(p.join(contentDir.path, 'index.html'));
      await file.create(recursive: true);
      await file.writeAsString(
        '''
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>PDFCraft</title>
  </head>
  <body>
    <h1>PDFCraft 资源未就绪</h1>
    <p>未找到 <code>$zipAssetPath</code> 或 <code>$prefix*</code> 资源。</p>
  </body>
</html>
''',
        flush: true,
      );
      _assetsDirPath = contentDir.path;
      debugPrint(
        'PdfCraftServer: no pdfcraft assets found, using placeholder page at ${_assetsDirPath!}',
      );
      await versionFile.writeAsString(currentVersion, flush: true);
      return _assetsDirPath!;
    }

    for (final assetPath in assetPaths) {
      final data = await rootBundle.load(assetPath);
      final buffer = data.buffer;
      final bytes =
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      final relativePath = assetPath.substring(prefix.length);
      final file = File(p.join(contentDir.path, relativePath));
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);
    }

    _assetsDirPath = contentDir.path;
    await versionFile.writeAsString(currentVersion, flush: true);
    return _assetsDirPath!;
  }
}

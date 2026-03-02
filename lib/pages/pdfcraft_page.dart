import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pdf_reader/l10n/app_localizations.dart';
import 'package:pdf_reader/services/pdfcraft_server.dart';
import 'package:url_launcher/url_launcher.dart';

/// PDFCraft 工具页：使用内置 HTTP 服务托管静态资源，通过 InAppWebView 打开。
/// 若本地尚未解压/未就绪，先打开远程 https://pdfcraft.devtoolcafe.com/ ，就绪后自动切换到本地页面。
class PdfCraftPage extends StatefulWidget {
  const PdfCraftPage({super.key});

  @override
  State<PdfCraftPage> createState() => _PdfCraftPageState();
}

class _PdfCraftPageState extends State<PdfCraftPage> {
  InAppWebViewController? _webViewController;
  bool _useLocalServer = PdfCraftServer.isReady;
  bool _updating = false;
  double _updateProgress = 0.0;

  @override
  void initState() {
    super.initState();
    if (!PdfCraftServer.isReady) {
      PdfCraftServer.ensureStarted().then((_) {
        // 仅当本地服务真正启动成功时再切换到本地（Android Release 可能无法绑定端口）
        if (mounted && !_useLocalServer && PdfCraftServer.isReady) {
          setState(() => _useLocalServer = true);
          _webViewController?.loadUrl(
            urlRequest: URLRequest(url: WebUri(PdfCraftServer.baseUrl)),
          );
        }
      });
    }
  }

  String get _initialUrl =>
      PdfCraftServer.isReady ? PdfCraftServer.baseUrl : PdfCraftServer.remoteUrl;

  Future<void> _updateToLatestWeb() async {
    if (_updating) return;
    setState(() {
      _updating = true;
      _updateProgress = 0.0;
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Text('正在从 GitHub 下载最新版 PDFCraft 网页…'),
        duration: Duration(seconds: 3),
      ),
    );

    try {
      await PdfCraftServer.updateFromLatestRelease(
        onProgress: (progress) {
          if (!mounted) return;
          setState(() {
            _updateProgress = progress.clamp(0.0, 1.0);
          });
        },
      );

      // 确保本地服务已就绪（如果之前尚未启动的话）
      if (!PdfCraftServer.isReady) {
        await PdfCraftServer.ensureStarted();
      }

      if (!mounted) return;

      setState(() {
        _useLocalServer = PdfCraftServer.isReady;
      });

      if (PdfCraftServer.isReady) {
        _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(PdfCraftServer.baseUrl)),
        );
      }

      messenger.showSnackBar(
        const SnackBar(
          content: Text('PDFCraft 网页已更新到最新版。'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('更新 PDFCraft 网页失败：$e'),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _updating = false;
          _updateProgress = 0.0;
        });
      } else {
        _updating = false;
      }
    }
  }

  Future<void> _openInSystemBrowser() async {
    final url = await _webViewController?.getUrl();
    if (url == null || url.toString().isEmpty) return;
    final uri = Uri.tryParse(url.toString());
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDFCraft'),
        actions: [
          IconButton(
            icon: const Icon(Icons.system_update),
            tooltip: '更新网页到最新版',
            onPressed: _updating ? null : _updateToLatestWeb,
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            tooltip: AppLocalizations.of(context)!.openInSystemBrowser,
            onPressed: () => _openInSystemBrowser(),
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(_initialUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              domStorageEnabled: true,
              useWideViewPort: true,
              loadWithOverviewMode: true,
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
          ),
          if (_updating)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    width: 260,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          '正在更新 PDFCraft 网页',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: _updateProgress > 0 ? _updateProgress : null,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _updateProgress > 0
                              ? '已完成 ${(_updateProgress * 100).toStringAsFixed(0)}%'
                              : '正在从 GitHub 下载和解压…',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

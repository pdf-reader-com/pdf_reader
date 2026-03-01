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

  @override
  void initState() {
    super.initState();
    if (!PdfCraftServer.isReady) {
      PdfCraftServer.ensureStarted().then((_) {
        if (mounted && !_useLocalServer) {
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
            icon: const Icon(Icons.open_in_browser),
            tooltip: AppLocalizations.of(context)!.openInSystemBrowser,
            onPressed: () => _openInSystemBrowser(),
          ),
        ],
      ),
      body: InAppWebView(
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
    );
  }
}

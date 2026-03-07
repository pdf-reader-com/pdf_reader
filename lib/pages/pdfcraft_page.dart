import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pdf_reader/l10n/app_localizations.dart';
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

  String get _initialUrl =>
      'https://pdfcraft.devtoolcafe.com/';

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
        ],
      ),
    );
  }
}

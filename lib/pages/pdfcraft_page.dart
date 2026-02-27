import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pdf_reader/services/pdfcraft_server.dart';

/// PDFCraft 工具页：使用内置 HTTP 服务托管静态资源，通过 InAppWebView 打开。
class PdfCraftPage extends StatelessWidget {
  const PdfCraftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDFCraft'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(PdfCraftServer.baseUrl),
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          domStorageEnabled: true,
          useWideViewPort: true,
          loadWithOverviewMode: true,
        ),
      ),
    );
  }
}

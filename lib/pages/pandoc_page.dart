import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pdf_reader/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class PandocPage extends StatefulWidget {
  const PandocPage({super.key});

  @override
  State<PandocPage> createState() => _PandocPageState();
}

class _PandocPageState extends State<PandocPage> {
  static const String _pandocUrl = 'https://pandoc.org/app/';
  InAppWebViewController? _webViewController;

  Future<void> _openInSystemBrowser() async {
    // 优先使用当前 WebView URL，若获取失败则回退到默认地址。
    String? currentUrl;
    try {
      final url = await _webViewController?.getUrl();
      currentUrl = url?.toString();
    } catch (_) {
      currentUrl = null;
    }

    final uri = Uri.tryParse(
      (currentUrl != null && currentUrl.isNotEmpty) ? currentUrl : _pandocUrl,
    );
    if (uri == null) return;

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pandoc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            tooltip: l.openInSystemBrowser,
            onPressed: _openInSystemBrowser,
          ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(_pandocUrl)),
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


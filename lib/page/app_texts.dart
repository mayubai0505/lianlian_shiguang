// lib/app_texts.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

enum LegalPageType {
  privacy,
  terms,
  creator,
}

class LegalDocumentPage extends StatefulWidget {
  final LegalPageType type;

  const LegalDocumentPage({
    super.key,
    required this.type,
  });

  @override
  State<LegalDocumentPage> createState() =>
      _LegalDocumentPageState();
}

class _LegalDocumentPageState
    extends State<LegalDocumentPage> {
  late final WebViewController _controller;

  bool _isLoading = true;

  bool _hasError = false;

  String get _pageTitle {
    final l10n = AppLocalizations.of(context);

    switch (widget.type) {
      case LegalPageType.privacy:
        return l10n?.privacyPolicy ?? '隱私權政策';

      case LegalPageType.terms:
        return l10n?.termsOfService ?? '使用條款';

      case LegalPageType.creator:
        return l10n?.legal_creator_guidelines ?? '創作者規範';
    }
  }

  String get _url {
    switch (widget.type) {
      case LegalPageType.privacy:
        return "https://adaptable-roof-829.notion.site/3ab919a541518035ad5ec56427a427ec";

      case LegalPageType.terms:
        return "https://adaptable-roof-829.notion.site/3ab919a5415180e89545dce77d552a6c";

      case LegalPageType.creator:
        return "https://adaptable-roof-829.notion.site/3ab919a541518004990ec5ad79b80129";
    }
  }

  @override
  void initState() {
    super.initState();

    // Flutter Web does not provide a webview_flutter WebViewController.
    // Only initialize native WebView on supported mobile platforms.
    if (kIsWeb) return;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (!mounted) return;

            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (url) {
            if (!mounted) return;

            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame != true) return;

            if (!mounted) return;

            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(_url));
  }

  // Notion blocks many embedded-frame scenarios; open its original URL in
  // a browser tab on Flutter Web rather than attempting to embed a WebView.
  Future<void> _openWebDocument() async {
    try {
      final opened = await launchUrl(
        Uri.parse(_url),
        webOnlyWindowName: '_blank',
      );
      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.legal_page_load_failed)),
        );
      }
    } catch (error) {
      debugPrint('開啟法律文件網頁失敗：$error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.legal_page_load_failed)),
        );
      }
    }
  }

  Widget _buildWebLegalPage(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final isChinese = locale == 'zh';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitle,
          style: GoogleFonts.notoSerifTc(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.description_outlined, size: 56, color: theme.colorScheme.primary),
                const SizedBox(height: 18),
                Text(
                  _pageTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isChinese
                      ? '網頁版將在新分頁開啟正式文件，方便完整閱讀。'
                      : 'Open the official document in a new browser tab.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 14,
                    height: 1.6,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _openWebDocument,
                  icon: const Icon(Icons.open_in_new),
                  label: Text(isChinese ? '開啟正式文件' : 'Open document'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return _buildWebLegalPage(context);

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitle,
          style: GoogleFonts.notoSerifTc(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.legal_refresh,
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_hasError)
            WebViewWidget(
              controller: _controller,
            ),

          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 70,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.legal_page_load_failed,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.legal_check_connection_retry,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _isLoading = true;
                        });

                        _controller.loadRequest(
                          Uri.parse(_url),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        l10n.legal_reload,
                        style: GoogleFonts.notoSerifTc(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
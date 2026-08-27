// lib/app_texts.dart
import 'package:flutter/material.dart';
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
        return '創作者規範';
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

  @override
  Widget build(BuildContext context) {
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
            tooltip: "重新整理",
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
                      "頁面載入失敗",
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "請確認網路連線後再試一次。",
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
                        "重新載入",
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
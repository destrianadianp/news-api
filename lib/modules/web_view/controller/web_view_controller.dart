import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/styles/app_colors.dart';

class NewsWebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const NewsWebViewPage({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<NewsWebViewPage> createState() => _NewsWebViewPageState();
}

class _NewsWebViewPageState extends State<NewsWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _progress = 0;
  String? _error;

  @override
  void initState() {
    super.initState();

    // Check if URL is valid before initializing the WebView
    if (widget.url.isNotEmpty) {
      // Inisialisasi Controller secara lengkap agar tidak error
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
                _error = null; // Clear any previous error
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              setState(() {
                _isLoading = false;
                _error = 'Gagal memuat halaman: ${error.description}';
              });
              debugPrint("WebView Error: ${error.description}");
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    } else {
      _error = 'URL tidak valid';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Using WillPopScope for backward compatibility until newer Flutter versions are adopted
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Check if WebView can go back to a previous page within the WebView
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false; // Don't pop the route since we navigated back in WebView
        } else {
          // If WebView can't go back, then we return to the previous screen (Detail Artikel)
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(fontSize: 16),
          ),
          // Menambahkan tombol refresh di AppBar
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                if (widget.url.isNotEmpty && _error == null) {
                  _controller.reload();
                }
              },
            ),
          ],
        ),
        body: _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Widget utama WebView
                widget.url.isNotEmpty
                  ? WebViewWidget(controller: _controller)
                  : const Center(
                      child: Text('URL tidak valid'),
                    ),

                // Linear Progress Bar agar lebih modern daripada Loading Spinner
                if (_isLoading)
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.white,
                    color: AppColors.primary,
                  ),

                // Jika loading benar-benar di awal dan progress masih 0
                if (_isLoading && _progress == 0)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
      ),
    );
  }
}
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
    _initializeWebView();
  }

  void _initializeWebView() {
    // Initialize web view controller with common configurations
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(_createNavigationDelegate())
      ..loadRequest(Uri.parse(widget.url));
  }

  NavigationDelegate _createNavigationDelegate() {
    return NavigationDelegate(
      onProgress: (int progress) {
        setState(() {
          _progress = progress / 100;
        });
      },
      onPageStarted: (String url) {
        setState(() {
          _isLoading = true;
          _error = null;
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
          _error = _getUserFriendlyErrorMessage(error);
        });
        debugPrint("WebView Error: ${error.description}");
      },
    );
  }

  String _getUserFriendlyErrorMessage(WebResourceError error) {
    // Provide general user-friendly error messages
    String desc = error.description.toLowerCase();

    if (desc.contains('timeout')) {
      return 'Waktu koneksi habis. Coba lagi nanti.';
    } else if (desc.contains('dns') || desc.contains('host') || desc.contains('lookup')) {
      return 'Alamat situs tidak ditemukan. Artikel mungkin sudah tidak tersedia.';
    } else if (desc.contains('connection') || desc.contains('connect')) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    } else {
      return 'Alamat situs tidak dapat diakses. Artikel mungkin sudah tidak tersedia.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  Future<bool> _handleWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        widget.title,
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _error != null ? null : _refreshPage,
        ),
      ],
    );
  }

  void _refreshPage() {
    if (widget.url.isNotEmpty && _error == null) {
      _controller.reload();
    }
  }

  Widget _buildBody() {
    if (_error != null) {
      return _buildErrorView();
    }

    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading) ...[
          // Show linear progress indicator during loading
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[200],
              color: AppColors.primary,
            ),
          ),
          // Show circular progress when progress is at 0
          if (_progress <= 0)
            const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Gagal Memuat Halaman',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Terjadi kesalahan saat memuat halaman',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Kembali'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _refreshPage,
              child: const Text('Coba Muat Ulang'),
            ),
          ],
        ),
      ),
    );
  }
}
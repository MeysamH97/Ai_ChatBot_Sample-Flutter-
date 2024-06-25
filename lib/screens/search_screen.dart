import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleSearchPage extends StatefulWidget {
  final String searchQuery;

  const GoogleSearchPage({super.key, required this.searchQuery});

  @override
  _GoogleSearchPageState createState() => _GoogleSearchPageState();
}

class _GoogleSearchPageState extends State<GoogleSearchPage> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.google.com/search?q=${widget.searchQuery}'));

    // Note: If you encounter any issues related to WebView not loading properly,
    // make sure to add the necessary permissions and configurations in your Android
    // and iOS projects as described in the webview_flutter documentation.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Search Results'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

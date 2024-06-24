import 'package:flutter/material.dart';
import 'package:tobetoapp/theme/light/light_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IstanbulKodluyor extends StatefulWidget {
  const IstanbulKodluyor({super.key});

  @override
  State<IstanbulKodluyor> createState() => _IstanbulKodluyorState();
}

class _IstanbulKodluyorState extends State<IstanbulKodluyor> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://istanbulkodluyor.com/istanbul-kodluyor'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.tobetoMoru,
        title: const Text(
          "Istanbul Kodluyor",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
import 'package:flutter/material.dart';
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
        title: Image.asset(
          "assets/logo/tobetologo.PNG",
          width: MediaQuery.of(context).size.width * 0.43,
        ),
        centerTitle: true,
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
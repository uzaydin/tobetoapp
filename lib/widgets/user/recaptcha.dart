import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class Recaptcha extends StatefulWidget {
  const Recaptcha({super.key});

  @override
  State<Recaptcha> createState() => _RecaptchaState();
}

class _RecaptchaState extends State<Recaptcha> {
  late WebViewControllerPlus _controler;

  @override
  void initState() {
    _controler = WebViewControllerPlus()
      ..loadFlutterAssetServer('assets/recaptcha/recaptcha.html')
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            _controler.getWebViewHeight().then((value) {
              var height = int.parse(value.toString()).toDouble();
              if (height != _height) {
                if (kDebugMode) {
                  print("Height is: $value");
                }
                setState(() {
                  _height = height;
                });
              }
            });
          },
        ),
      );
    super.initState();
  }

  double _height = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: _controler,
      ),
    );
  }

  @override
  void dispose() {
    _controler.server.close();
    super.dispose();
  }
}

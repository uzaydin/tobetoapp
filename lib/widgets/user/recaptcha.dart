import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Recaptcha extends StatefulWidget {
  final Function(bool) onVerified;

  const Recaptcha({super.key, required this.onVerified});

  @override
  State<Recaptcha> createState() => _RecaptchaState();
}

class _RecaptchaState extends State<Recaptcha> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (UrlChange change) {
            final String url = change.url!;
            if (url.contains('submit')) {
              widget.onVerified(true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Başarılı!')),
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('https://vast-mature-asteroid.glitch.me'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      child: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../cores/components/loaders.dart';
import '../../cores/components/overlay_appbar.dart';
import '../../cores/utils/tools.dart';

class WebviewPage extends StatefulWidget {
  final String title;
  final String url;

  WebviewPage(this.title, this.url);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    print(widget.url);
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(title: widget.title),
      body: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
            onPageFinished: (url) {
              setState(() {
                loading = false;
              });
            },
            navigationDelegate: (navigation) async {
              String url = navigation.url;
              if (url.contains('whatsapp') ||
                  url.contains('tel:') ||
                  url.contains('.pdf')) {
                try {
                  await launchUrlString(url, mode: LaunchMode.externalApplication);
                } catch (e) {
                  Tools.showAlert(
                      context, 'Exception', 'Gagal membuka link', 'error');
                }
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
          Visibility(
            visible: loading,
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: defaultLoader(caption: 'Memuat halaman...'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

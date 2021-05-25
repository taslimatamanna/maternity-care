import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SafePregnancy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe3e3e3),
        title: Text(
          "Safe Pregnancy",
          style: TextStyle(
            color: Colors.pink[900],
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.pink[900],
        ),
      ),
      body: WebView(
        initialUrl: "https://www.verywellfamily.com/pregnancy-your-week-by-week-guide-4159265",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../theme_data.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter/webview_flutter.dart';


class ROCEnrollWebViewer extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ROCEnrollWebViewerState();

}

class _ROCEnrollWebViewerState extends State<ROCEnrollWebViewer> {

  final _webViewController = WebViewController()..loadRequest(
      Uri.parse('https://roc02.staging.rankone.io:8443')
  );

  final _sessionCookie = WebViewCookie(
      name: "My_cookier",
      value: "token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjVmZDJhNjk3YzAwNDAwMDE0N2JhMWE2IiwiaWF0IjoxNzEyMjAzMzk1LCJleHAiOjE3MTIyMDQyOTV9.zx1wO1TYpIBQuTjdD3EQA2g2MABDLJu2kbLj96qa8wE; refreshToken=ed0637e5-f990-4925-b54f-a6378201e702; userAccess=%7B%22role%22%3A%22enrollUser%22%2C%22clientAllowedPages%22%3A%5B%22%2Frocenroll%2F*%22%5D%2C%22serviceRole%22%3Afalse%2C%22_id%22%3A%2265fd18ce57373fd23561fb20%22%2C%22label%22%3A%22Enroll%20User%22%2C%22clientStartPage%22%3A%22%2Frocenroll%2Fhome%22%7D",
      domain: "roc02.staging.rankone.io:8443"
  );

  //var postdata = Uint8List.fromList(utf8.encode())
  late InAppWebViewController _controller;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Face Verification"),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url:  Uri.parse('https://roc02.staging.rankone.io:8443'),

        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            mediaPlaybackRequiresUserGesture: false,
          )
        ),
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        androidOnPermissionRequest: (InAppWebViewController controller, String origin,
            List<String> resources) async {
          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
        },

      ),

    );
  }

}
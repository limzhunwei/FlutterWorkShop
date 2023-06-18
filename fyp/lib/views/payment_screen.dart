import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/constant.dart';
import '../models/user.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final double totalpayable;
  const PaymentScreen({Key? key, required this.user, required this.totalpayable,}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
          title: const Text('Payment'),
        ),
      body: Stack(
        children: <Widget>[
          WebView(
                initialUrl: CONSTANTS.server +
                    "/fyp/php/payment.php?email=" +
                    widget.user.email.toString() +
                    '&mobile=' +
                    widget.user.phone.toString() +
                    '&name=' +
                    widget.user.name.toString() +
                    '&amount=' +
                    widget.totalpayable.toString() ,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (finish) {
                  setState(() {
                    isLoading = false;
                  });
                },
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
          isLoading 
          ? const Center( 
            child: CircularProgressIndicator(),
            )
          : Stack(),
        ],
      ),
    );
  }
}
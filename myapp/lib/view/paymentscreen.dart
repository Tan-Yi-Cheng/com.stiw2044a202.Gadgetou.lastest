import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/model/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final double total;
  const PaymentScreen({Key? key, required this.user, required this.total})
      : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    //int id = User.getId();
    String email = widget.user.email;
    String name = widget.user.name;
    double amount = widget.total;
    return Scaffold(
        appBar: AppBar(
          title: Text('Payment'),
        ),
        body: Center(
            child: Container(
          child: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl:
                      'https://crimsonwebs.com/s270150/Gadgetou/php/generate_bill.php?email=' +
                          "$email" +
                          '&name=' +
                          "$name" +
                          '&amount=' +
                          "$amount",
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              )
            ],
          ),
        )
            //  ,Text(
            //     'You are not allowed to book yourself',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(fontSize: 28),
            //)
            ));
  }
}

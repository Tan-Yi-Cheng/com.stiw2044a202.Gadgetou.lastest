import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:lab3/orderdetailscreen.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/model/user.dart';
import 'package:myapp/model/order.dart';
import 'package:intl/intl.dart';
import 'package:myapp/view/orderdetailscreen.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final User user;

  const PaymentHistoryScreen({Key? key, required this.user}) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List _paymentdata = [];

  String _titlecenter = "Loading payment history...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  late double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Text(
            "Payment History",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (_paymentdata.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(
                child: Container(
                    child: Center(
                        child: Text(
              _titlecenter,
              style: TextStyle(
                  color: Color.fromRGBO(105, 105, 105, 1),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            )))),
          Expanded(
              child: ListView.builder(
                  //Step 6: Count the data
                  itemCount: _paymentdata.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                        child: InkWell(
                            onTap: () => loadOrderDetails(index),
                            child: Card(
                              elevation: 10,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        (index + 1).toString(),
                                        style: TextStyle(color: Colors.black87),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        "RM " + _paymentdata[index]['total'],
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                105, 105, 105, 1)),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _paymentdata[index]['orderid'],
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    105, 105, 105, 1)),
                                          ),
                                          Text(
                                            _paymentdata[index]['billid'],
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    105, 105, 105, 1)),
                                          ),
                                        ],
                                      )),
                                  Expanded(
                                    child: Text(
                                      f.format(DateTime.parse(
                                          _paymentdata[index]['date'])),
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(105, 105, 105, 1)),
                                    ),
                                    flex: 3,
                                  ),
                                ],
                              ),
                            )));
                  }))
        ]),
      ),
    );
  }

  Future<void> _loadPaymentHistory() async {
    if (_paymentdata.isEmpty) {
      _titlecenter = "No Previous Payment";
    } else {
      _titlecenter = "Result";
    }

    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s270150/Gadgetou/php//loadpaymenthistory.php"),
        body: {"email": widget.user.email}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        setState(() {
          _paymentdata.clear();
          _titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(response.body);
          _paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadOrderDetails(int index) {
    Order order = new Order(
        billid: _paymentdata[index]['billid'],
        orderid: _paymentdata[index]['orderid'],
        total: _paymentdata[index]['total'],
        dateorder: _paymentdata[index]['date']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderDetailScreen(
                  order: order,
                  user: widget.user,
                )));
  }
}

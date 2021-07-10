import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myapp/model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/model/product.dart';
import 'package:myapp/model/validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:myapp/model/product.dart';
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/config.dart';

class SearchProducts {
  String productName, productType, pictureUrl;
  double price;
  int quantity, productId;

  SearchProducts(
      {required this.productId,
      required this.productName,
      required this.productType,
      required this.price,
      required this.quantity,
      required this.pictureUrl});

  factory SearchProducts.fromJson(Map<String, dynamic> json) {
    return new SearchProducts(
      productId: json['productId'],
      productName: json['productName'],
      productType: json['productType'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      pictureUrl: json['picture'],
    );
  }
}

class SearchProduct extends StatefulWidget {
  final User user;
  const SearchProduct({Key? key, required this.user});
  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> with Validator {
  String _titlecenter = "Loading...";
  final ProductProvider product = new ProductProvider();
  List<ProductProvider> _productList = [];
  List<SearchProducts> _search = [];
  //_productList.add(ProductProvider.productList);
  // void load() {
  //   if (_search.isEmpty || _search.length == 0) {
  //     product.getProducts();
  //     _productList = product.productList.cast<ProductProvider>();
  //     _search = _productList.cast<SearchProducts>();
  //   }
  // }

  late double screenHeight, screenWidth;
  late SharedPreferences prefs;
  String email = "";
  int cartitem = 0;
  TextEditingController _srcController = new TextEditingController();
  bool _isLoading = false;
  final String url =
      "https://crimsonwebs.com/s270150/Gadgetou/php/searchproducts.php";

  @override
  void initState() {
    // load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Search'),
          actions: [
            TextButton.icon(
                onPressed: () => {_goToCart()},
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                label: Text(
                  cartitem.toString(),
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 50,
                        width: screenWidth / 1.5,
                        child: TextFormField(
                          style: TextStyle(fontSize: 14),
                          controller: _srcController,
                          decoration: InputDecoration(
                            hintText: "Search product",
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  _loadProduct(_srcController.text),
                              icon: Icon(Icons.search),
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.white24)),
                          ),
                        ),
                      ),
                    ],
                  )),
              if (_search.isEmpty)
                Flexible(child: Center(child: Text(_titlecenter)))
              else
                Flexible(
                    child: OrientationBuilder(builder: (context, orientation) {
                  return StaggeredGridView.countBuilder(
                      padding: EdgeInsets.all(10),
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 4,
                      itemCount: _search.length,
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.fit(1),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Column(
                          children: [
                            Container(
                              //color: Colors.red,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height:
                                            orientation == Orientation.portrait
                                                ? 100
                                                : 150,
                                        width:
                                            orientation == Orientation.portrait
                                                ? 100
                                                : 150,
                                        child: Image.network(
                                            _search[index].pictureUrl),
                                      ),
                                      Text(
                                        titleSub(_search[index].productName)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(_search[index]
                                              .productType[0]
                                              .toUpperCase() +
                                          _search[index]
                                              .productType
                                              .substring(1)),
                                      Text("Qty:" +
                                          _search[index].quantity.toString()),
                                      Text("RM " +
                                          double.parse(_search[index]
                                                  .price
                                                  .toString())
                                              .toStringAsFixed(2)),
                                      Container(
                                        child: ElevatedButton(
                                          onPressed: () => {_addtocart(index)},
                                          child: Text("Add to Cart"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                }))
            ],
          ),
        ),
      ),
    );
  }

  String titleSub(String title) {
    if (title.length > 15) {
      return title.substring(0, 15) + "...";
    } else {
      return title;
    }
  }

  Future<void> _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email") ?? '';
    print(email);
    if (email == '') {
      _loademaildialog();
    } else {}
  }

  _loadProduct(String prname) async {
    _search.clear();
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s270150/Gadgetou/php/searchproducts.php"),
        body: {"prname": prname}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "No product";
        _search.clear();
        // load();
        return;
      } else {
        var jsondata = json.decode(response.body);
        var js = jsondata["data"]["products"];
        print(js);
        _titlecenter = "";
        setState(() {
          _search.clear();
          for (Map search in js) {
            _search
                .add(SearchProducts.fromJson(search as Map<String, dynamic>));
          }
        });
      }
    });
  }

  _addtocart(int index) async {
    if (email == '') {
      _loademaildialog();
    } else {
      ProgressDialog progressDialog = ProgressDialog(context,
          message: Text("Add to cart"), title: Text("Progress..."));
      progressDialog.show();
      await Future.delayed(Duration(seconds: 1));
      String prid = (_search[index].productId).toString();
      String prname = (_search[index].productName).toString();
      String price = (_search[index].price).toString();
      String picture = _search[index].pictureUrl;
      http.post(
          Uri.parse(CONFIG.SERVER + "/s270150/Gadgetou/php/insertcart.php"),
          body: {
            "email": email,
            "prid": prid,
            "productName": prname,
            "price": price,
            "picture": picture
          }).then((response) {
        print(response.body);
        if (response.body == "failed") {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          _loadCart();
        }
      });
      progressDialog.dismiss();
    }
  }

  _goToCart() async {
    if (email == "") {
      Fluttertoast.showToast(
          msg: "Please set your email first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      _loademaildialog();
    } else {
      //await Navigator.of(context).push(
      //MaterialPageRoute(
      //builder: (context) => CartPage(email: email),
      // ),
      //);
      _loadProduct("all");
    }
  }

  void _loademaildialog() {
    TextEditingController _emailController = new TextEditingController();
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: new Text(
                  'Your Email',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.white24)),
                              )),
                          ElevatedButton(
                              onPressed: () async {
                                String _email =
                                    _emailController.text.toString();
                                prefs = await SharedPreferences.getInstance();
                                await prefs.setString("email", _email);
                                email = _email;
                                Fluttertoast.showToast(
                                    msg: "Email stored",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Color.fromRGBO(191, 30, 46, 50),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.of(context).pop();
                              },
                              child: Text("Proceed"))
                        ],
                      ),
                    ),
                  ),
                ]),
        context: context);
  }

  void _loadCart() {
    print(email);
    http.post(
        Uri.parse(CONFIG.SERVER + "/s270150/Gadgetou/php/loadcartitem.php"),
        body: {"email": email}).then((response) {
      if (response.body == "success") {}
      setState(() {
        cartitem = int.parse(response.body);
        print(cartitem);
      });
    });
  }

  Future<void> _testasync() async {
    await _loadPref();
    _loadProduct("all");
    _loadCart();
  }
}

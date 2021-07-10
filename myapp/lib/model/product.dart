import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Product {
  late String productName, productType, pictureUrl, image64;
  late double price;
  late int quantity, productId;

  Product(
      {required this.productId,
      required this.productName,
      required this.productType,
      required this.price,
      required this.quantity});

  Product.fromJson(json) {
    productId = json['productId'];
    productName = json['productName'];
    productType = json['productType'];
    price = json['price'].toDouble();
    quantity = json['quantity'];
    pictureUrl = json['picture'];
  }
}

class ProductProvider with ChangeNotifier {
  List<Product> productList = [];
  getProducts() async {
    var url = Uri.parse(
        'https://crimsonwebs.com/s270150/Gadgetou/php/loadproducts.php');
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
      data = data['data']['products'];
      print(data);
      productList =
          data.map<Product>((item) => Product.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<bool?> addProduct(Product product, File imageFile) async {
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    var url = Uri.parse(
        'https://crimsonwebs.com/s270150/Gadgetou/php/newproduct.php');
    var response = await http.post(url, body: {
      'productName': product.productName,
      'productType': product.productType,
      'price': product.price.toString(),
      'quantity': product.quantity.toString(),
      'encoded_base64string': base64Image,
    });
    if (response.body == 'success') {
      getProducts();
      return true;
    } else if (response.body == 'failed') {
      return false;
    } else
      return null;
  }

  Future<bool> deleteProduct(int productId) async {
    var url = Uri.parse(
        'https://crimsonwebs.com/s270150/Gadgetou/php/deleteproduct.php');
    var response = await http.post(url, body: {
      'ProductID': productId,
    });
    if (response.body == 'success') {
      getProducts();
      return true;
    }
    return false;
  }
}

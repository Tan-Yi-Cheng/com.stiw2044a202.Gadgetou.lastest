import 'package:flutter/material.dart';
import 'package:myapp/model/user.dart';
import 'package:myapp/view/mydrawer.dart';
import 'package:myapp/view/tabnewgram.dart';
import 'package:myapp/view/tabyourgrams.dart';
//shop mart
import 'tablatestgrams.dart';

//new
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:myapp/model/product.dart';
import 'package:myapp/view/newproduct.dart';
import 'package:myapp/view/searchproduct.dart';
import 'package:myapp/view/widget/product_card.dart';

class ShopMartScreen extends StatefulWidget {
  final User user;
  const ShopMartScreen({Key? key, required this.user}) : super(key: key);
  @override
  _ShopMartScreenState createState() => _ShopMartScreenState();
}

class _ShopMartScreenState extends State<ShopMartScreen> {
  //int _currentIndex = 0;

  late List<Widget> tabchildren;
  String maintitle = "Shop Screen";

  /*@override
  void initState() {
    setState(() {
      maintitle = "Shop Screen";
    });
    super.initState();
    //tabchildren = [TabLatestGrams(), TabNewGram(), TabYourGrams()];
  }*/

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getProducts();

    return Scaffold(
/*
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.red.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        //currentIndex: _currentIndex, //
      ),
*/
      appBar: AppBar(
        title: Text('Shop Mart'),
        actions: [
          TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchProduct(user: widget.user)));
              },
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              label: Text(
                "Search",
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      drawer: MyDrawer(user: widget.user),
      //body: tabchildren[_currentIndex],
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<ProductProvider>(builder: (context, product, _) {
          List<Product> productList = product.productList;
          productList.forEach((element) => print(element.productName));
          return GridView.builder(
            itemCount: product.productList.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (BuildContext context, int index) {
              return ProductCard(
                productList[index],
              );
            },
          );
        }),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewProduct()));
        },
      ),
    );
  }
}

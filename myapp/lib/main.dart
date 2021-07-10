import 'package:flutter/material.dart';
import 'package:myapp/view/loginscreen.dart';
import 'package:myapp/view/mainscreen.dart';
import 'package:myapp/view/registrationscreen.dart';
import 'package:myapp/view/shopmartscreen.dart';
import 'package:provider/provider.dart';

import 'model/themes.dart';
import 'view/splashscreen.dart';
import 'package:myapp/model/product.dart';
import 'package:myapp/model/user.dart';
import 'package:myapp/view/newproduct.dart';
import 'package:myapp/view/widget/product_card.dart';

void main() async => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProductProvider(),
      child: MaterialApp(
        theme: CustomTheme.lighttheme,
        routes: <String, WidgetBuilder>{
          '/loginscreen': (BuildContext context) => new LoginScreen(),
          '/registerscreen': (BuildContext context) => new RegistrationScreen(),
        },
        title: 'Gadgetou',
        home: SplashScreen(),
      ),
    );
  }
}

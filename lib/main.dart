import 'package:flutter/material.dart';
import 'package:grocery_payment/provider/product_provider.dart';
import 'package:grocery_payment/screens/home_page.dart';
import 'package:grocery_payment/services/local_database.dart';
import 'package:provider/provider.dart';
import 'package:response/response.dart';

var response = ResponseUI.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: Response(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
        ),
      ),
      create: (BuildContext context) => ProductsController(),
    );
  }
}

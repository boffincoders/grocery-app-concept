import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:grocery_payment/provider/product_provider.dart';
import 'package:grocery_payment/screens/home_page.dart';
import 'package:grocery_payment/screens/payment/payment_options.dart';
import 'package:grocery_payment/services/local_database.dart';
import 'package:grocery_payment/utils/payment_details.dart';
import 'package:provider/provider.dart';
import 'package:response/response.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

var response = ResponseUI.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // set the publishable key for Stripe - this is mandatory
  Stripe.publishableKey = PaymentGatewayDetails.stripePublishableKey;
  /*Stripe.merchantIdentifier = 'MerchantIdentifier';
  Stripe.urlScheme = 'flutterstripe';*/
  await Stripe.instance.applySettings();
  await PreferenceUtils.init();
 // timeDilation = 5.0;
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

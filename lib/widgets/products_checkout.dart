import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:grocery_payment/models/product.dart';
import 'package:grocery_payment/provider/product_provider.dart';
import 'package:grocery_payment/screens/checkout_screen.dart';
import 'package:grocery_payment/screens/payment/payment_options.dart';
import 'package:grocery_payment/utils/app_theme.dart';
import 'package:grocery_payment/widgets/Illustraion_container.dart';
import 'package:grocery_payment/widgets/checkout_card.dart';

import 'package:provider/provider.dart';

import '../main.dart';
import 'delivery_card.dart';

class ProductsCheckout extends StatelessWidget {
  const ProductsCheckout({
    Key? key,
    required this.cartCheckoutTransitionValue,
    required this.cartProductsProvider,
    required this.totalPriceProvider,
  }) : super(key: key);

  final double cartCheckoutTransitionValue;
  final UnmodifiableListView<Product> cartProductsProvider;
  final double totalPriceProvider;

  @override
  Widget build(BuildContext context) {
    var finalTotalCost = totalPriceProvider == 0
        ? 0
        : (totalPriceProvider > 99
            ? totalPriceProvider
            : totalPriceProvider + 5);
    var cartProductsProvider = Provider.of<ProductsController>(context).cart;
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.loose,
      children: <Widget>[
        Positioned(
          top: -cartCheckoutTransitionValue,
          left: 0,
          child: Text(
            "Cart",
            style: TextStyle(
              fontSize: response.setFontSize(35),
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: response.setHeight(80 - cartCheckoutTransitionValue),
          child: Container(
            height: response.setHeight(220 + cartCheckoutTransitionValue),
            width: double.infinity,
            // color: Colors.teal,
            child: cartProductsProvider.length < 1
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "You don't have any items in your Cart.\nStart shopping now, and checkout.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : _buildListView(),
          ),
        ),
        Positioned(
          left: 0,
          bottom:
              response.setHeight(cartProductsProvider.isNotEmpty ? 40 : 200),
          right: 0,
          child: Container(
            // color: AppTheme.mainCartBackgroundColor,
            child: Visibility(
              visible: cartProductsProvider.isNotEmpty,
              replacement: IllustrationContainer(
                path: AppTheme.emptyCartJSON,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DeliveryCard(totalPriceProvider: totalPriceProvider),
                  SizedBox(height: response.setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Total:",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: response.setFontSize(25),
                        ),
                      ),
                      Spacer(),
                      Text(
                        "\₹${finalTotalCost..toStringAsExponential(3)}",
                        style: TextStyle(
                          color: Colors.white.withAlpha(240),
                          fontWeight: FontWeight.bold,
                          fontSize: response.setFontSize(35),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: response.setHeight(50)),
                  _buildNextButton(context),
                  SizedBox(height: response.setHeight(40)),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*Navigator.push(
            context, MaterialPageRoute(builder: (context) => CheckOut()));*/

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentOptions(
                    totalPrice: totalPriceProvider < 99
                        ? totalPriceProvider + 5
                        : totalPriceProvider)));
      },
      child: Container(
        height: response.setHeight(55),
        decoration: BoxDecoration(
            color: AppTheme.mainOrangeColor,
            borderRadius: BorderRadius.circular(response.setHeight(50))),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Next", //Place Order
                style: TextStyle(
                  fontSize: response.setFontSize(16),
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      itemCount: cartProductsProvider.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(cartProductsProvider[index].picPath),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            Provider.of<ProductsController>(context, listen: false)
                .deleteFromCart(index);
            Provider.of<ProductsController>(context, listen: false)
                .returnTotalCost();
          },
          background: Container(
            color: Colors.red,
            child: Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  Text(
                    " Delete",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    width: response.setHeight(20),
                  ),
                ],
              ),
              alignment: Alignment.centerRight,
            ),
          ),
          child: Checkout(
              cartProductsProvider: cartProductsProvider, index: index),
        );
      },
    );
  }
}

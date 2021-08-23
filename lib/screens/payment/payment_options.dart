import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:grocery_payment/screens/payment/card_payment.dart';
import 'package:grocery_payment/utils/app_theme.dart';

class PaymentOptions extends StatefulWidget {
  final double totalPrice;

  const PaymentOptions({required this.totalPrice, Key? key}) : super(key: key);

  @override
  _PaymentOptionsState createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  PayWith payWith = PayWith.CARD;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Payment",
          style: TextStyle(color: Colors.black, fontSize: 22.0),
        ),
        leading: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          margin: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Total amount to pay",
                style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                ),
                height: 50.0,
                width: size.width * .5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "\₹" + widget.totalPrice.toString(),
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 40,
                ),
                width: size.width * .8,
                height: 50.0,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.3),
                    borderRadius: BorderRadius.circular(25.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: TextFormField(
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 20, right: 20),
                          hintText: "Have a gift card?"),
                    )),
                    Container(
                      width: 100.0,
                      decoration: BoxDecoration(
                          color: AppTheme.mainOrangeColor,
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Center(
                        child: Text(
                          "Apply",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Text(
                "Select payment method",
                style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        payWith = PayWith.CARD;
                      });
                    },
                    child: optionView(
                        size,
                        "Credit/ Debit card",
                        "assets/card.png",
                        payWith == PayWith.CARD ? true : false),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        payWith = PayWith.NET;
                      });
                    },
                    child: optionView(size, "Net banking", "assets/bank.png",
                        payWith == PayWith.NET ? true : false),
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        payWith = PayWith.UPI;
                      });
                    },
                    child: optionView(size, "UPI/ Wallets", "assets/upi.png",
                        payWith == PayWith.UPI ? true : false),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        payWith = PayWith.COD;
                      });
                    },
                    child: optionView(size, "Pay on delivery", "assets/pod.png",
                        payWith == PayWith.COD ? true : false),
                  )
                ],
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  if (payWith == PayWith.CARD) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CardPayment(widget.totalPrice)));
                  } else {
                    await _buildAlertDialog(context);
                  }
                },
                child: Container(
                  width: size.width * .4,
                  height: 50.0,
                  margin: EdgeInsets.only(top: 50.0, bottom: 20.0),
                  decoration: BoxDecoration(
                      color: AppTheme.mainOrangeColor,
                      borderRadius: BorderRadius.circular(25.0)),
                  child: Center(
                    child: Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget optionView(Size size, String text, String path, bool isSelected) {
    return Container(
      width: size.width / 2.4,
      height: 180.0,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0, right: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    path,
                    height: 70.0,
                    width: 70.0,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ],
              ),
            ),
          ),
          isSelected
              ? Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                        color: AppTheme.mainOrangeColor,
                        shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  FutureOr<bool?> _buildAlertDialog(BuildContext context) async {
    return showPlatformDialog<bool>(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text(
          'Info',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text("Coming soon...., stay tuned."),
        ),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText('OK'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
}

enum PayWith { CARD, UPI, NET, COD }

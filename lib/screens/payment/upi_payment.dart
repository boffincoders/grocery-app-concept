import 'package:flutter/material.dart';
import 'package:grocery_payment/utils/app_theme.dart';

class UPIPayment extends StatefulWidget {
  final double totalPrice;

  const UPIPayment(this.totalPrice, {Key? key}) : super(key: key);

  @override
  _UPIPaymentState createState() => _UPIPaymentState();
}

class _UPIPaymentState extends State<UPIPayment> {
  static const IconData payment = IconData(0xe481, fontFamily: 'MaterialIcons');
  int _payRadioBtnVal = 0;

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
          "UPI/Wallets",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "UPI",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              upiPaymentOptions(0, "Google Pay", "assets/google_pay.png"),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 1.0,
                color: Colors.grey.withOpacity(.4),
              ),
              upiPaymentOptions(1, "Apple Pay", "assets/apple_pay.png"),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 1.0,
                color: Colors.grey.withOpacity(.4),
              ),
              upiPaymentOptions(2, "Amazon Pay", "assets/amazon_pay.png"),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 1.0,
                color: Colors.grey.withOpacity(.4),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Text(
                  "Wallets",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              upiPaymentOptions(3, "Paytm", "assets/paytm.png"),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 1.0,
                color: Colors.grey.withOpacity(.4),
              ),
              upiPaymentOptions(4, "Phone Pe", "assets/phone_pe.png"),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 1.0,
                color: Colors.grey.withOpacity(.4),
              ),
              SizedBox(
                height: 10.0,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: size.width * .4,
                  height: 50.0,
                  margin: EdgeInsets.only(top: 50.0, bottom: 20.0),
                  decoration: BoxDecoration(
                      color: AppTheme.mainOrangeColor,
                      borderRadius: BorderRadius.circular(25.0)),
                  child: Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget upiPaymentOptions(int value, String name, String path) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Radio(
                value: value,
                groupValue: _payRadioBtnVal,
                onChanged: _handleGenderChange,
                activeColor: Colors.blueAccent,
                focusColor: Colors.blueAccent,
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ],
          ),
          Image.asset(
            path,
            height: 50.0,
            width: 50.0,
          ),
        ],
      );

  void _handleGenderChange(int? value) {
    setState(() {
      _payRadioBtnVal = value!;
    });
  }
}

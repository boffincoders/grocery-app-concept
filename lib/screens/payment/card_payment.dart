import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:grocery_payment/screens/checkout_screen.dart';
import 'package:grocery_payment/utils/app_theme.dart';
import 'package:grocery_payment/utils/config.dart';
import 'package:grocery_payment/utils/payment_details.dart';
import 'package:http/http.dart' as http;

class CardPayment extends StatefulWidget {
  final double totalPrice;

  const CardPayment(this.totalPrice, {Key? key}) : super(key: key);

  @override
  _CardPaymentState createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {
  CardDetails _card = CardDetails();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Card Details",
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
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                cardBgColor: AppTheme.mainOrangeColor,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        themeColor: Colors.blue,
                        cardNumberDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Card Holder',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      isLoading
                          ? CircularProgressIndicator(
                              color: AppTheme.mainOrangeColor,
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                primary: AppTheme.mainOrangeColor,
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                child: const Text(
                                  'Validate & Pay',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'halter',
                                    fontSize: 16,
                                    package: 'flutter_credit_card',
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  String expYear = expiryDate.split('/')[1];
                                  String expMonth = expiryDate.split('/')[0];
                                  setState(() {
                                    _card = _card.copyWith(
                                        number: cardNumber,
                                        expirationYear: int.tryParse(expYear),
                                        expirationMonth: int.tryParse(expMonth),
                                        cvc: cvvCode);
                                  });
                                  if (mounted)
                                    setState(() {
                                      isLoading = true;
                                    });
                                  _handlePayPress();
                                } else {
                                  print('invalid!');
                                }
                              },
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePayPress() async {
    var stripeInstance = Stripe.instance;
    await stripeInstance.dangerouslyUpdateCardDetails(_card);
    var amount = (widget.totalPrice * 100);

    try {
      // 1. Gather customer billing information (ex. email)

      final billingDetails = BillingDetails(
        email: 'boffincoders@gmail.com',
        phone: '+919501887900',
        name: 'Boffin Coders',
        address: Address(
          line1: "C-201,201 Industrial Area",
          line2: "Phase 8B, Mohali",
          postalCode: "160071",
          city: "Mohali",
          state: "Punjab",
          country: "India",
        ),
      ); // mocked data for tests

      // 2. Create payment method
      final paymentMethod =
          await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(
        billingDetails: billingDetails,
      ));

      // 3. call API to create PaymentIntent
      final paymentIntentResult = await callNoWebhookPayEndpointMethodId(
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: 'inr', // mocked data
        items: [
          {
            'id': 2,
            'amount': amount,
            //'amount': 20,
          }
        ],
      );

      if (paymentIntentResult['error'] != null) {
        // Error during creating or confirming Intent
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${paymentIntentResult['error']}')));
        return;
      }

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == null) {
        // Payment succedeed

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Success!: The payment was confirmed successfully!')));
        afterPayment();
        return;
      }

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == true) {
        // 4. if payment requires action calling handleCardAction
        final paymentIntent = await Stripe.instance
            .handleCardAction(paymentIntentResult['clientSecret']);

        if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
          // 5. Call API to confirm intent
          await confirmIntent(paymentIntent.id);
        } else {
          if (mounted)
            setState(() {
              isLoading = false;
            });
          // Payment succedeed
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error: ${paymentIntentResult['error']}')));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      if (mounted)
        setState(() {
          isLoading = false;
        });
      rethrow;
    }
  }

  Future<void> confirmIntent(String paymentIntentId) async {
    final result = await callNoWebhookPayEndpointIntentId(
        paymentIntentId: paymentIntentId);
    if (result['error'] != null) {
      if (mounted)
        setState(() {
          isLoading = false;
        });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${result['error']}')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Success!: The payment was confirmed successfully!')));
      afterPayment();
    }
  }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointIntentId({
    required String paymentIntentId,
  }) async {
    final url = Uri.parse('$kApiUrl/charge-card-off-session');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'paymentIntentId': paymentIntentId}),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    List<Map<String, dynamic>>? items,
  }) async {
    final url = Uri.parse('$kApiUrl/pay-without-webhooks');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'useStripeSdk': useStripeSdk,
        'paymentMethodId': paymentMethodId,
        'currency': currency,
        'items': items,
        'description': 'Boffin Coders Grocery App Payment',
      }),
    );
    return json.decode(response.body);
  }

  void afterPayment() {
    if (mounted)
      setState(() {
        isLoading = false;
      });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CheckOut()));
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

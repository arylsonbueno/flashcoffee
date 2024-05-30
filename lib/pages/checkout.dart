import 'dart:io';

import 'package:checkout_screen_ui/checkout_page/checkout_page.dart';
import 'package:checkout_screen_ui/models/price_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcoffee/firebase/models/FbBasket.dart';
import 'package:flashcoffee/pages/home.dart';
import 'package:flashcoffee/services/basket_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../firebase/FirebaseHelper.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage(this.currentUser, {super.key});

  final User currentUser;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  _buildDetails() {
    final List<PriceItem> _priceItems = [];
    BasketController.getInstance().getBasket().itens.forEach((item) {
      _priceItems.add(PriceItem(
          name: '${item.name} (${item.coffeeName})',
          quantity: item.quantity,
          itemCostCents: (item.getPrice() * 100).round(),
          canEditQuantity: false
      ));
    });

    var data = CheckoutData(
      priceItems: _priceItems,
      taxRate: 0.00,
      payToName: 'Pagamento',
      displayNativePay: true,
      isApple: kIsWeb ? false : Platform.isIOS,
      onNativePay: (checkoutResults) {
        print('Native Pay');
        _writePayment();
      },
      onCardPay: (paymentInfo, checkoutResults){
        print('Card pay');
        _writePayment();
      },
      onBack: ()=> Navigator.of(context).pop(),
    );
    return CheckoutPage(data: data);
  }

  _writePayment() {
    BasketController controller = BasketController.getInstance();
    FbBasket basket = controller.getBasket();
    basket.userUid = widget.currentUser.uid;
    basket.userMail = widget.currentUser.email;
    FirebaseHelper.insert("sales", basket.toMap()).then(
        (success) {
          controller.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(widget.currentUser),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildDetails(),
      ),
    );
  }
}

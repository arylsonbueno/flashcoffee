import 'dart:io';

import 'package:checkout_screen_ui/checkout_page/checkout_page.dart';
import 'package:checkout_screen_ui/models/price_item.dart';
import 'package:flashcoffee/pages/home.dart';
import 'package:flashcoffee/services/basket_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../firebase/FirebaseHelper.dart';
import '../widgets/primary_button.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  _buildDetails() {
    final List<PriceItem> _priceItems = [
      PriceItem(name: 'Product A', quantity: 1, itemCostCents: 5200),
      PriceItem(name: 'Product B', quantity: 2, itemCostCents: 8599),
      PriceItem(name: 'Product C', quantity: 1, itemCostCents: 2499),
      PriceItem(name: 'Delivery Charge', quantity: 1, itemCostCents: 1599, canEditQuantity: false),
    ];

    var data = CheckoutData(
      priceItems: _priceItems,
      taxRate: 0.00,
      payToName: 'Flash Coffee Loja ZERO',
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
    FirebaseHelper.insert("sales", controller.getBasket().toMap()).then(
        (success) {
          controller.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Confirme seu pedido"),
      ),
      body: Center(
        child: _buildDetails(),
      ),
    );
  }
}

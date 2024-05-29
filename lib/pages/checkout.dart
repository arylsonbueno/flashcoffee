import 'package:flashcoffee/firebase/models/FbReference.dart';
import 'package:flashcoffee/pages/home.dart';
import 'package:flashcoffee/services/basket_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../firebase/FirebaseHelper.dart';
import '../firebase/models/FbBasket.dart';
import '../widgets/primary_button.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class ListItem {
  String title;
  String image;

  ListItem(this.title, this.image);
}

class _CheckoutPageState extends State<CheckoutPage> {

  _writePayment() {
    BasketController controller = BasketController.getInstance();
    FirebaseHelper.insert("sales", controller.getBasket().toMap()).then(
        (success) {
          controller.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                //userSession: widget.userSession,
              ),
            ),
          );
        });
  }

  Widget _primaryButton() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.1, horizontal: screenWidth * 0.1),
        child: PrimaryButton(
          title: "Pagar",
          label: "Pagar",
          onPressed: _writePayment,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Confirme seu pedido"),
      ),
      body: Center(
        child: ListView(
        shrinkWrap: true,
        semanticChildCount: 3,
        children: <Widget>[
            _primaryButton(),
          ]
        ),
      ),
    );
  }
}

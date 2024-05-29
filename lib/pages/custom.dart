import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/models/FbBasket.dart';
import '../services/basket_controller.dart';
import 'checkout.dart';

class CustomPage extends StatefulWidget {
  const CustomPage({super.key});

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class ListItem {
  String title;
  String image;

  ListItem(this.title, this.image);
}

class _CustomPageState extends State<CustomPage> {

  final _formKey = GlobalKey<FormState>();

  _inputName() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor informe seu nome';
        }
        return null;
      },
    );
  }

  _labelSelectedCoffee() {
    return Text(BasketController.getInstance().getBasket().itens.first.name);
  }

  Widget _buildCustomForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _inputName(),
          _labelSelectedCoffee(),
        ],
      ),
    );
  }

  _openCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          //userSession: widget.userSession,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Personalize seu café..."),
      ),
      body: Center(
        child: _buildCustomForm(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCheckout,
        child: const Icon(Icons.payment, color: Colors.white, size: 28),
      ),
    );
  }
}

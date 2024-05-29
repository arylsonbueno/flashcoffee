import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class DropDownItem {
  dynamic key;
  String? value;

  DropDownItem({this.key, this.value});
}

class _CustomPageState extends State<CustomPage> {

  final _formKey = GlobalKey<FormState>();
  int? _coffeeSize = 1;

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

  List<DropDownItem> _sizes = [
    DropDownItem(key: 0, value: "Pequeno"),
    DropDownItem(key: 1, value: "Médio"),
    DropDownItem(key: 2, value: "Grande")
  ];
  Widget _buildDropButtonSize() {
    return DropdownButton<int>(
      value: _coffeeSize,
      icon: Icon(Icons.keyboard_arrow_down),
      onChanged: (int? newValue) {
        setState(() {
          _coffeeSize = newValue;
        });
      },
      isDense: true,
      items: _sizes.map<DropdownMenuItem<int>>((DropDownItem item) {
        return DropdownMenuItem<int>(
          value: item.key,
          child: Text(item.value!),
        );
      }).toList(),
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
          _buildDropButtonSize(),
        ],
      ),
    );
  }

  _openCheckout() {
    FbSaleItem item = BasketController.getInstance().getBasket().itens.first;
    item.size = _coffeeSize!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(),
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

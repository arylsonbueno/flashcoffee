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

  Widget buildColoredIcon(IconData icon, Color color) {
    return CircleAvatar(
      backgroundColor: color, // Define a opacidade da cor
      child: Icon(icon, color: Colors.white), // Define o ícone
    );
  }

  Map<String, List<Widget>> _customMap(BuildContext context) {
    return {
      "Café": [
        ListTile(
          leading: buildColoredIcon(Icons.cameraswitch, Colors.indigoAccent),
          title: Text("Tamanho"),
          subtitle: Text("O tamanho faz toda a diferença"),
          subtitleTextStyle: TextStyle(color: Theme.of(context).hintColor),
          trailing: _buildDropButtonSize(),
          style: ListTileStyle.list,
        ),
      ]
    };
  }

  Widget _buildCustomList() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _customMap(context).length,
      shrinkWrap: true,
      physics: PageScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        String key = _customMap(context).keys.elementAt(index);
        return Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: screenWidth * 0.05, bottom: 10.0),
              child: Text(
                key,
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).hintColor),
              ),
            ),
            Container(
                margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(5),
                  itemCount: _customMap(context)[key]!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int subIndex) {
                    return Column(
                      children: [
                        _customMap(context)[key]![subIndex],
                        Visibility(
                          visible:
                          subIndex < _customMap(context)[key]!.length - 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: screenWidth * 0.17,
                                right: screenWidth * 0.05),
                            child: Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.15),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )),
          ],
        );
      },
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
        child: _buildCustomList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCheckout,
        child: const Icon(Icons.payment, color: Colors.white, size: 28),
      ),
    );
  }
}

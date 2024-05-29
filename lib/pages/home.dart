import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../firebase/models/FbBasket.dart';
import '../services/basket_controller.dart';
import 'custom.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class ListItem {
  String title;
  String image;

  ListItem(this.title, this.image);
}

class _HomePageState extends State<HomePage> {

  Map<int,double> priceMap = {0: 18, 1: 22, 2: 24};
  List<ListItem> items = [
    ListItem("Cappuccino", "assets/cappuccino.png"),
    ListItem("Frappe", "assets/frappe.png"),
    ListItem("Glase", "assets/glase.png"),
  ];

  Widget _buildGridView() {
    return ListView.builder(
      // Let the ListView know how many items it needs to build.
      itemCount: items.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        final item = items[index];

        return GestureDetector(
            onTap: () {
              BasketController.getInstance()
                  .add(FbSaleItem(item.title, priceMap));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomPage(),
                ),
              );
        },
        child: ListTile(
          title: Text(item.title),
          leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 64,
                maxHeight: 64,
              ),
              child: Image.asset(item.image, fit: BoxFit.cover),
            )
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Escolha seu café..."),
      ),
      body: Center(
        child: _buildGridView(),
      ),
    );
  }
}

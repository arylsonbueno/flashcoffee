import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flashcoffee/firebase/models/FbReference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../firebase/FirebaseHelper.dart';
import '../firebase/models/FbBasket.dart';
import '../services/basket_controller.dart';
import '../utils/image_firestored.dart';
import 'custom.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.currentUser, {super.key});

  final User currentUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class ListItem {
  String title;
  String image;
  Map<int,dynamic> priceMap;

  ListItem(this.title, this.image, this.priceMap);
}

class _HomePageState extends State<HomePage> {

  Map<int,dynamic> _readPriceMap(DataSnapshot dsMap) {
    List<dynamic> list = dsMap.value as List<dynamic>;
    return list.asMap();
  }

  Future<List<ListItem>> _loadProducts() async {
    try {
      FbReference ref = new FbReference("products");
      return FirebaseHelper.readNode(ref, timeout: Duration(seconds: 5)).then((
          event) {
        DataSnapshot dataSnap = event.snapshot.child('itens');
        List<ListItem> itens = [];
        dataSnap.children.forEach((dsProduct) {
          String name = dsProduct.child('name').value as String;
          String imageUrl = dsProduct.child('image').value as String;
          Map<int,dynamic> priceMap = _readPriceMap(dsProduct.child('priceMap'));
          itens.add(ListItem(name, imageUrl, priceMap));
        });
        return itens;
      });
    } catch(error) {
      return [];
    }
  }

  Widget _buildGridView() {
    return FutureBuilder(
        future: _loadProducts(),
        builder: (context, res) {
          if (res.connectionState != ConnectionState.done ||
              res.hasData == false) {
            return Container();//loading...
          }
          return ListView.builder(
            itemCount: res.data!.length,
            itemBuilder: (context, index) {
              final item = res.data![index];
              return GestureDetector(
                  onTap: () {
                    BasketController.getInstance()
                        .add(FbSaleItem(item.title, item.priceMap));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomPage(widget.currentUser),
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
                        child: ImageFirestoredWidget(uri: item.image),
                      )
                  ));
            },
          );
        }
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

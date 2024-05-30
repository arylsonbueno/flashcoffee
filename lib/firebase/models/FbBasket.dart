class FbSaleItem {
  String name;
  Map<int,dynamic> priceMap;
  int size = 0;
  int quantity = 1;

  FbSaleItem(this.name, this.priceMap);

  double getPrice() {
    return priceMap.values.elementAt(size);
  }
}

class FbBasket {

  List<FbSaleItem> itens = [];

  double amount() {
    double amount = 0;
    itens.forEach((item) => amount += item.getPrice());
    return amount;
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount(),
    };
  }

}
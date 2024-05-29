class FbSaleItem {
  String name;
  double price;
  int size = 0;
  int quantity = 1;

  FbSaleItem(this.name, this.price);
}

class FbBasket {

  List<FbSaleItem> itens = [];

  double amount() {
    double amount = 0;
    itens.forEach((item) => amount += item.price);
    return amount;
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount(),
    };
  }

}
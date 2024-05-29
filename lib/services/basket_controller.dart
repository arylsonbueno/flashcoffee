import '../firebase/models/FbBasket.dart';

class BasketController {
  static BasketController _instance = BasketController();
  FbBasket _basket = FbBasket();

  static BasketController getInstance() {
    return _instance;
  }

  FbBasket getBasket() {
    return _basket;
  }

  add(FbSaleItem item) {
    _basket!.itens.add(item);
  }

  updateBasket(FbBasket basket) {
    _basket = basket;
  }

}
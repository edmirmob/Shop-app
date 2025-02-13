import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

//sum of amount
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) => {
          total += cartItem.price * cartItem.quantity,
        });
    return total;
  }

  void addItem(String id, double price, String title) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (update) => CartItem(
              id: update.id,
              title: update.title,
              quantity: update.quantity + 1,
              price: update.price));
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  void removeCard(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (postojecaKarticaStavke) => CartItem(
              id: postojecaKarticaStavke.id,
              title: postojecaKarticaStavke.title,
              price: postojecaKarticaStavke.price,
              quantity: postojecaKarticaStavke.quantity - 1));
    }
    else{
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

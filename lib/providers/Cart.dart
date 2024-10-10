import 'package:flutter/cupertino.dart';
import '../Store.dart';

class Cart with ChangeNotifier {
  final List<Product> _cartProducts = [];

  List<Product> get cartProducts => _cartProducts;

  void addToCart(Product product) {
    _cartProducts.add(product);
    notifyListeners(); // Notify all listeners that cart has changed
  }

  void removeFromCart(Product product) {
    _cartProducts.remove(product);
    notifyListeners();
  }
}

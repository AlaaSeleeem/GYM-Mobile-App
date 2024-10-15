import 'package:flutter/cupertino.dart';
import '../Store.dart';

class Cart with ChangeNotifier {
  final List<Product> _cartProducts = [];

  List<Product> get cartProducts => _cartProducts;

  void addToCart(Product product) {
    // loop on current products to find the selected product if exist
    // Product? existentProduct;
    //
    // for (Product item in _cartProducts) {
    //   if (item.id == product.id) {
    //     existentProduct = item;
    //     break;
    //   }
    // }
    //
    // if (existentProduct != null) {
    //   incrementProduct(existentProduct);
    // } else {
    //   _cartProducts.add(product);
    // }

    bool existent;

    try {
      _cartProducts.firstWhere((item) {
        return (item.id == product.id);
      });
      existent = true;
    } catch (e) {
      existent = false;
    }

    if (existent) {
      Product existentProduct = _cartProducts.firstWhere((item) {
        return (item.id == product.id);
      });
      incrementProduct(existentProduct);
    } else {
      _cartProducts.add(product);
    }
    notifyListeners(); // Notify all listeners that cart has changed
  }

  void removeFromCart(Product product) {
    _cartProducts.remove(product);
    notifyListeners();
  }

  void incrementProduct(Product product) {
    product.quantity += 1;
    notifyListeners();
  }

  void decrementProduct(Product product) {
    product.quantity -= 1;
    if (product.quantity < 1) {
      removeFromCart(product);
    }
    notifyListeners();
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;

    for (Product item in _cartProducts) {
      totalPrice += item.price * item.quantity;
    }
    return totalPrice;
  }
}

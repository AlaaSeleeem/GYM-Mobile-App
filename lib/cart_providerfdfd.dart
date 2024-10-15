import 'package:flutter/material.dart';

import 'Store.dart';

class Cart with ChangeNotifier {
  List<Product> _cartProducts = [];

  List<Product> get cartProducts => _cartProducts;

  void addToCart(Product product) {
    final existingProductIndex = _cartProducts.indexWhere((item) => item.name == product.name);

    if (existingProductIndex >= 0) {
      // إذا كان موجودًا، زيادة الكمية
      _cartProducts[existingProductIndex].quantity++;
    } else {
      // إذا لم يكن موجودًا، أضفه إلى السلة
      _cartProducts.add(product);
    }

    notifyListeners(); // لإعلام الواجهات بالتغيير
  }

  void incrementProduct(Product product) {
    final index = _cartProducts.indexOf(product);
    if (index >= 0) {
      _cartProducts[index].quantity++;
      notifyListeners();
    }
  }

  void decrementProduct(Product product) {
    final index = _cartProducts.indexOf(product);
    if (index >= 0) {
      if (_cartProducts[index].quantity > 1) {
        _cartProducts[index].quantity--;
      } else {
        _cartProducts.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(Product product) {
    _cartProducts.remove(product);
    notifyListeners();
  }

  double totalPrice() {
    return _cartProducts.fold(0, (total, current) => total + (current.price * current.quantity));
  }
}

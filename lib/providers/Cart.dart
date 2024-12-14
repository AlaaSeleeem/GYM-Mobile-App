import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/models/order_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class Cart with ChangeNotifier {
  final List<OrderItem> _cartItems = [];

  List<OrderItem> get cartItems => _cartItems;

  void addToCart({required Product product, int amount = 1}) {
    bool existent;

    try {
      _cartItems.firstWhere((item) {
        return (item.product.id == product.id);
      });
      existent = true;
    } catch (e) {
      existent = false;
    }

    if (existent) {
      OrderItem existentProduct = _cartItems.firstWhere((item) {
        return (item.product.id == product.id);
      });
      incrementProduct(existentProduct, amount: amount);
    } else {
      final orderItem = OrderItem(product: product, amount: amount);
      _cartItems.add(orderItem);
    }
    saveCart();
    notifyListeners(); // Notify all listeners that cart has changed
  }

  void removeFromCart(OrderItem item) {
    _cartItems.remove(item);
    saveCart();
    notifyListeners();
  }

  void incrementProduct(OrderItem item, {int amount = 1}) {
    item.amount += amount;
    saveCart();
    notifyListeners();
  }

  void decrementProduct(OrderItem item) {
    item.amount -= 1;
    if (item.amount < 1) {
      removeFromCart(item);
    }
    saveCart();
    notifyListeners();
  }

  void clear() {
    _cartItems.clear();
    saveCart();
    notifyListeners();
  }

  double get calculateTotalPrice {
    double totalPrice = 0.0;

    for (OrderItem item in _cartItems) {
      totalPrice += item.unitPrice * item.amount;
    }
    return totalPrice;
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartJson =
        cartItems.map((item) => json.encode(item.toJson())).toList();
    prefs.setStringList("cart_items", cartJson);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final savedItems = prefs.getStringList("cart_items") ?? [];
    for (var item in savedItems) {
      cartItems.add(OrderItem.fromJson(json.decode(item)));
    }
    notifyListeners();
  }

  Future<void> placeOrder() async {
    final orderDetails = [];
    for (var item in _cartItems) {
      orderDetails.add({"product_id": item.product.id, "amount": item.amount});
    }
    await makeOrder(orderDetails);
  }
}

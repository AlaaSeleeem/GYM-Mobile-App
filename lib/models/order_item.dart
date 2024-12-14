import 'product.dart';

class OrderItem {
  int? id;
  int? orderId;
  final Product product;
  int amount;

  OrderItem({
    this.id,
    this.orderId,
    required this.product,
    required this.amount,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['sale'],
      product: Product.fromJson(json['product']),
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sale': orderId,
      'product': product.toJson(),
      'amount': amount,
    };
  }

  double get unitPrice => product.discount != null
      ? product.sellPrice - ((product.discount! / 100) * product.sellPrice)
      : product.sellPrice;
}

import 'product.dart';

class OrderItem {
  final int id;
  final int saleId;
  final Product product;
  final int amount;

  OrderItem({
    required this.id,
    required this.saleId,
    required this.product,
    required this.amount,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      saleId: json['sale'],
      product: Product.fromJson(json['product']),
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sale': saleId,
      'product': product.toJson(),
      'amount': amount,
    };
  }
}

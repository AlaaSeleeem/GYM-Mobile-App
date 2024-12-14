import 'package:gymm/models/order_item.dart';

class Order {
  final int id;
  final String? clientId;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final double totalPrice;
  final double discount;
  final double afterDiscount;
  final String state;
  final List<OrderItem> items;

  Order(
      {required this.id,
      this.clientId,
      required this.createdAt,
      this.confirmedAt,
      required this.totalPrice,
      required this.discount,
      required this.afterDiscount,
      required this.state,
      required this.items});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        clientId: json['client_id'],
        createdAt: DateTime.parse(json['created_at']),
        confirmedAt: json['confirmed_at'] != null
            ? DateTime.parse(json['confirmed_at'])
            : null,
        totalPrice: double.parse(json['total_price']),
        discount: double.parse(json['discount']),
        afterDiscount: double.parse(json['after_discount']),
        state: json['state'],
        items: (json["items"] as List).map((item) => OrderItem.fromJson(item)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'created_at': createdAt.toIso8601String(),
      'confirmed_at': confirmedAt?.toIso8601String(),
      'total_price': totalPrice,
      'discount': discount,
      'after_discount': afterDiscount,
      'state': state,
      'items': items.map((item) => item.toJson())
    };
  }
}

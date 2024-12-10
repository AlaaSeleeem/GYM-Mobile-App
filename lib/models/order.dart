class Order {
  final int id;
  final int? customerId;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final double totalPrice;
  final double discount;
  final double afterDiscount;
  final String state;

  Order({
    required this.id,
    this.customerId,
    required this.createdAt,
    this.confirmedAt,
    required this.totalPrice,
    required this.discount,
    required this.afterDiscount,
    required this.state,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customer'],
      createdAt: DateTime.parse(json['created_at']),
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'])
          : null,
      totalPrice: (json['total_price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      afterDiscount: (json['after_discount'] as num).toDouble(),
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer': customerId,
      'created_at': createdAt.toIso8601String(),
      'confirmed_at': confirmedAt?.toIso8601String(),
      'total_price': totalPrice,
      'discount': discount,
      'after_discount': afterDiscount,
      'state': state,
    };
  }
}
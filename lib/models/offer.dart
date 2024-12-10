import 'product.dart';
import 'subscription_plan.dart';

class Offer {
  final int id;
  final String offerType;
  final double percentage;
  final DateTime startDate;
  final DateTime endDate;
  final Product? product;
  final SubscriptionPlan? plan;

  Offer({
    required this.id,
    required this.offerType,
    required this.percentage,
    required this.startDate,
    required this.endDate,
    this.product,
    this.plan,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      offerType: json['offer_type'],
      percentage: (json['percentage'] as num).toDouble(),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
      plan: json['plan'] != null
          ? SubscriptionPlan.fromJson(json['plan'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offer_type': offerType,
      'percentage': percentage,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'product': product?.toJson(),
      'plan': plan?.toJson(),
    };
  }
}

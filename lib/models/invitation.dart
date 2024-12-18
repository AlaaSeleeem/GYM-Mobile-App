import 'package:gymm/models/subscription.dart';

class Invitation {
  final int id;
  final String code;
  final Subscription? subscription;
  final bool isUsed;
  final DateTime createdAt;

  Invitation({
    required this.id,
    this.subscription,
    required this.code,
    required this.isUsed,
    required this.createdAt,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      id: json['id'],
      subscription: Subscription.fromJson(json['subscription']),
      code: json['code'],
      isUsed: json["is_used"],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

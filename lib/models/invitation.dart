class Invitation {
  final int id;
  final String code;

  // final Subscription? subscription;
  final bool isUsed;
  final bool isValid;
  final DateTime createdAt;
  final String? key;

  Invitation(
      {required this.id,
      // this.subscription,
      required this.code,
      required this.isUsed,
      required this.isValid,
      required this.createdAt,
      this.key});

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
        id: json['id'],
        // subscription: Subscription.fromJson(json['subscription']),
        code: json['code'],
        isUsed: json["is_used"],
        isValid: json["is_valid"],
        createdAt: DateTime.parse(json['created_at']),
        key: json['key']);
  }
}

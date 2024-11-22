class SubscriptionPlan {
  final int id;
  final String name;
  final double price;
  final int? days;
  final String subscriptionType;
  final String? description;
  final bool freezable;
  final int? freezeNo;
  final int invitations;
  final bool forStudents;
  final int validity;
  final bool isDuration;
  final int? classesNo;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    this.days,
    required this.subscriptionType,
    this.description,
    required this.freezable,
    this.freezeNo,
    required this.invitations,
    required this.forStudents,
    required this.validity,
    required this.isDuration,
    this.classesNo,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      days: json['days'],
      subscriptionType: json['subscription_type'],
      description: json['description'],
      freezable: json['freezable'] ?? false,
      freezeNo: json['freeze_no'],
      invitations: json['invitations'] ?? 0,
      forStudents: json['for_students'] ?? false,
      validity: json['validity'],
      isDuration: json['is_duration'] ?? true,
      classesNo: json['classes_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'days': days,
      'subscription_type': subscriptionType,
      'description': description,
      'freezable': freezable,
      'freeze_no': freezeNo,
      'invitations': invitations,
      'for_students': forStudents,
      'validity': validity,
      'is_duration': isDuration,
      'classes_no': classesNo,
    };
  }
}
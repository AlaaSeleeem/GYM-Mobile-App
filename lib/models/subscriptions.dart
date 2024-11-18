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

class Subscription {
  final int id;
  final String client;
  final SubscriptionPlan plan;
  final String? trainer;
  final String? referrer;
  final DateTime startDate;
  final DateTime? endDate;
  final int freezeDaysUsed;
  final DateTime? freezeStartDate;
  final bool isFrozen;
  final bool isExpired;
  final DateTime? unfreezeDate;
  final double totalPrice;
  final int attendanceDays;
  final int invitationsUsed;
  final String createdAt;
  final String? addedBy;

  Subscription({
    required this.id,
    required this.client,
    required this.plan,
    this.trainer,
    this.referrer,
    required this.startDate,
    this.endDate,
    required this.freezeDaysUsed,
    this.freezeStartDate,
    required this.isFrozen,
    required this.isExpired,
    this.unfreezeDate,
    required this.totalPrice,
    required this.attendanceDays,
    required this.invitationsUsed,
    required this.createdAt,
    this.addedBy,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      client: json['client_name'],
      plan: SubscriptionPlan.fromJson(json['plan']),
      trainer: json['trainer']['name'],
      referrer: json['referrer']['name'],
      startDate: DateTime.parse(json['start_date']),
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      freezeDaysUsed: json['freeze_days_used'],
      freezeStartDate: json['freeze_start_date'] != null
          ? DateTime.parse(json['freeze_start_date'])
          : null,
      isFrozen: json['is_frozen'],
      isExpired: json["is_expired"],
      unfreezeDate: json['unfreeze_date'] != null
          ? DateTime.parse(json['unfreeze_date'])
          : null,
      totalPrice: (json['total_price'] as num).toDouble(),
      attendanceDays: json['attendance_days'],
      invitationsUsed: json['invitations_used'],
      createdAt: json['created_at'],
      addedBy: json['added_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client': client,
      'plan': plan,
      'trainer_id': trainer,
      'referrer_id': referrer,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'freeze_days_used': freezeDaysUsed,
      'freeze_start_date': freezeStartDate?.toIso8601String(),
      'is_frozen': isFrozen,
      'unfreeze_date': unfreezeDate?.toIso8601String(),
      'total_price': totalPrice,
      'attendance_days': attendanceDays,
      'invitations_used': invitationsUsed,
      'created_at': createdAt,
      'added_by': addedBy,
    };
  }

  String remaining() {
    return plan.isDuration
        ? "Remaining: ${plan.days! - attendanceDays} Days"
        : "Remaining: ${plan.classesNo! - attendanceDays} Classes";
  }

  int daysLeft() {
    return plan.isDuration
        ? plan.days! - attendanceDays
        : plan.classesNo! - attendanceDays;
  }

  int totalDays() {
    return plan.isDuration ? plan.days! : plan.classesNo!;
  }
}

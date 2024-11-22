import 'package:gymm/models/subscription_plan.dart';

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
      trainer: json['trainer'] is String
          ? json["trainer"]
          : json["trainer"] is Map
              ? json["trainer"]["name"]
              : "",
      referrer: json['referrer'] is String
          ? json["referrer"]
          : json["referrer"] is Map
              ? json["referrer"]["name"]
              : "",
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
      'client_name': client,
      'plan': plan,
      'trainer': trainer,
      'referrer': referrer,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'freeze_days_used': freezeDaysUsed,
      'freeze_start_date': freezeStartDate?.toIso8601String(),
      'is_frozen': isFrozen,
      'is_expired': isExpired,
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

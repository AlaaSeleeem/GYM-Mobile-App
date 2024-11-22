import 'package:gymm/models/subscription.dart';
import 'package:gymm/models/subscription_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> saveClientData(Map data) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("client name", data["name"]);
  await prefs.setString("client id", data["id"].toString());
}

Future<void> removeClientData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("client name");
  await prefs.remove("client id");
}

Future<bool> isUserLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final String? name = prefs.getString("client name");
  return name != null;
}

Future<Map> getClientData() async {
  final prefs = await SharedPreferences.getInstance();
  final String? name = prefs.getString("client name");
  final String? id = prefs.getString("client id");
  return {"name": name, "id": id};
}

// storing/retrieving subscriptions
Future<void> saveClientSubscriptions(List<Subscription> subscriptions) async {
  final prefs = await SharedPreferences.getInstance();
  String subs = json.encode(subscriptions.map((sub) => sub.toJson()).toList());
  await prefs.setString("subscriptions", subs);
}

Future<List<Subscription>> getClientSubscriptions() async {
  final prefs = await SharedPreferences.getInstance();
  List list = json.decode(prefs.getString("subscriptions") ?? "[]");
  List<Subscription> subscriptions =
      list.map((sub) => Subscription.fromJson(sub)).toList();
  return subscriptions;
}

// storing/retrieving subscription plans
Future<void> saveSubscriptionPlans(
    List<SubscriptionPlan> subscriptionPlans) async {
  final prefs = await SharedPreferences.getInstance();
  String subs =
      json.encode(subscriptionPlans.map((sub) => sub.toJson()).toList());
  await prefs.setString("subscription_plans", subs);
}

Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
  final prefs = await SharedPreferences.getInstance();
  List list = json.decode(prefs.getString("subscription_plans") ?? "[]");
  List<SubscriptionPlan> subscriptions =
      list.map((sub) => SubscriptionPlan.fromJson(sub)).toList();
  return subscriptions;
}

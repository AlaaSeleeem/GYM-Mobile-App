import 'dart:io';
import 'package:gymm/api/actions.dart';
import 'package:gymm/models/subscription.dart';
import 'package:gymm/models/subscription_plan.dart';
import 'package:gymm/models/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> saveClientData(Map<String, dynamic> data,
    {bool downloadImage = true}) async {
  final prefs = await SharedPreferences.getInstance();
  if (downloadImage) await downloadAndSaveImage(data["photo"]);
  final clientJson = Client.fromJson(data).toJson();
  await prefs.setString("client", json.encode(clientJson));
}

Future<void> removeSessionData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("client");
  await prefs.remove("subscriptions");
  String? prevImage = prefs.getString("profile_image_path");
  await removeClientSavedPhoto(prevImage);
  await prefs.remove("profile_image_path");
  await prefs.remove("cart_items");
}

Future<void> removeClientSavedPhoto(String? filaPath) async {
  if (filaPath != null) {
    if (File(filaPath).existsSync()) {
      File(filaPath).deleteSync();
    }
  }
}

Future<bool> isUserLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final String? client = prefs.getString("client");
  return client != null;
}

Future<Client> getClientSavedData() async {
  final prefs = await SharedPreferences.getInstance();
  final String? clientJson = prefs.getString("client");
  final client = Client.fromJson(json.decode(clientJson!));
  return client;
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

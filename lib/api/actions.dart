import 'dart:convert';
import 'dart:io';
import 'package:gymm/api/endpoints.dart';
import 'package:gymm/api/exceptions.dart';
import 'package:gymm/models/client.dart';
import 'package:gymm/models/subscription.dart';
import 'package:gymm/models/subscription_plan.dart';
import 'package:gymm/utils/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future _apiRequest(
    {required String method,
    required String url,
    Map<String, dynamic>? data,
    Map<String, String>? headers}) async {
  final Map<String, String> defaultHeaders = {
    "Content-Type": "application/json"
  };

  final Map<String, String> requestHeaders =
      headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;

  try {
    http.Response response;
    switch (method.toLowerCase()) {
      case "get":
        response = await http
            .get(Uri.parse(url), headers: requestHeaders)
            .timeout(const Duration(seconds: 10));
        break;
      case "post":
        response = await http
            .post(Uri.parse(url),
                body: data != null ? json.encode(data) : null,
                headers: requestHeaders)
            .timeout(const Duration(seconds: 10));
        break;
      case "patch":
        response = await http
            .patch(Uri.parse(url),
                body: data != null ? json.encode(data) : null,
                headers: requestHeaders)
            .timeout(const Duration(seconds: 10));
        break;
      case "delete":
        response = await http
            .delete(Uri.parse(url),
                body: data != null ? json.encode(data) : null,
                headers: requestHeaders)
            .timeout(const Duration(seconds: 10));
        break;
      default:
        throw ArgumentError("Unsupported request method");
    }

    final decodedResponse = utf8.decode(latin1.encode(response.body));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(decodedResponse);
    } else {
      throw ClientErrorException(
          statusCode: response.statusCode,
          responseBody: json.decode(decodedResponse));
    }
  } catch (e) {
    return Future.error(e);
  }
}

// change client personal information
Future<void> updateClientData(String id, Map<String, dynamic> data) async {
  try {
    await _apiRequest(
        method: "patch", url: EndPoints.clientDetail(id), data: data);
  } catch (e) {
    return Future.error(e);
  }
}

// download client photo
downloadAndSaveImage(String? url) async {
  if (url == null) return;
  try {
    // Get the directory to save the image
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final prefs = await SharedPreferences.getInstance();

    // Download the image
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Remove prev image if found
      String? prevImage = prefs.getString("profile_image_path");
      await removeClientSavedPhoto(prevImage);

      // Save the image to a file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Save the file path in shared preferences
      await prefs.setString('profile_image_path', filePath);

      return filePath;
    } else if (response.statusCode == 404) {
      await prefs.remove("profile_image_path");
    } else {
      throw Exception("error downloading photo");
    }
  } catch (e) {
    throw Exception('Error downloading image: $e');
  }
}

Future<Client> getClientData(String id) async {
  try {
    final response = await _apiRequest(
        method: "post", url: EndPoints.clientData(), data: {"id": id});

    await saveClientData(response);
    final client = Client.fromJson(response);
    return client;
  } catch (e) {
    return Future.error(e);
  }
}

// get latest subscriptions -> home page preview
Future<List<Subscription>> getLatestSubscriptions(int id) async {
  try {
    final response = await _apiRequest(
      method: "post",
      url: EndPoints.clientLatestSubscriptions(),
      data: {"id": id},
    );
    List<Subscription> subs =
        (response as List).map(((sub) => Subscription.fromJson(sub))).toList();
    saveClientSubscriptions(subs);
    return subs;
  } catch (e) {
    return Future.error(e);
  }
}

// get subscription plans
Future<(List<SubscriptionPlan>, bool)> getSubscriptionPlans(int page) async {
  try {
    final response = await _apiRequest(
        method: "get", url: EndPoints.subscriptionPlans(page));
    List<SubscriptionPlan> subs = (response["results"] as List)
        .map(((sub) => SubscriptionPlan.fromJson(sub)))
        .toList();
    final bool next = response["next"] != null;
    return (subs, next);
  } catch (e) {
    return Future.error(e);
  }
}

// get subscription plans
Future<(List<Subscription>, bool)> getClientSubscriptionsHistory(
    int id, int page) async {
  try {
    final response = await _apiRequest(
        method: "get", url: EndPoints.clientSubscriptionsHistory(id, page));
    List<Subscription> subs = (response["results"] as List)
        .map(((sub) => Subscription.fromJson(sub)))
        .toList();
    final bool next = response["next"] != null;
    return (subs, next);
  } catch (e) {
    return Future.error(e);
  }
}

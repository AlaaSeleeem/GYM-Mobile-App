import 'dart:convert';
import 'dart:io';
import 'package:gymm/api/endpoints.dart';
import 'package:gymm/api/exceptions.dart';
import 'package:gymm/models/category.dart';
import 'package:gymm/models/client.dart';
import 'package:gymm/models/invitation.dart';
import 'package:gymm/models/news.dart';
import 'package:gymm/models/order.dart';
import 'package:gymm/models/product.dart';
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

    // decode response to preserve arabic character
    final decodedResponse = response.body.isNotEmpty
        ? utf8.decode(latin1.encode(response.body))
        : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedResponse != null
          ? json.decode(decodedResponse)
          : response.body;
    } else {
      throw ClientErrorException(
          statusCode: response.statusCode,
          responseBody: decodedResponse != null
              ? json.decode(decodedResponse)
              : response.body);
    }
  } catch (e) {
    return Future.error(e);
  }
}

// change client personal information
Future<void> updateClientData(String id, Map<String, dynamic> data,
    {Map<String, String>? headers}) async {
  try {
    await _apiRequest(
        method: "patch",
        url: EndPoints.clientDetail(id),
        data: data,
        headers: headers);
  } catch (e) {
    return Future.error(e);
  }
}

// change client personal information
Future<Map<String, dynamic>> uploadRequestedPhoto(String id, File photo) async {
  try {
    // Create the request
    var request =
        http.MultipartRequest('PATCH', Uri.parse(EndPoints.clientDetail(id)));

    // Add the photo file to the request
    var photoFile =
        await http.MultipartFile.fromPath('requested_photo', photo.path);
    request.files.add(photoFile);

    // Send the request
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    // Check the response status
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(responseBody);
    } else {
      throw Exception("Failed uploading image");
    }
  } catch (e) {
    return Future.error(e);
  }
}

// change client personal information
Future<void> changeClientPassword(Map<String, dynamic> data) async {
  try {
    await _apiRequest(
        method: "post", url: EndPoints.changeClientPassword(), data: data);
  } catch (e) {
    return Future.error(e);
  }
}

// delete requested photo
Future<void> deleteRequestedPhoto(Map<String, dynamic> data) async {
  try {
    await _apiRequest(
        method: "post", url: EndPoints.deleteRequestedPhoto(), data: data);
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

// get subscription invitations
Future<List<Invitation>> getSubscriptionInvitations(int subId) async {
  try {
    final response = await _apiRequest(
      method: "post",
      url: EndPoints.subscriptionInvitations(),
      data: {"sub_id": subId},
    );
    List<Invitation> invitations = (response["invitations"] as List)
        .map(((inv) => Invitation.fromJson(inv)))
        .toList();
    return invitations;
  } catch (e) {
    return Future.error(e);
  }
}

// delete invitation
Future<void> deleteInvitation(int id) async {
  try {
    await _apiRequest(method: "delete", url: EndPoints.invitation(id));
  } catch (e) {
    return Future.error(e);
  }
}

// create new invitation
Future<void> createInvitation(int subId) async {
  try {
    final data = {"sub_id": subId};
    await _apiRequest(
        method: "post", url: EndPoints.createInvitation(), data: data);
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

// get subscription history
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

// get news
Future<(List<News>, bool)> getNews(int page) async {
  try {
    final response =
        await _apiRequest(method: "get", url: EndPoints.news(page));
    List<News> news = (response["results"] as List)
        .map(((sub) => News.fromJson(sub)))
        .toList();
    final bool next = response["next"] != null;
    return (news, next);
  } catch (e) {
    return Future.error(e);
  }
}

// get products categories
Future<List<Category>> getCategories() async {
  try {
    final response =
        await _apiRequest(method: "get", url: EndPoints.categories());
    List<Category> categories = (response as List)
        .map(((category) => Category.fromJson(category)))
        .toList();
    return categories;
  } catch (e) {
    return Future.error(e);
  }
}

// get products
Future<(List<Product>, bool)> getProducts(
    int page, String search, String category) async {
  try {
    final response = await _apiRequest(
        method: "get", url: EndPoints.products(page, search, category));
    List<Product> products = (response["results"] as List)
        .map(((product) => Product.fromJson(product)))
        .toList();
    final bool next = response["next"] != null;
    return (products, next);
  } catch (e) {
    return Future.error(e);
  }
}

// get orders history
Future<(List<Order>, bool)> getOrdersHistory(int page, String clientId) async {
  try {
    final response =
        await _apiRequest(method: "get", url: EndPoints.orders(page, clientId));
    List<Order> subs = (response["results"] as List)
        .map(((sub) => Order.fromJson(sub)))
        .toList();
    final bool next = response["next"] != null;
    return (subs, next);
  } catch (e) {
    return Future.error(e);
  }
}

// remove order
Future<void> removeOrder(int id) async {
  try {
    await _apiRequest(method: "delete", url: EndPoints.order(id));
  } catch (e) {
    return Future.error(e);
  }
}

// change client personal information
Future<void> makeOrder(
  List orderDetails,
) async {
  try {
    String clientId = (await getClientSavedData()).id!;
    final data = {"client_id": clientId, "items": orderDetails};
    await _apiRequest(method: "post", url: EndPoints.makeOrder(), data: data);
  } catch (e) {
    return Future.error(e);
  }
}

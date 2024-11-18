import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserData(Map data) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("client name", data["name"]);
  await prefs.setString("client id", data["id"].toString());
}

Future<bool> isUserLoggedIn () async {
  final prefs = await SharedPreferences.getInstance();
  final String? name = prefs.getString("client name");
  return name != null;
}

import 'package:flutter/material.dart';
import 'package:gymm/components/loading.dart';
import 'package:gymm/theme/colors.dart';
import '../screens/login_screen.dart';
import '../utils/preferences.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  bool _loading = false;

  Future<void> _logout() async {
    setState(() {
      _loading = true;
    });
    await removeSessionData();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()));
  }

  void _showLogoutDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: blackColor[900],
              content: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "Are you sure?",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              icon: const Icon(
                Icons.info_outline,
                color: primaryColor,
                size: 44,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      _logout();
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red[500],
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Loading()
        : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: _showLogoutDialog,
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red[500]),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)))),
                child: const Text(
                  "Log out",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      height: 3.25,
                      fontWeight: FontWeight.w500),
                )),
          );
  }
}

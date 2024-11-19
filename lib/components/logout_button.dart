import 'package:flutter/material.dart';

import '../login.dart';
import '../utils/prefrences.dart';

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
    await removeClientData();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Column(
            children: [
              SizedBox(
                height: 16,
              ),
              CircularProgressIndicator(),
              SizedBox(
                height: 16,
              )
            ],
          )
        : SizedBox(
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: _logout,
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.red[500]),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)))),
                    child: const Text(
                      "Log out",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          height: 3.25,
                          fontWeight: FontWeight.w500),
                    ))),
          );
  }
}

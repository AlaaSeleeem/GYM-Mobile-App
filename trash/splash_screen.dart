import 'package:flutter/material.dart';
import 'package:gymm/screens/main_screen.dart';
import 'package:gymm/screens/login_screen.dart';
import 'package:gymm/utils/preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    final bool logged = await isUserLoggedIn();
    if (logged) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        // child: Placeholder(),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gymm/profile_screen.dart';
import 'package:gymm/providers/Cart.dart';
import 'package:gymm/sign%20in.dart';
import 'package:provider/provider.dart';

import 'MainPage.dart';
import 'QRscan.dart';
import 'Store.dart';
import 'login.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => Cart(),
      child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => MainPage(),
        //  "/home": (context) => HomeScreen(),
      },
    );
  }
}
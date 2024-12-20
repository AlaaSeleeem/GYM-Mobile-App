import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gymm/screens/main_screen.dart';
import 'package:gymm/screens/login_screen.dart';
import 'package:gymm/providers/Cart.dart';
import 'package:gymm/theme/dark_theme.dart';
import 'package:gymm/utils/preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(ChangeNotifierProvider(
      create: (context) => Cart(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _logged = false;

  @override
  void initState() {
    super.initState();
    _initialization();
  }

  void _initialization() async {
    await _checkLoginState();
    final cart = Provider.of<Cart>(context, listen: false);
    await cart.loadCart();
    FlutterNativeSplash.remove();
  }

  Future<void> _checkLoginState() async {
    final bool logged = await isUserLoggedIn();
    if (logged) {
      setState(() {
        _logged = true;
      });
    } else {
      setState(() {
        _logged = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => _logged ? const MainPage() : const LoginScreen(),
      },
      // builder: (context, child) {
      //   // Remove top padding globally
      //   return MediaQuery(
      //     data: MediaQuery.of(context).copyWith(padding: EdgeInsets.zero),
      //     child: child!,
      //   );
      // },
    );
  }
}

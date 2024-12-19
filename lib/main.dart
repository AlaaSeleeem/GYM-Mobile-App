import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gymm/screens/main_screen.dart';
import 'package:gymm/screens/login_screen.dart';
import 'package:gymm/providers/Cart.dart';
import 'package:gymm/theme/dark_theme.dart';
import 'package:gymm/utils/preferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  Locale locale = await getSavedLocale();
  runApp(ChangeNotifierProvider(
      create: (context) => Cart(), child: MyApp(initialLocale: locale)));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.initialLocale});

  final Locale initialLocale;

  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late Locale locale;
  bool _logged = false;

  void setLocale(Locale local) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    setState(() {
      locale = local;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      locale = widget.initialLocale;
    });
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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale("en"),
        Locale("ar"),
      ],
      locale: locale,
    );
  }
}

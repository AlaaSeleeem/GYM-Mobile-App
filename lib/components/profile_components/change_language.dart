import 'package:flutter/material.dart';
import 'package:gymm/theme/colors.dart';

import '../../main.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  late Locale _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = MyApp.of(context)!.locale;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        decoration: BoxDecoration(
          color: blackColor[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ExpansionTile(
          shape: Border.all(color: Colors.transparent),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.language, color: primaryColor),
              SizedBox(width: 10),
              Text(
                "Change Language",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  RadioListTile<Locale>(
                    title: const Text('العربية'),
                    value: const Locale('ar'),
                    groupValue: _currentLocale,
                    selected: _currentLocale.languageCode == "ar",
                    onChanged: (locale) {
                      setState(() {
                        _currentLocale = locale!;
                      });
                      MyApp.of(context)?.setLocale(_currentLocale);
                    },
                  ),
                  RadioListTile<Locale>(
                    title: const Text('English'),
                    value: const Locale('en'),
                    groupValue: _currentLocale,
                    selected: _currentLocale.languageCode == "en",
                    onChanged: (locale) {
                      setState(() {
                        _currentLocale = locale!;
                      });
                      MyApp.of(context)?.setLocale(_currentLocale);
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

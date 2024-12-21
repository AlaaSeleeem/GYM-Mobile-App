import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymm/theme/colors.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar(
      {super.key,
      this.selectedItemColor,
      required this.index,
      required this.onTab});

  final Color? selectedItemColor;
  final int index;

  final Function(int) onTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: blackColor[900]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: BottomNavigationBar(
            backgroundColor: blackColor[900],
            selectedItemColor: selectedItemColor ?? primaryColor,
            unselectedItemColor: Colors.white,
            currentIndex: index,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(FontAwesomeIcons.house),
                  label: AppLocalizations.of(context)!.home),
              BottomNavigationBarItem(
                  icon: const Icon(FontAwesomeIcons.barcode),
                  label: AppLocalizations.of(context)!.scan),
              BottomNavigationBarItem(
                  icon: const Icon(FontAwesomeIcons.user),
                  label: AppLocalizations.of(context)!.profile),
              BottomNavigationBarItem(
                  icon: const Icon(FontAwesomeIcons.store),
                  label: AppLocalizations.of(context)!.store),
            ],
            onTap: onTab),
      ),
    );
  }
}

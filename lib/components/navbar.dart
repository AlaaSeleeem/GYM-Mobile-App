import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.house), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.barcode), label: 'Scan'),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.user), label: 'Profile'),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.store), label: 'Store'),
            ],
            onTap: onTab),
      ),
    );
  }
}

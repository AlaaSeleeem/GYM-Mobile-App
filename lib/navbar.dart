import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymm/navigation.dart';
import 'package:gymm/theme/colors.dart';
import 'MainPage.dart';
import 'QRscan.dart';
import 'Store.dart';
import 'profile_screen.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key, this.selectedItemColor});

  final Color? selectedItemColor;
  static int index = 0;

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
                  icon: Icon(FontAwesomeIcons.barcode), label: 'Barcode'),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.user), label: 'Profile'),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.store), label: 'Store'),
            ],
            onTap: (value) {
              if (value == 0) {
                index = value;
                goTO(context: context, screen: MainPage());
              } else if (value == 1) {
                index = value;
                goTO(context: context, screen: QRCodeScreen());
              } else if (value == 2) {
                index = value;
                goTO(context: context, screen: ProfileScreen());
              } else if (value == 3) {
                index = value;
                goTO(context: context, screen: ProductsPage());
              }
            }),
      ),
    );
  }
}

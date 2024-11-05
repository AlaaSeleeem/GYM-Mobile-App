import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymm/navigation.dart';
import 'MainPage.dart';
import 'QRscan.dart';
import 'Store.dart';
import 'profile_screen.dart';

class BottonNavBar extends StatelessWidget {
  BottonNavBar({super.key, this.selectedItemColor});

  Color? selectedItemColor;
  static int index = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BottomNavigationBar(
          backgroundColor: Color.fromARGB(1000, 18, 18, 18),
          selectedItemColor: selectedItemColor ?? Colors.yellow,
          unselectedItemColor: Colors.white,
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.house), label: ''),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.qrcode), label: ''),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user), label: ''),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.store), label: ''),
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
    );
  }
}

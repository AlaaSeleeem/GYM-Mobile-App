import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  final Function onTabSelected;
  const BottomNavBar({super.key, required this.onTabSelected,});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: 0,
      items: const [
        Icon(Icons.add, size: 20),
        Icon(FontAwesomeIcons.house, size: 20),
        Icon(FontAwesomeIcons.qrcode, size: 20),
        Icon(FontAwesomeIcons.userGroup, size: 20),
        Icon(FontAwesomeIcons.user, size: 20),
      ],
      color: Colors.white,
      buttonBackgroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(1000, 142, 151, 253),
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 200),
      onTap: (value) {
        widget.onTabSelected(value);
        // widget.onTabSelected(value);
      },
      letIndexChange: (index) => true,
    );
  }
}

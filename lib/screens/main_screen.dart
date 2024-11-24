import 'package:flutter/material.dart';
import 'package:gymm/screens/scan_screen.dart';
import 'package:gymm/Store.dart';
import 'package:gymm/screens/profile_screen.dart';
import 'package:gymm/screens/home_screen.dart';
import '../components/navbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ScanPage(),
    const ProfilePage(),
    const ProductsPage(),
  ];

  void _changePage(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentPage == 0) {
          return true;
        } else {
          setState(() {
            _currentPage = 0;
          });
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _pages[_currentPage],
        bottomNavigationBar: BottomNavbar(
          onTab: _changePage,
          index: _currentPage,
        ),
      ),
    );
  }
}

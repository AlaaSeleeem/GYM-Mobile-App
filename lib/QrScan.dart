import 'package:flutter/material.dart';
import 'nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    print("before render");
  }

  final List<Widget> _pages = [
    Center(child: Text('Add Page')),
    Center(child: Text('Home Page')),
    SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 142, 151, 253),
          width: double.infinity,
          height: 1400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Expanded(
                  child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(
                    'img.png',
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  ClipRRect(
                    child: Image.asset(
                      'img_1.png',
                      fit: BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  )
                ],
              )),
              SizedBox(height: 200),
            ],
          ),
        ),
      ),
    ),
    Center(child: Text('Group Page')),
    Center(child: Text('User Profile Page')),
  ];

  void _changeCurrentPage(int tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: SizedBox(
                width: 40, height: 40, child: CircularProgressIndicator()),
          )
        : Scaffold(
            body: _pages[_selectedTab],
            bottomNavigationBar: BottomNavBar(
              onTabSelected: _changeCurrentPage
            ),
          );
  }
}

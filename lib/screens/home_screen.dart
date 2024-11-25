import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/components/loading.dart';
import 'package:gymm/components/multiple_subscriptions.dart';
import 'package:gymm/components/no_active_subscriptions.dart';
import 'package:gymm/models/subscription.dart';
import 'package:gymm/screens/exercises_screen.dart';
import 'package:gymm/screens/news_screen.dart';
import 'package:gymm/screens/plans_screen.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/preferences.dart';
import 'package:gymm/utils/snack_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // top bar states
  String name = "";
  String id = "";

  // subscriptions section states
  List<Subscription> subscriptions = [];
  bool loadingSubs = true;

  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getClientData();
    _startAutoSlider();
    _loadSavedSubscriptions();
  }

  void _startAutoSlider() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      setState(() {
        _currentPage;
      });
    });
  }

  Future<void> _getClientData() async {
    Map data = await getClientData();
    setState(() {
      name = data["name"];
      id = data["id"];
    });
  }

  Future<void> _loadSavedSubscriptions() async {
    List<Subscription> saved = await getClientSubscriptions();
    if (saved.isNotEmpty) {
      setState(() {
        subscriptions = saved;
        loadingSubs = false;
      });
    }
    try {
      await _getPreviewLatestSubscriptions();
    } finally {
      setState(() {
        loadingSubs = false;
      });
    }
  }

  Future<void> _getPreviewLatestSubscriptions() async {
    try {
      final data = await getLatestSubscriptions(int.parse(id));
      setState(() {
        subscriptions = data;
      });
    } catch (e) {
      showSnackBar(context, "Failed loading subscriptions", "error");
      return Future.error(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getPreviewLatestSubscriptions,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // header
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, top: 30.0, right: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: const TextStyle(
                                  color: primaryColor, fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            id,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Image.asset('assets/logo1.jpeg', height: 100),
                  ],
                ),
              ),

              // carousel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    initialPage: _currentPage,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                  items: [
                    'assets/offer1.jfif',
                    'assets/offer2.jfif',
                  ].map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 40),

              // active subscription
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Subscriptions',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              loadingSubs
                  ? const Loading(
                      height: 300,
                    )
                  : _renderActiveSubscriptions(subscriptions),

              const SizedBox(height: 40),

              // Quick Access
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Access',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSquareButton(
                          label: 'Plans',
                          icon: Icons.subscriptions,
                          page: const PlansPage()),
                      _buildSquareButton(
                          label: 'News',
                          icon: Icons.newspaper,
                          page: const NewsPage()),
                      _buildSquareButton(
                          label: 'Exercises',
                          icon: Icons.fitness_center,
                          page: const ExercisesPage()),
                      _buildSquareButton(
                          label: 'Contact',
                          icon: Icons.call,
                          page: PlansPage()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquareButton(
      {required String label, required IconData icon, required Widget page}) {
    return Container(
      width: 170,
      height: 120,
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => page));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black, size: 40),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

Widget _renderActiveSubscriptions(List<Subscription> subscriptions) {
  if (subscriptions.isEmpty) {
    return const NoActiveSubscription();
  } else {
    return MultipleSubscriptions(subscriptions: subscriptions);
  }
}

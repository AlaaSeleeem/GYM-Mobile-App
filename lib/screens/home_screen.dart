import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  Timer? _timer;
  late AnimationController _controller;
  late Animation<double> _animation;

  int totalDays = 30;
  int daysUsed = 12;
  int daysLeft = 0;

  DateTime subscriptionStartDate = DateTime.now().subtract(Duration(days: 10));
  DateTime subscriptionEndDate = DateTime.now().add(Duration(days: 20));

  List<String> subscriptionTypes = ["Premium Plan", "Basic Plan"];
  String selectedSubscriptionType = "Premium Plan";

  // المتغيرات لتخزين تقييمات الأسئلة
  int _serviceRating = 0;
  int _trainerRating = 0;
  int _scheduleRating = 0;
  int _equipmentRating = 0;
  int _staffRating = 0;
  String _feedbackNotes = '';

  @override
  void initState() {
    super.initState();
    _startAutoSlider();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    daysLeft = totalDays - daysUsed;
    _updateSubscriptionDetails();
  }

  void _startAutoSlider() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
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

  void _updateSubscriptionDetails() {
    if (selectedSubscriptionType == "Premium Plan") {
      totalDays = 30;
      daysUsed = 12;
      subscriptionStartDate = DateTime.now().subtract(Duration(days: 10));
      subscriptionEndDate = DateTime.now().add(Duration(days: 20));
    } else {
      totalDays = 15;
      daysUsed = 5;
      subscriptionStartDate = DateTime.now().subtract(Duration(days: 5));
      subscriptionEndDate = DateTime.now().add(Duration(days: 10));
    }
    daysLeft = totalDays - daysUsed;

    _animation = Tween<double>(begin: 0.0, end: daysUsed.toDouble() / totalDays)
        .animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, Mohammed',
                          style: TextStyle(color: Colors.yellow, fontSize: 24),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Client Code: 123456',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Image.asset('assets/logo1.jpeg', height: 100),
                  ],
                ),
              ),
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
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subscription Data',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    DropdownButton<String>(
                      value: selectedSubscriptionType,
                      dropdownColor: Colors.grey[900],
                      items: subscriptionTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type, style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSubscriptionType = newValue!;
                          _updateSubscriptionDetails();
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return SizedBox(
                                height: 250,
                                width: 250,
                                child: CircularProgressIndicator(
                                  value: _animation.value,
                                  backgroundColor: Colors.grey[800],
                                  valueColor: AlwaysStoppedAnimation<Color>(daysLeft <= 0
                                      ? Colors.red
                                      : (daysUsed >= totalDays * 0.9 ? Colors.red : Colors.yellow)),
                                ),
                              );
                            },
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                selectedSubscriptionType,
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Subscription Code: XYZ123',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Remaining Days: $daysLeft',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                  fontSize: 16,
                                ),
                              ),
                              if (daysLeft <= 0)
                                Column(
                                  children: [
                                    SizedBox(height: 8),
                                    Text(
                                      'Please renew your subscription',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    SizedBox(height: 4),
                                    Icon(
                                      Icons.notifications,
                                      color: Colors.red,
                                      size: 24,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSquareButton('Schedule', Icons.access_time),
                      _buildSquareButton('Exercises', Icons.fitness_center),
                      _buildSquareButton('Survey', Icons.list),
                      _buildSquareButton('Contact', Icons.contact_phone),
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

  Widget _buildSquareButton(String label, IconData icon) {
    return Container(
      width: 170,
      height: 120,
      margin: EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          if (label == 'Survey') {
            _showSurveyDialog();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black, size: 40),
            SizedBox(height: 8),
            Text(label, style: TextStyle(color: Colors.black, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _showSurveyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Text(
                'Rate Our Service',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    // أسئلة التقييم
                    _buildRatingQuestion('Service', _serviceRating, (int value) {
                      setState(() {
                        _serviceRating = value;
                      });
                    }),
                    _buildRatingQuestion('Trainer', _trainerRating, (int value) {
                      setState(() {
                        _trainerRating = value;
                      });
                    }),
                    _buildRatingQuestion('Schedule', _scheduleRating, (int value) {
                      setState(() {
                        _scheduleRating = value;
                      });
                    }),
                    _buildRatingQuestion('Equipment', _equipmentRating, (int value) {
                      setState(() {
                        _equipmentRating = value;
                      });
                    }),
                    _buildRatingQuestion('Staff', _staffRating, (int value) {
                      setState(() {
                        _staffRating = value;
                      });
                    }),

                    // خانة الملاحظات
                    TextField(
                      onChanged: (text) {
                        _feedbackNotes = text;
                      },
                      decoration: InputDecoration(
                        labelText: 'Additional Notes',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // هنا يمكنك إضافة كود لحفظ التقييم في قاعدة البيانات
                    print('Service Rating: $_serviceRating');
                    print('Trainer Rating: $_trainerRating');
                    print('Schedule Rating: $_scheduleRating');
                    print('Equipment Rating: $_equipmentRating');
                    print('Staff Rating: $_staffRating');
                    print('Feedback Notes: $_feedbackNotes');

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRatingQuestion(String question, int currentRating, ValueChanged<int> onRatingChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(color: Colors.white),
        ),
        Row(
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < currentRating ? Icons.star : Icons.star_border,
                color: Colors.yellow,
              ),
              onPressed: () {
                onRatingChanged(index + 1);
              },
            );
          }),
        ),
      ],
    );
  }
}

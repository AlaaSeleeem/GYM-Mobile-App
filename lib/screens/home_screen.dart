import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gymm/components/circular_subscription.dart';
import 'package:gymm/components/multiple_subscriptions.dart';
import 'package:gymm/components/no_active_subscriptions.dart';
import 'package:gymm/models/subscriptions.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/prefrences.dart';

List subscription1 = [
  {
    "id": 4603,
    "url": "http://127.0.0.1:8000/api/subscriptions/subscription/4603/",
    "plan": {
      "id": 28,
      "url": "http://127.0.0.1:8000/api/subscriptions/subscription-plan/28/",
      "sub_type": "اشتراك أساسى",
      "duration_display": "210 يوم",
      "num_subscriptions": null,
      "name": "6 شهور +30",
      "price": 1300.0,
      "days": 210,
      "subscription_type": "main",
      "description": "6 شهور +30",
      "freezable": false,
      "freeze_no": null,
      "invitations": 0,
      "for_students": false,
      "validity": 210,
      "is_duration": true,
      "classes_no": null
    },
    "trainer": {
      "id": 2,
      "nationality": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/nationality/1/",
        "name": "مصرى"
      },
      "marital_status": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/marital-status/1/",
        "name": "أعزب"
      },
      "city": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/city/1/",
        "name": "شبين الكوم"
      },
      "district": null,
      "added_by": {
        "id": 1,
        "username": "ahmed",
        "name": "Dev",
        "phone": "***********",
        "national_id": "**************",
        "is_superuser": true,
        "is_moderator": false,
        "url": "http://127.0.0.1:8000/api/users/users/1/",
        "is_root": true
      },
      "emp_type": {
        "id": 2,
        "url": "http://127.0.0.1:8000/api/users/employee-type/2/",
        "name": "ريسيبشن"
      },
      "url": "http://127.0.0.1:8000/api/users/employee/2/",
      "name": "ألاء",
      "gander": "female",
      "religion": "muslim",
      "birth_date": null,
      "age": 21,
      "phone": "0100",
      "phone2": "",
      "national_id": "0200",
      "address": "",
      "email": "",
      "photo": null
    },
    "referrer": {
      "id": 3,
      "nationality": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/nationality/1/",
        "name": "مصرى"
      },
      "marital_status": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/marital-status/1/",
        "name": "أعزب"
      },
      "city": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/city/1/",
        "name": "شبين الكوم"
      },
      "district": null,
      "added_by": {
        "id": 2,
        "username": "kaffo",
        "name": "Manager",
        "phone": "01147617485",
        "national_id": "01147617485",
        "is_superuser": true,
        "is_moderator": false,
        "url": "http://127.0.0.1:8000/api/users/users/2/",
        "is_root": false
      },
      "emp_type": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/employee-type/1/",
        "name": "مدرب"
      },
      "url": "http://127.0.0.1:8000/api/users/employee/3/",
      "name": "عبد الرحمن اسامة رمزي",
      "gander": "male",
      "religion": "muslim",
      "birth_date": "2003-07-14",
      "age": 21,
      "phone": "01095414508",
      "phone2": "",
      "national_id": "1221",
      "address": "شبين",
      "email": "",
      "photo": null
    },
    "client_name": "ahmed hatem",
    "client_id": "5000",
    "is_expired": false,
    "added_by": "Dev",
    "created_at": "2024-11-19 - 00:17:57",
    "start_date": "2024-11-19",
    "end_date": "2025-06-17",
    "freeze_days_used": 0,
    "freeze_start_date": null,
    "is_frozen": false,
    "unfreeze_date": null,
    "total_price": 1300.0,
    "attendance_days": 0,
    "invitations_used": 0,
    "client": 4126,
    "transaction": 802
  }
];
List subscription2 = [
  {
    "id": 4603,
    "url": "http://127.0.0.1:8000/api/subscriptions/subscription/4603/",
    "plan": {
      "id": 28,
      "url": "http://127.0.0.1:8000/api/subscriptions/subscription-plan/28/",
      "sub_type": "اشتراك أساسى",
      "duration_display": "210 يوم",
      "num_subscriptions": null,
      "name": "6 شهور +30",
      "price": 1300.0,
      "days": 210,
      "subscription_type": "main",
      "description": "6 شهور +30",
      "freezable": false,
      "freeze_no": null,
      "invitations": 0,
      "for_students": false,
      "validity": 210,
      "is_duration": true,
      "classes_no": null
    },
    "trainer": {
      "id": 2,
      "nationality": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/nationality/1/",
        "name": "مصرى"
      },
      "marital_status": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/marital-status/1/",
        "name": "أعزب"
      },
      "city": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/city/1/",
        "name": "شبين الكوم"
      },
      "district": null,
      "added_by": {
        "id": 1,
        "username": "ahmed",
        "name": "Dev",
        "phone": "***********",
        "national_id": "**************",
        "is_superuser": true,
        "is_moderator": false,
        "url": "http://127.0.0.1:8000/api/users/users/1/",
        "is_root": true
      },
      "emp_type": {
        "id": 2,
        "url": "http://127.0.0.1:8000/api/users/employee-type/2/",
        "name": "ريسيبشن"
      },
      "url": "http://127.0.0.1:8000/api/users/employee/2/",
      "name": "ألاء",
      "gander": "female",
      "religion": "muslim",
      "birth_date": null,
      "age": 21,
      "phone": "0100",
      "phone2": "",
      "national_id": "0200",
      "address": "",
      "email": "",
      "photo": null
    },
    "referrer": {
      "id": 3,
      "nationality": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/nationality/1/",
        "name": "مصرى"
      },
      "marital_status": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/marital-status/1/",
        "name": "أعزب"
      },
      "city": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/city/1/",
        "name": "شبين الكوم"
      },
      "district": null,
      "added_by": {
        "id": 2,
        "username": "kaffo",
        "name": "Manager",
        "phone": "01147617485",
        "national_id": "01147617485",
        "is_superuser": true,
        "is_moderator": false,
        "url": "http://127.0.0.1:8000/api/users/users/2/",
        "is_root": false
      },
      "emp_type": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/employee-type/1/",
        "name": "مدرب"
      },
      "url": "http://127.0.0.1:8000/api/users/employee/3/",
      "name": "عبد الرحمن اسامة رمزي",
      "gander": "male",
      "religion": "muslim",
      "birth_date": "2003-07-14",
      "age": 21,
      "phone": "01095414508",
      "phone2": "",
      "national_id": "1221",
      "address": "شبين",
      "email": "",
      "photo": null
    },
    "client_name": "ahmed hatem",
    "client_id": "5000",
    "is_expired": false,
    "added_by": "Dev",
    "created_at": "2024-11-19 - 00:17:57",
    "start_date": "2024-11-19",
    "end_date": "2025-06-17",
    "freeze_days_used": 0,
    "freeze_start_date": null,
    "is_frozen": false,
    "unfreeze_date": null,
    "total_price": 1300.0,
    "attendance_days": 0,
    "invitations_used": 0,
    "client": 4126,
    "transaction": 802
  },
  {
    "id": 4604,
    "url": "http://127.0.0.1:8000/api/subscriptions/subscription/4604/",
    "plan": {
      "id": 14,
      "url": "http://127.0.0.1:8000/api/subscriptions/subscription-plan/14/",
      "sub_type": "اشتراك أساسى",
      "duration_display": "8 حصص",
      "num_subscriptions": null,
      "name": "٨ سيشن",
      "price": 200.0,
      "days": null,
      "subscription_type": "main",
      "description": "",
      "freezable": false,
      "freeze_no": null,
      "invitations": 0,
      "for_students": false,
      "validity": 30,
      "is_duration": false,
      "classes_no": 8
    },
    "trainer": {
      "id": 2,
      "nationality": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/nationality/1/",
        "name": "مصرى"
      },
      "marital_status": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/marital-status/1/",
        "name": "أعزب"
      },
      "city": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/city/1/",
        "name": "شبين الكوم"
      },
      "district": null,
      "added_by": {
        "id": 1,
        "username": "ahmed",
        "name": "Dev",
        "phone": "***********",
        "national_id": "**************",
        "is_superuser": true,
        "is_moderator": false,
        "url": "http://127.0.0.1:8000/api/users/users/1/",
        "is_root": true
      },
      "emp_type": {
        "id": 2,
        "url": "http://127.0.0.1:8000/api/users/employee-type/2/",
        "name": "ريسيبشن"
      },
      "url": "http://127.0.0.1:8000/api/users/employee/2/",
      "name": "ألاء",
      "gander": "female",
      "religion": "muslim",
      "birth_date": null,
      "age": 21,
      "phone": "0100",
      "phone2": "",
      "national_id": "0200",
      "address": "",
      "email": "",
      "photo": null
    },
    "referrer": {
      "id": 3,
      "nationality": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/nationality/1/",
        "name": "مصرى"
      },
      "marital_status": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/marital-status/1/",
        "name": "أعزب"
      },
      "city": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/city/1/",
        "name": "شبين الكوم"
      },
      "district": null,
      "added_by": {
        "id": 2,
        "username": "kaffo",
        "name": "Manager",
        "phone": "01147617485",
        "national_id": "01147617485",
        "is_superuser": true,
        "is_moderator": false,
        "url": "http://127.0.0.1:8000/api/users/users/2/",
        "is_root": false
      },
      "emp_type": {
        "id": 1,
        "url": "http://127.0.0.1:8000/api/users/employee-type/1/",
        "name": "مدرب"
      },
      "url": "http://127.0.0.1:8000/api/users/employee/3/",
      "name": "عبد الرحمن اسامة رمزي",
      "gander": "male",
      "religion": "muslim",
      "birth_date": "2003-07-14",
      "age": 21,
      "phone": "01095414508",
      "phone2": "",
      "national_id": "1221",
      "address": "شبين",
      "email": "",
      "photo": null
    },
    "client_name": "ahmed hatem",
    "client_id": "5000",
    "is_expired": false,
    "added_by": "Dev",
    "created_at": "2024-11-19 - 00:19:08",
    "start_date": "2024-11-19",
    "end_date": "2024-12-19",
    "freeze_days_used": 0,
    "freeze_start_date": null,
    "is_frozen": false,
    "unfreeze_date": null,
    "total_price": 200.0,
    "attendance_days": 0,
    "invitations_used": 0,
    "client": 4126,
    "transaction": 803
  }
];

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

  int _currentPage = 0;
  Timer? _timer;

  List<Subscription> subscriptions = [];

  List<String> subscriptionTypes = ["Premium Plan", "Basic Plan"];
  String selectedSubscriptionType = "Basic Plan";

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
    _getClientData();
    _startAutoSlider();
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

  Future<void> _getClientData() async {
    Map data = await getClientData();
    setState(() {
      name = data["name"];
      id = data["id"];
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // header
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
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
                                  color: primaryColor, fontSize: 24),
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
                      'Active Subscriptions',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              _renderActiveSubscriptions(subscription2
                  .map((item) => Subscription.fromJson(item))
                  .toList()),
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
                    _buildRatingQuestion('Service', _serviceRating,
                        (int value) {
                      setState(() {
                        _serviceRating = value;
                      });
                    }),
                    _buildRatingQuestion('Trainer', _trainerRating,
                        (int value) {
                      setState(() {
                        _trainerRating = value;
                      });
                    }),
                    _buildRatingQuestion('Schedule', _scheduleRating,
                        (int value) {
                      setState(() {
                        _scheduleRating = value;
                      });
                    }),
                    _buildRatingQuestion('Equipment', _equipmentRating,
                        (int value) {
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

  Widget _buildRatingQuestion(
      String question, int currentRating, ValueChanged<int> onRatingChanged) {
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

Widget _renderActiveSubscriptions(List<Subscription> subscriptions) {
  if (subscriptions.isEmpty) return const NoActiveSubscription();

  if (subscriptions.length > 1) {
    return MultipleSubscriptions(subscriptions: subscriptions);
  } else {
    return CircularSubscription(subscription: subscriptions.first);
  }
}

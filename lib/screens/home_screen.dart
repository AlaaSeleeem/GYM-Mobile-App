// home_page.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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
              // رأس الصفحة مع اللوجو والترحيب
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
                          style: TextStyle(color: Colors.yellow, fontSize: 24), // نص الترحيب
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Client Code: 123456',
                          style: TextStyle(color: Colors.white), // عرض كود العميل
                        ),
                      ],
                    ),
                    Image.asset('assets/logo1.jpeg', height: 100), // عرض اللوجو
                  ],
                ),
              ),
              // السلايدر للعروض
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    initialPage: _currentPage, // الصفحة الأولية
                    autoPlay: true, // التمرير التلقائي
                    autoPlayInterval: Duration(seconds: 3), // مدة الانتظار بين الصفحات
                    autoPlayAnimationDuration: Duration(milliseconds: 800), // مدة الأنيميشن
                    enlargeCenterPage: true, // تكبير الصفحة الوسطى
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index; // تحديث الصفحة الحالية
                      });
                    },
                  ),
                  items: [
                    'assets/offer1.jfif', // الصورة الأولى
                    'assets/offer2.jfif', // الصورة الثانية
                  ].map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8), // الهامش بين العناصر
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12), // الزوايا المدورة
                            image: DecorationImage(
                              image: AssetImage(image), // تحميل الصورة
                              fit: BoxFit.cover, // ملء المساحة
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 40),
              // عنوان بيانات الاشتراك
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
                          _updateSubscriptionDetails(); // تحديث التفاصيل عند تغيير النوع
                        });
                      },
                    ),
                  ],
                ),
              ),
              // دائرة LinearProgressIndicator
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12), // الزوايا المدورة
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 250, // عرض الدائرة
                      height: 250, // ارتفاع الدائرة
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // قطر الدائرة مع الحركة
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return SizedBox(
                                height: 250,
                                width: 250,
                                child: CircularProgressIndicator(
                                  value: _animation.value, // استخدام القيمة المتغيرة
                                  backgroundColor: Colors.grey[800], // لون الخلفية
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    daysLeft <= 0
                                        ? Colors.red // عند انتهاء الاشتراك
                                        : (daysUsed >= totalDays * 0.9
                                        ? Colors.red // عند الاقتراب من الانتهاء
                                        : Colors.yellow), // لون عادي
                                  ),
                                ),
                              );
                            },
                          ),
                          // محتوى الدائرة
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                selectedSubscriptionType, // نوع الاشتراك
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Subscription Code: XYZ123', // كود الاشتراك
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              // عدد الأيام المتبقية
                              Text(
                                'Remaining Days: $daysLeft', // عدد الأيام المتبقية
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow, // تغيير اللون إلى الأصفر
                                  fontSize: 16,
                                ),
                              ),
                              // إضافة رسالة تجديد الباقة في حالة انتهاء الاشتراك
                              if (daysLeft <= 0)
                                Column(
                                  children: [
                                    SizedBox(height: 8),
                                    Text(
                                      'Please renew your subscription', // رسالة التجديد
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
              // مربعات التواريخ مع إطار أصفر
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // محاذاة للوسط
                  children: [
                    _buildDateBox('Start Date', subscriptionStartDate.toLocal().toString().split(' ')[0]), // تاريخ البداية
                    SizedBox(width: 16), // مسافة بين المربعات
                    _buildDateBox('End Date', subscriptionEndDate.toLocal().toString().split(' ')[0]), // تاريخ البداية
                  ],
                ),
              ),
              // الأزرار مع التمرير الأفقي
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // التمرير الأفقي
                  child: Row(
                    children: [
                      _buildSquareButton('Schedule', Icons.access_time),
                      _buildSquareButton('Exercises', Icons.fitness_center),
                      _buildSquareButton('List', Icons.list),
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

  // دالة لبناء مربعات التواريخ
  Widget _buildDateBox(String label, String date) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow, width: 2), // حدود صفراء
        borderRadius: BorderRadius.circular(8), // الزوايا المدورة
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label, // عنوان التاريخ
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            date, // التاريخ
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // دالة لبناء الأزرار المربعة
  Widget _buildSquareButton(String label, IconData icon) {
    return Container(
      width: 170, // عرض الزر
      height: 120, // ارتفاع الزر
      margin: EdgeInsets.all(8), // الهوامش حول الزر
      child: ElevatedButton(
        onPressed: () {}, // يمكن إضافة الإجراء هنا
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow, // لون الخلفية
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // شكل الزر
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black), // أيقونة الزر
            SizedBox(height: 8),
            Text(label, style: TextStyle(color: Colors.black)), // نص الزر
          ],
        ),
      ),
    );
  }
}

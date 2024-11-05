import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gymm/screens/home_screen.dart';
import 'FINALbuttonNAVbar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  int _currentPage = 0; // المتغير لتتبع الصفحة الحالية في السلايدر
  Timer? _timer; // المؤقت للتمرير التلقائي
  late AnimationController _controller; // للتحكم في الحركة
  late Animation<double> _animation; // لتحديد قيمة الحركة

  // متغيرات الاشتراك
  int totalDays = 30; // إجمالي عدد الأيام للاشتراك
  int daysUsed = 12; // عدد الأيام المستخدمة
  int daysLeft = 0; // عدد الأيام المتبقية

  // تواريخ الاشتراك
  DateTime subscriptionStartDate = DateTime.now().subtract(Duration(days: 10)); // تاريخ البداية
  DateTime subscriptionEndDate = DateTime.now().add(Duration(days: 20)); // تاريخ النهاية

  // أنواع الاشتراك
  List<String> subscriptionTypes = ["Premium Plan", "Basic Plan"];
  String selectedSubscriptionType = "Premium Plan";

  @override
  void initState() {
    super.initState();
    _startAutoSlider(); // بدء التمرير التلقائي للسلايدر

    // إعداد AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // مدة الحركة
      vsync: this, // لتوفير الإيقاف المتزامن
    );

    // حساب الأيام المتبقية
    daysLeft = totalDays - daysUsed;
    _updateSubscriptionDetails(); // تحديث التفاصيل عند بدء التشغيل
  }

  // دالة لبدء التمرير التلقائي للسلايدر
  void _startAutoSlider() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 1) {
        _currentPage++; // الانتقال إلى الصفحة التالية
      } else {
        _currentPage = 0; // إعادة تعيين الصفحة عند الوصول للنهاية
      }
      setState(() {
        _currentPage; // تحديث الصفحة
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

    // تحديث الحركة
    _animation = Tween<double>(begin: 0.0, end: daysUsed.toDouble() / totalDays).animate(_controller);
    _controller.forward(); // بدء الحركة
  }

  @override
  void dispose() {
    _timer?.cancel(); // إلغاء المؤقت عند التخلص من الواجهة
    _controller.dispose(); // التخلص من AnimationController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black, // خلفية الصفحة
        body: HomePage(),
        bottomNavigationBar: BottonNavBar(), // شريط التنقل السفلي
      ),
    );
  }
}

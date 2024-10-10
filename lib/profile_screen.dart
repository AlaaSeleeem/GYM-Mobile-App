import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'FINALbuttonNAVbar.dart';
import 'action button.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller; // متحكم في الحركة
  late Animation<double> _animation; // متغير الحركة
  final int totalDays = 30; // إجمالي الأيام
  final int daysUsed = 12; // الأيام المستهلكة
  late double progress; // نسبة الاستهلاك

  @override
  void initState() {
    super.initState();
    progress = 0.0; // بدء النسبة من الصفر

    _controller = AnimationController(
      duration: const Duration(seconds: 2), // مدة الحركة
      vsync: this,
    )..addListener(() {
      setState(() {
        progress = _animation.value; // تحديث قيمة النسبة
      });
    });

    _animation = Tween<double>(begin: 0.0, end: daysUsed / totalDays).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // منحنى الحركة
    ));

    _controller.forward(); // بدء الحركة
  }

  @override
  void dispose() {
    _controller.dispose(); // التخلص من المتحكم
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int daysLeft = totalDays - daysUsed; // الأيام المتبقية

    return SafeArea(
      bottom: true,
      left: true,
      top: true,
      right: true,
      maintainBottomViewPadding: true,
      minimum: EdgeInsets.zero,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.yellow,
            ),
            onPressed: () {
              Navigator.pop(context); // العودة إلى الشاشة السابقة
            },
          ),
          title: Text(
            'Profile', // عنوان الشاشة
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset('logo1.jpeg', height: 120), // شعار التطبيق
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              CircleAvatar(
                backgroundImage: AssetImage('user.jpg'), // صورة الملف الشخصي
                radius: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Username Here', // اسم المستخدم
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // عرض مدة الاشتراك
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 34, 34, 34),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subscription Duration', // عنوان قسم مدة الاشتراك
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    // مؤشر الاستهلاك مع الحركة
                    LinearProgressIndicator(
                      value: progress, // نسبة الاستهلاك
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        daysLeft <= 0
                            ? Colors.red // إذا انتهت الأيام، يظهر باللون الأحمر
                            : (progress >= 0.9
                            ? Colors.red // إذا كان الاستهلاك أكثر من 90%
                            : Colors.yellow), // خلاف ذلك يظهر باللون الأصفر
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Days left: $daysLeft', // عرض عدد الأيام المتبقية
                      style: TextStyle(color: daysLeft < 2 ? Colors.red : Colors.white),
                    ),
                    if (daysLeft <= 0) ...[
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red), // أيقونة التحذير
                          SizedBox(width: 8),
                          Text(
                            'Please Renew Subscription!', // رسالة تجديد الاشتراك
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // بيانات المتدرب
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 34, 34, 34),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information', // عنوان قسم المعلومات الشخصية
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Table(
                      columnWidths: {
                        0: FractionColumnWidth(0.4),
                        1: FractionColumnWidth(0.6),
                      },
                      children: [
                        TableRow(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person, color: Colors.yellow), // أيقونة الاسم
                                SizedBox(width: 8),
                                Text('Name:', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Text('Username', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        TableRow(
                          children: [
                            Container(height: 8),
                            Container(height: 8),
                          ],
                        ),
                        TableRow(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.card_membership, color: Colors.yellow), // أيقونة الاشتراك
                                SizedBox(width: 8),
                                Text('Subscription:', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Text('Premium', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        TableRow(
                          children: [
                            Container(height: 8),
                            Container(height: 8),
                          ],
                        ),
                        TableRow(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.lock, color: Colors.yellow), // أيقونة القفل
                                SizedBox(width: 8),
                                Text('Locker:', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Text('A12', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        TableRow(
                          children: [
                            Container(height: 8),
                            Container(height: 8),
                          ],
                        ),
                        TableRow(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.trending_up, color: Colors.yellow), // أيقونة البيانات الجسمية
                                SizedBox(width: 8),
                                Text('Body Stats:', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Text('70kg', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        TableRow(
                          children: [
                            Container(height: 8),
                            Container(height: 8),
                          ],
                        ),
                        // إضافة كود العميل
                        TableRow(
                          children: [
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.barcode, color: Colors.yellow), // أيقونة كود العميل
                                SizedBox(width: 8),
                                Text('Client Code:', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Text('123456', style: TextStyle(color: Colors.white)), // كود العميل
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // الإعدادات
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 34, 34, 34),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings', // عنوان قسم الإعدادات
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, color: Colors.black), // أيقونة الإعدادات
                          SizedBox(width: 8),
                          Text('Account Settings', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications, color: Colors.black), // أيقونة الإشعارات
                          SizedBox(width: 8),
                          Text('Notification Settings', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.help, color: Colors.black), // أيقونة المساعدة
                          SizedBox(width: 8),
                          Text('Help & Support', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
        bottomNavigationBar: BottonNavBar(),
        extendBody: true,
      ),
    );
  }
}

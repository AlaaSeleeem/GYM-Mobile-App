import 'dart:io';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymm/components/logout_button.dart';
import 'package:gymm/login.dart';
import 'package:gymm/utils/prefrences.dart';
import 'package:image_picker/image_picker.dart';
import 'navbar.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final int totalDays = 30;
  final int daysUsed = 12;
  late double progress;

  bool isAccountExpanded = false;
  bool isNotificationsExpanded = false;
  bool isHelpExpanded = false;
  bool notificationsEnabled = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;
  String? _imageName;

  bool _isPasswordEmpty = false;
  bool _isNewPasswordEmpty = false;
  bool _isEmailEmpty = false;
  bool _isUsernameEmpty = false;
  bool _obscurePassword = true;
  bool _obscureNewPassword = true;

  @override
  void initState() {
    super.initState();
    progress = 0.0;

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          progress = _animation.value;
        });
      });

    _animation = Tween<double>(begin: 0.0, end: daysUsed / totalDays)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _imageName = image.name;
      });
    }
  }

  alidateAndSubmit() {
    setState(() {
      _isPasswordEmpty = _passwordController.text.isEmpty;
      _isNewPasswordEmpty = _newPasswordController.text.isEmpty;
      _isEmailEmpty = _emailController.text.isEmpty;
      _isUsernameEmpty = _usernameController.text.isEmpty;
    });

    if (!_isPasswordEmpty &&
        !_isNewPasswordEmpty &&
        !_isEmailEmpty &&
        !_isUsernameEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        customHeader: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.yellow,
          ),
          child: Icon(
            Icons.check,
            color: Colors.black,
            size: 90,
          ),
        ),
        title: 'Submission Successful',
        desc: 'Your changes have been submitted and are awaiting confirmation.',
        btnOkOnPress: () {},
        btnOkColor: Colors.yellow,
        dialogBackgroundColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.yellow),
        descTextStyle:
        TextStyle(color: Colors.white, fontSize: 16), // تأكد من حجم النص
        // autoHide: Duration(seconds: 2), // إزالة هذه السطر لاختبار
      ).show();
    }
  }

  void _validateAndSubmit() {
    setState(() {
      _isPasswordEmpty = _passwordController.text.isEmpty;
      _isNewPasswordEmpty = _newPasswordController.text.isEmpty;
      _isEmailEmpty = _emailController.text.isEmpty;
      _isUsernameEmpty = _usernameController.text.isEmpty;
    });

    if (!_isPasswordEmpty &&
        !_isNewPasswordEmpty &&
        !_isEmailEmpty &&
        !_isUsernameEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        customHeader: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.yellow,
          ),
          child: Icon(Icons.check, color: Colors.black, size: 90),
        ),
        title: 'Submission Successful',
        desc: 'Your changes have been submitted and are awaiting confirmation.',
        btnOkOnPress: () {
          // إعادة تعيين الحقول والصورة هنا
          _passwordController.clear();
          _newPasswordController.clear();
          _emailController.clear();
          _usernameController.clear();
          setState(() {
            _image = null; // مسح الصورة
            _imageName = null; // إعادة تعيين اسم الصورة
          });
        },
        btnOkColor: Colors.yellow,
        dialogBackgroundColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.yellow),
        descTextStyle: TextStyle(color: Colors.white, fontSize: 16),
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    int daysLeft = totalDays - daysUsed;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.yellow),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Profile', style: TextStyle(color: Colors.white)),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset('assets/logo1.jpeg', height: 120),
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
            backgroundImage: _image != null
                ? FileImage(_image!)
                : AssetImage('assets/user.jpg') as ImageProvider,
            radius: 100,
          ),
          SizedBox(height: 20),
          Text(
            'Username Here',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
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
                  'Subscription Duration',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    daysLeft <= 0
                        ? Colors.red
                        : (progress >= 0.9 ? Colors.red : Colors.yellow),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Days left: $daysLeft',
                  style: TextStyle(
                      color: daysLeft < 2 ? Colors.red : Colors.white),
                ),
                if (daysLeft <= 0) ...[
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Please Renew Subscription!',
                          style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ],
              ],
            ),
          ),
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
                  'Personal Information',
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
                            Icon(Icons.person, color: Colors.yellow),
                            SizedBox(width: 8),
                            Text('Name:',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Text('Username',
                            style: TextStyle(color: Colors.white)),
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
                            Icon(Icons.card_membership,
                                color: Colors.yellow),
                            SizedBox(width: 8),
                            Text('Subscription:',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Text('Premium',
                            style: TextStyle(color: Colors.white)),
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
                            Icon(Icons.lock, color: Colors.yellow),
                            SizedBox(width: 8),
                            Text('Locker:',
                                style: TextStyle(color: Colors.white)),
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
                            Icon(Icons.trending_up, color: Colors.yellow),
                            SizedBox(width: 8),
                            Text('Body Stats:',
                                style: TextStyle(color: Colors.white)),
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
                    TableRow(
                      children: [
                        Row(
                          children: [
                            Icon(FontAwesomeIcons.barcode,
                                color: Colors.yellow),
                            SizedBox(width: 8),
                            Text('Client Code:',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Text('123456',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAccountExpanded = !isAccountExpanded;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.yellow),
                          SizedBox(width: 8),
                          Text('Account Settings',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18)),
                        ],
                      ),
                      Icon(
                          isAccountExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.white),
                    ],
                  ),
                ),
                if (isAccountExpanded) ...[
                  SizedBox(height: 10),
                  Text('Change Password',
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'Enter your current password',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: _isPasswordEmpty ? 'Required' : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text('New Password',
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'Enter your new password',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: _isNewPasswordEmpty ? 'Required' : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text('Email', style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Enter your email',
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'example@domain.com',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: _isEmailEmpty ? 'Required' : null,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text('New Username',
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Enter new username',
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'Enter new username',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: _isUsernameEmpty ? 'Required' : null,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text('Change Profile Picture',
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow),
                    child: Text('Upload Image'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _imageName != null
                        ? 'Selected Image: $_imageName'
                        : 'No image selected',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow),
                    child: Text('Submit'),
                  ),
                ],
              ],
            ),
          ),
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isNotificationsExpanded =
                      !isNotificationsExpanded; // تغيير حالة التوسيع
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notifications, color: Colors.yellow),
                          SizedBox(width: 8),
                          Text('Notification Settings',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18)),
                        ],
                      ),
                      Icon(
                          isNotificationsExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.white),
                    ],
                  ),
                ),
                if (isNotificationsExpanded) ...[
                  SwitchListTile(
                    title: Text('Enable Notifications',
                        style: TextStyle(color: Colors.white)),
                    value: notificationsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        notificationsEnabled =
                            value; // تغيير حالة الإشعارات
                      });
                    },
                    activeColor: Colors.yellow,
                    inactiveTrackColor:
                    Colors.grey, // لون الخلفية عند إيقاف التشغيل
                  ),
                ],
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 34, 34, 34),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isHelpExpanded = !isHelpExpanded;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.help, color: Colors.yellow),
                            SizedBox(width: 8),
                            Text('Help & Support',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ],
                        ),
                        Icon(
                            isHelpExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: Colors.white),
                      ],
                    ),
                  ),
                  if (isHelpExpanded) ...[
                    SizedBox(height: 10),

                    // Gym Information
                    ExpansionTile(
                      title: Text('Gym Information',
                          style: TextStyle(color: Colors.white)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Founded in 2020, our gym aims to provide an ideal sporting environment.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    // Frequently Asked Questions
                    ExpansionTile(
                      title: Text('Frequently Asked Questions',
                          style: TextStyle(color: Colors.white)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            '1. What are the operating hours?\n2. Are there group classes?\n3. How can I register?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    // Contact Information
                    ExpansionTile(
                      title: Text('Contact Information',
                          style: TextStyle(color: Colors.white)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.email, color: Colors.yellow),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text('Email: info@gym.com',
                                        style:
                                        TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.phone, color: Colors.yellow),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text('Phone: 123456789',
                                        style:
                                        TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: Colors.yellow),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text('Address: Gym Street, City',
                                        style:
                                        TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  // Open Google Maps
                                },
                                child: Text('View on Google Maps',
                                    style: TextStyle(color: Colors.yellow)),
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                spacing: 20, // المسافة بين الأيقونات
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      // اضف الرابط الخاص بفيسبوك
                                    },
                                    icon: Icon(FontAwesomeIcons.facebook,
                                        color: Colors.yellow),
                                    label: Text('Facebook',
                                        style:
                                        TextStyle(color: Colors.white)),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      // اضف الرابط الخاص بانستغرام
                                    },
                                    icon: Icon(FontAwesomeIcons.instagram,
                                        color: Colors.yellow),
                                    label: Text('Instagram',
                                        style:
                                        TextStyle(color: Colors.white)),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      // اضف الرابط الخاص بتويتر
                                    },
                                    icon: Icon(FontAwesomeIcons.twitter,
                                        color: Colors.yellow),
                                    label: Text('Twitter',
                                        style:
                                        TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const LogoutButton()
          ],
        ),
      ),
      extendBody: true,
    ),);
  }
}

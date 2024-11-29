import 'dart:io';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/components/loading.dart';
import 'package:gymm/components/logout_button.dart';
import 'package:gymm/components/profile_components/change_password.dart';
import 'package:gymm/components/profile_components/personal_information.dart';
import 'package:gymm/models/client.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/preferences.dart';
import 'package:gymm/utils/snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  Client? client;

  // handle photo
  bool loadingPhoto = false;
  FileImage? clientPhoto;

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
    _getClientData();
  }

  _getClientData() async {
    Client savedClient = await getClientSavedData();
    setState(() {
      client = savedClient;
    });
    try {
      _getClientPhoto();
    } catch (e) {
      showSnackBar(context, "Error loading data", "error");
    }
  }

  Future _onRefresh() async {
    if (client != null) {
      try {
        Client newClient = await getClientData(client!.id!);
        setState(() {
          client = newClient;
        });
        _getClientPhoto();
      } catch (e) {
        showSnackBar(context, "Error refreshing data", "error");
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  _getClientPhoto() async {
    setState(() {
      loadingPhoto = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String? photoPath = prefs.getString("profile_image_path");
    if (photoPath != null) {
      // Clear Flutter's image cache
      PaintingBinding.instance.imageCache.clear();

      setState(() {
        clientPhoto = FileImage(File(photoPath));
      });
    } else {
      setState(() {
        clientPhoto = null;
      });
    }
    setState(() {
      loadingPhoto = false;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _imageName = image.name;
      });
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: client == null
          ? const Center(child: Loading())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // profile photo
                        const SizedBox(height: 65),
                        CircleAvatar(
                          backgroundImage: loadingPhoto ? null : clientPhoto,
                          // No background image if photoUrl is null
                          radius: 100,
                          child: loadingPhoto
                              ? const Center(
                                  child: Loading(
                                  height: 200,
                                ))
                              : clientPhoto == null
                                  ? const Icon(
                                      Icons.person_rounded,
                                      size:
                                          130, // Adjust the size of the fallback icon
                                      color:
                                          primaryColor, // Optional icon color
                                    )
                                  : null, // No child if there's a background image
                        ),

                        // client name
                        const SizedBox(height: 20),
                        Text(
                          client!.name!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),

                        // personal info
                        const SizedBox(height: 20),
                        PersonalInformation(
                          client: client!,
                        ),

                        // change password
                        const SizedBox(height: 20),
                        const ChangePasswordForm(),

                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.person,
                                            color: Colors.yellow),
                                        SizedBox(width: 8),
                                        Text('Account Settings',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18)),
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
                                    errorText:
                                        _isPasswordEmpty ? 'Required' : null,
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
                                    errorText:
                                        _isNewPasswordEmpty ? 'Required' : null,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          _obscureNewPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey),
                                      onPressed: () {
                                        setState(() {
                                          _obscureNewPassword =
                                              !_obscureNewPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 10),
                                Text('Email',
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(height: 5),
                                TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter your email',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    hintText: 'example@domain.com',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    errorText:
                                        _isEmailEmpty ? 'Required' : null,
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
                                    errorText:
                                        _isUsernameEmpty ? 'Required' : null,
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
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.notifications,
                                            color: Colors.yellow),
                                        SizedBox(width: 8),
                                        Text('Notification Settings',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18)),
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
                                  inactiveTrackColor: Colors
                                      .grey, // لون الخلفية عند إيقاف التشغيل
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.help,
                                              color: Colors.yellow),
                                          SizedBox(width: 8),
                                          Text('Help & Support',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18)),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.email,
                                                    color: Colors.yellow),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                      'Email: info@gym.com',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Icon(Icons.phone,
                                                    color: Colors.yellow),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                      'Phone: 123456789',
                                                      style: TextStyle(
                                                          color: Colors.white)),
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
                                                  child: Text(
                                                      'Address: Gym Street, City',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            TextButton(
                                              onPressed: () {
                                                // Open Google Maps
                                              },
                                              child: Text('View on Google Maps',
                                                  style: TextStyle(
                                                      color: Colors.yellow)),
                                            ),
                                            SizedBox(height: 10),
                                            Wrap(
                                              spacing:
                                                  20, // المسافة بين الأيقونات
                                              children: [
                                                TextButton.icon(
                                                  onPressed: () {
                                                    // اضف الرابط الخاص بفيسبوك
                                                  },
                                                  icon: Icon(
                                                      FontAwesomeIcons.facebook,
                                                      color: Colors.yellow),
                                                  label: Text('Facebook',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                                TextButton.icon(
                                                  onPressed: () {
                                                    // اضف الرابط الخاص بانستغرام
                                                  },
                                                  icon: Icon(
                                                      FontAwesomeIcons
                                                          .instagram,
                                                      color: Colors.yellow),
                                                  label: Text('Instagram',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                                TextButton.icon(
                                                  onPressed: () {
                                                    // اضف الرابط الخاص بتويتر
                                                  },
                                                  icon: Icon(
                                                      FontAwesomeIcons.twitter,
                                                      color: Colors.yellow),
                                                  label: Text('Twitter',
                                                      style: TextStyle(
                                                          color: Colors.white)),
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
                        const SizedBox(height: 20),
                        const LogoutButton()
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

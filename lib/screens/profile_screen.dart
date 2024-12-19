import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/components/loading.dart';
import 'package:gymm/components/logout_button.dart';
import 'package:gymm/components/profile_components/change_language.dart';
import 'package:gymm/components/profile_components/change_password.dart';
import 'package:gymm/components/profile_components/change_photo.dart';
import 'package:gymm/components/profile_components/personal_information.dart';
import 'package:gymm/models/client.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/preferences.dart';
import 'package:gymm/utils/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ChangePhotoState> childKey = GlobalKey<ChangePhotoState>();
  Client? client;

  // handle photo
  bool loadingPhoto = false;
  FileImage? clientPhoto;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  CancelableOperation? _currentOperation;

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

  Future<Client?> _refreshClientData() async {
    if (client != null) {
      String clientId = client!.id!;
      if (client is Client) {
        client!.resetRequestedPhoto();
      }
      Client newClient = await getClientData(clientId);
      _getClientPhoto();
      return newClient;
    }
    return null;
  }

  Future<void> _onRefresh() async {
    _currentOperation?.cancel();
    _currentOperation = CancelableOperation.fromFuture(_refreshClientData());

    await _currentOperation!.value.then((newClient) {
      if (mounted) {
        setState(() {
          client = newClient;
        });
        childKey.currentState?.updateWidget(client);
      }
    }).catchError((e) {
      if (mounted) {
        showSnackBar(context, "Error refreshing data", "error");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _currentOperation?.cancel();
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
                        ChangePasswordForm(client: client),

                        // change photo
                        const SizedBox(height: 20),
                        ChangePhoto(
                          key: childKey,
                          client: client,
                        ),

                        // change photo
                        const SizedBox(height: 20),
                        const ChangeLanguage(),

                        // logout button
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

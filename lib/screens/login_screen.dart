import 'package:flutter/material.dart';
import 'package:gymm/screens/main_screen.dart';
import 'package:gymm/api/endpoints.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/globals.dart';
import 'package:gymm/utils/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var id = TextEditingController();
  var password = TextEditingController();
  var passwordNode = FocusNode();
  var formKey = GlobalKey<FormState>();

  bool isHidden = true;
  bool isLoading = false;
  String? errorMessage;

  final String phoneNumber = "1234567890";
  final String message = "Hello there!";

  void _openWhatsApp() async {
    final Uri url = Uri.parse(
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
    await launchUrl(url);
  }

  Future<void> _login() async {
    setState(() {
      errorMessage = null;
    });

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      final response = await http
          .post(Uri.parse(EndPoints.login()),
              headers: {"Content-Type": "application/json"},
              body: json.encode({"id": id.text, "password": password.text}))
          .timeout(const Duration(seconds: 10));

      final decodedResponse = utf8.decode(latin1.encode(response.body));
      final data = json.decode(decodedResponse);

      if (response.statusCode == 200) {
        firstInitialization = true;
        await saveClientData(data);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
      } else {
        setState(() {
          errorMessage = json.decode(response.body)["error"];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Authentication Failed";
      });
    } finally {
      setState(() {
        isLoading = false;
        id.clear();
        password.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          // resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            // constraints: BoxConstraints(maxWidth: 600),
                            // width: double.infinity,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/logo1.jpeg',
                                    width: 250,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "PRO GYM",
                                        style: TextStyle(
                                            color: primaryColor[300],
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  TextFormField(
                                    validator: (value) {
                                      if ((value == null || value.isEmpty)) {
                                        return "ID can't be empty";
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (value) {
                                      passwordNode.requestFocus();
                                    },
                                    controller: id,
                                    keyboardType: TextInputType.number,
                                    cursorErrorColor: Colors.red,
                                    cursorHeight: 30,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        height: 2,
                                        fontWeight: FontWeight.normal),
                                    decoration: const InputDecoration(
                                        label: Text(
                                          'ID',
                                        ),
                                        hintText: "Number on barcode card"),
                                  ),

                                  const SizedBox(
                                    height: 30,
                                  ),

                                  // password text field
                                  TextFormField(
                                    validator: (value) {
                                      if ((value == null || value.isEmpty)) {
                                        return "Password can't be empty";
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (value) {
                                      _login();
                                    },
                                    focusNode: passwordNode,
                                    controller: password,
                                    obscureText: isHidden,
                                    keyboardType: TextInputType.visiblePassword,
                                    cursorHeight: 30,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        height: 2,
                                        fontWeight: FontWeight.normal),
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: isHidden == true
                                              ? Icon(
                                                  Icons.lock,
                                                  color: blackColor[300],
                                                )
                                              : Icon(
                                                  Icons.lock_open,
                                                  color: blackColor[300],
                                                ),
                                          onPressed: () {
                                            setState(() {
                                              isHidden = !isHidden;
                                            });
                                          },
                                        ),
                                        label: const Text(
                                          'Password',
                                        ),
                                        hintText: "Default: phone number"),
                                  ),

                                  const SizedBox(
                                    height: 45,
                                  ),

                                  //========================================================================
                                  Text(
                                    errorMessage ?? "",
                                    style: TextStyle(
                                        color: Colors.red[400],
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  isLoading
                                      ? const CircularProgressIndicator()
                                      : SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _login();
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      primaryColor[400]),
                                              shape: WidgetStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                              ),
                                            ),
                                            child: const Text('LOG IN',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20,
                                                  height: 3.25,
                                                )),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 50,
                                  ),

                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 8,
                                        runSpacing: 4,
                                        runAlignment: WrapAlignment.center,
                                        children: [
                                          Text('DON\'T HAVE AN ACCOUNT?',
                                              style: TextStyle(
                                                  color: blackColor[300],
                                                  fontSize: 16)),
                                          TextButton(
                                            onPressed: () {
                                              _openWhatsApp();
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              alignment: Alignment.center,
                                              minimumSize: const Size(0, 0),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            child: const Text('Contact PRO GYM',
                                                style: TextStyle(
                                                    color: Colors.yellow,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17)),
                                          ),
                                        ]),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}

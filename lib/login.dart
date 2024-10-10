import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'Onboarding.dart';
import 'sign in.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var email = TextEditingController();

  var password = TextEditingController();

  var formKey = GlobalKey<FormState>();

  var passwordNode = FocusNode();

  bool isHidden = true;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    const tokenURL = "https://kaffogym.pythonanywhere.com/token/";
    try {
      final response = await http.post(Uri.parse(tokenURL),
          headers: {"Content-Type": "application/json"},
          body:
              json.encode({"username": email.text, "password": password.text}));

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        final access_token = data["access"];
        final refresh_token = data["refresh"];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) =>
                SignUpScreen()),
          ),
        );
        print(access_token);

        print(refresh_token);
        Navigator.of(context).pushReplacementNamed("/home");
      } else {
        setState(() {
          errorMessage = data["detail"];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Authentication Failed";
      });
    } finally {
      setState(() {
        isLoading = false;
        email.clear();
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
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Container(
              width: double.infinity,
              child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'logo1.jpeg', // استبدل بمسار الصورة
                      width: 150,
                      height: 150,
                    ),
                    Text('Welcome back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          height: 1.4,
                          fontWeight: FontWeight.w700,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('login to get active',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              height: 1.4,
                              fontWeight: FontWeight.w100,
                            )),
                        Text('  💪',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 15,
                              height: 1.4,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),

                    //========================================================================
                    // Email text field

                    TextFormField(
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(passwordNode);
                      },
                      validator: (value) {
                        if ((value == null || value.isEmpty)) {
                          return "Email can't be empty";
                        }
                        return null;
                      },
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.grey,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 4,
                          fontWeight: FontWeight.normal),

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                width: 2,
                                color: Colors.yellow)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                width: 2,
                                color: Colors.yellow)),
                        label: Text(
                          ' Email address',
                          style: TextStyle(
                              color: Color.fromARGB(255, 144, 144, 144)),
                        ),
                        // hintText: 'enter the phone number',

                      ),
                      //hintStyle: title1.merge(TextStyle(color: gray)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //========================================================================

                    // password text field
                    StatefulBuilder(
                      builder: (context, setState) => TextFormField(
                        focusNode: passwordNode,
                        validator: (value) {
                          if ((value == null || value.isEmpty)) {
                            return "Password can't be empty";
                          }
                          return null;
                        },
                        controller: password,
                        obscureText: isHidden,
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: Colors.grey,

                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 4,
                            fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black,
                          suffixIcon: IconButton(
                            icon: isHidden == true
                                ? Icon(
                              Icons.lock,
                              color: Color.fromARGB(255, 144, 144, 144),
                            )
                                : Icon(
                              Icons.lock_open,
                              color: Color.fromARGB(255, 144, 144, 144),
                            ),
                            onPressed: () {
                              isHidden = !isHidden;
                              setState(() {});
                            },
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 2,
                                  color:
                                  Color.fromARGB(1000, 242, 243, 247))),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 2,
                                  color:
                                  Color.fromARGB(1000, 242, 243, 247))),
                          label: Text(' password',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 144, 144, 144))),
                        ),

                        // hintText: 'enter the phone number',
                        //hintStyle: title1.merge(TextStyle(color: gray)),
                      ),
                    ),

                    SizedBox(
                      height: 26,
                    ),
                    //=================================================================
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text('Forgot password?',
                          style: TextStyle(
                              color: Color.fromARGB(1000, 63, 65, 78))),
                      TextButton(
                        onPressed: () {},
                        child: Text('Click here  ',
                            style: TextStyle(
                              color: Colors.yellow,
                            )),
                      ),
                    ]),
                    const SizedBox(
                      height: 20,
                    ),

                    //========================================================================
                    Text(
                      errorMessage ?? "",
                      style: TextStyle(color: Colors.red[600]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text('LOG IN',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    height: 4,
                                  )),
                              onPressed: () {
                                _login();
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    Colors.yellow),
                                // padding: WidgetStateProperty.all(EdgeInsets.all(50)),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 50,
                    ),

                    //=========================================================================
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('DONT HAVE AN ACCOUNT?',
                          style: TextStyle(
                              color: Color.fromARGB(1000, 63, 65, 78))),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => SignUpScreen()),
                            ),
                          );
                        },
                        child: Text('  SIGN UP',
                            style: TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.w300,
                                fontSize: 16)),
                      ),
                    ]),
                  ]),
            ),
          ),
        ),
      )),
    );
  }
}

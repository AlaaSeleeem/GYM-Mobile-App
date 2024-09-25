import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'Onboarding.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
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
                    const Text('Create your account ',
                        style: TextStyle(
                          color: Color.fromARGB(1000, 63, 65, 78),
                          fontSize: 28,
                          height: 1.4,
                          fontWeight: FontWeight.w700,
                        )),
                    //========================================================================
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          FontAwesomeIcons.facebookF,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        label: const Text(
                          '      CONTINUE WITH FACEBOOK',
                          style: TextStyle(
                              color: Color.fromARGB(1000, 246, 241, 251),
                              fontSize: 14,
                              height: 4,
                              fontWeight: FontWeight.w400),
                        ),
                        onPressed: () {
                          print('Button Pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(1000, 117, 131, 202),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(38),
                          ),
                        ),
                      ),
                    ),
                    //========================================================================
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          FontAwesomeIcons.google,
                          color: Color.fromARGB(1000, 117, 131, 202),
                          size: 20.0,
                        ),
                        label: const Text(
                          '      CONTINUE WITH GOOGLE',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              height: 4,
                              fontWeight: FontWeight.w400),
                        ),
                        onPressed: () {
                          print('Button Pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(38),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    //========================================================================
                    TextButton(
                      onPressed: () {},
                      child: Text('Create your account ',
                          style: TextStyle(
                              color: Color.fromARGB(1000, 161, 164, 178),
                              fontWeight: FontWeight.w200,
                              fontSize: 14)),
                    ),
                    const SizedBox(height: 26),
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
                          color: Colors.black,
                          fontSize: 14,
                          height: 4,
                          fontWeight: FontWeight.normal),

                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(1000, 242, 243, 247),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(1000, 242, 243, 247))),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(1000, 242, 243, 247))),
                          label: Text(
                            ' Email address',
                            style: TextStyle(
                                color: Color.fromARGB(255, 144, 144, 144)),
                          ),
                          // hintText: 'enter the phone number',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(1000, 242, 243, 247))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.white))),
                      //hintStyle: title1.merge(TextStyle(color: gray)),
                    ),
                    SizedBox(
                      height: 20,
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
                          color: Colors.black,
                          fontSize: 14,
                          height: 4,
                          fontWeight: FontWeight.normal),

                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(1000, 242, 243, 247),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(1000, 242, 243, 247))),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(1000, 242, 243, 247))),
                          label: Text(
                            ' Email address',
                            style: TextStyle(
                                color: Color.fromARGB(255, 144, 144, 144)),
                          ),
                          // hintText: 'enter the phone number',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(1000, 242, 243, 247))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.white))),
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
                            color: Colors.black,
                            fontSize: 14,
                            height: 4,
                            fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(1000, 242, 243, 247),
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
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 2,
                                    color:
                                        Color.fromARGB(1000, 242, 243, 247))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.white))),

                        // hintText: 'enter the phone number',
                        //hintStyle: title1.merge(TextStyle(color: gray)),
                      ),
                    ),

                    SizedBox(
                      height: 26,
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    height: 4,
                                  )),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => Onboarding3Screen()),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    Color.fromARGB(1000, 142, 151, 253)),
                                // padding: WidgetStateProperty.all(EdgeInsets.all(50)),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(38),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    //=================================================================
                    TextButton(
                      onPressed: () {},
                      child: Text('Forgot Password?',
                          style: TextStyle(
                              color: Color.fromARGB(1000, 63, 65, 78),
                              fontWeight: FontWeight.w200,
                              fontSize: 14)),
                    ),
                    const SizedBox(height: 46),
                    //=========================================================================
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('ALREADY HAVE AN ACCOUNT?',
                          style: TextStyle(
                              color: Color.fromARGB(1000, 63, 65, 78))),
                      TextButton(
                        onPressed: () {},
                        child: Text('  SIGN UP',
                            style: TextStyle(
                                color: Color.fromARGB(1000, 142, 151, 253),
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

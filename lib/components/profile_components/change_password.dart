import 'package:flutter/material.dart';
import 'package:gymm/components/password_field.dart';
import 'package:gymm/theme/colors.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final FocusNode _newPasswordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();

  final bool _submitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        decoration: BoxDecoration(
          color: blackColor[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ExpansionTile(
          shape: Border.all(color: Colors.transparent),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.lock, color: primaryColor),
              SizedBox(width: 10),
              Text(
                "Change Password",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(12),
                          child: PasswordField(
                            requiredMsg: "Enter current password",
                            controller: _currentPassword,
                            label: "Current Password",
                            onFieldSubmit: () {
                              FocusScope.of(context)
                                  .requestFocus(_newPasswordNode);
                            },
                          )),
                      Container(
                          padding: const EdgeInsets.all(12),
                          child: PasswordField(
                            requiredMsg: "Enter new password",
                            controller: _newPassword,
                            label: "New Password",
                            focusNode: _newPasswordNode,
                            onFieldSubmit: () {
                              FocusScope.of(context)
                                  .requestFocus(_confirmPasswordNode);
                            },
                          )),
                      Container(
                          padding: const EdgeInsets.all(12),
                          child: PasswordField(
                            requiredMsg: "Enter password again",
                            controller: _confirmPassword,
                            label: "Confirm Password",
                            focusNode: _confirmPasswordNode,
                            onFieldSubmit: () {
                              _submit();
                            },
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: _submit,
                              style: ButtonStyle(
                                  backgroundColor: const WidgetStatePropertyAll(
                                      primaryColor),
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                              child: Row(
                                children: [
                                  if (_submitting)
                                    const Row(
                                      children: [
                                        SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white)),
                                        SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                  const Text(
                                    "Change Password",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ))
                        ],
                      )
                    ],
                  )),
            )
          ],
        ));
  }
}

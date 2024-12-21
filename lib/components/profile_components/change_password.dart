import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/api/exceptions.dart';
import 'package:gymm/components/password_field.dart';
import 'package:gymm/models/client.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/snack_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key, this.client});

  final Client? client;

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordForm> {
  Client? client;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final FocusNode _newPasswordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  Map<String, String?> fieldErrors = {};

  bool _submitting = false;
  String? _errorMessage;

  CancelableOperation? _currentOperation;

  @override
  void initState() {
    super.initState();
    client = widget.client;
  }

  @override
  void dispose() {
    super.dispose();
    _currentOperation?.cancel();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _errorMessage = null;
      fieldErrors = {};
    });

    if (_newPassword.text.length < 8) {
      setState(() {
        fieldErrors["new_password"] =
            AppLocalizations.of(context)!.shortPassword;
      });
      return;
    }

    if (_newPassword.text != _confirmPassword.text) {
      setState(() {
        fieldErrors["confirm_password"] =
            AppLocalizations.of(context)!.notMatch;
      });
      return;
    }

    setState(() {
      _submitting = true;
    });

    _currentOperation?.cancel();
    _currentOperation = CancelableOperation.fromFuture(changeClientPassword({
      "id": client!.id,
      "current_password": _currentPassword.text,
      "new_password": _newPassword.text,
      "confirm_password": _confirmPassword.text,
    }));

    _currentOperation?.value.then((_) {
      if (!mounted) return;
      showSnackBar(
          context, AppLocalizations.of(context)!.passwordChanged, "info");
    }).catchError((e) {
      if (!mounted) return;
      if (e is ClientErrorException) {
        setState(() {
          e.responseBody.forEach((k, v) {
            fieldErrors[k] = v.toString();
          });
        });
      } else {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.operationFailed;
        });
      }
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    });
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.lock, color: primaryColor),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.changePassword,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          children: [
            client != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(12),
                                child: PasswordField(
                                  requiredMsg: AppLocalizations.of(context)!
                                      .currentPasswordTitle,
                                  controller: _currentPassword,
                                  label: AppLocalizations.of(context)!
                                      .currentPasswordLabel,
                                  onFieldSubmit: () {
                                    FocusScope.of(context)
                                        .requestFocus(_newPasswordNode);
                                  },
                                  error: fieldErrors["current_password"],
                                )),
                            Container(
                                padding: const EdgeInsets.all(12),
                                child: PasswordField(
                                  requiredMsg: AppLocalizations.of(context)!
                                      .newPasswordTitle,
                                  controller: _newPassword,
                                  label: AppLocalizations.of(context)!
                                      .newPasswordLabel,
                                  focusNode: _newPasswordNode,
                                  onFieldSubmit: () {
                                    FocusScope.of(context)
                                        .requestFocus(_confirmPasswordNode);
                                  },
                                  error: fieldErrors["new_password"],
                                )),
                            Container(
                                padding: const EdgeInsets.all(12),
                                child: PasswordField(
                                  requiredMsg: AppLocalizations.of(context)!
                                      .confirmPasswordTitle,
                                  controller: _confirmPassword,
                                  label: AppLocalizations.of(context)!
                                      .confirmPasswordLabel,
                                  focusNode: _confirmPasswordNode,
                                  onFieldSubmit: () {
                                    _submit();
                                  },
                                  error: fieldErrors["confirm_password"],
                                )),

                            // error message
                            const SizedBox(height: 10),
                            if (_errorMessage != null)
                              Center(
                                  child: Text(
                                _errorMessage ?? "",
                                style: TextStyle(
                                    color: Colors.red[400],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )),

                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: _submit,
                                    style: ButtonStyle(
                                        backgroundColor:
                                            const WidgetStatePropertyAll(
                                                primaryColor),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10)))),
                                    child: Row(
                                      children: [
                                        if (_submitting)
                                          const Row(
                                            children: [
                                              SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: blackColor)),
                                              SizedBox(
                                                width: 10,
                                              )
                                            ],
                                          ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .changePassword,
                                          style: const TextStyle(
                                              color: blackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ))
                              ],
                            )
                          ],
                        )),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.loadError,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  )
          ],
        ));
  }
}

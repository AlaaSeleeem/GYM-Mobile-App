import 'package:flutter/material.dart';
import 'package:gymm/theme/colors.dart';

class PasswordField extends StatefulWidget {
  const PasswordField(
      {super.key,
      required this.requiredMsg,
      this.onFieldSubmit,
      required this.controller,
      required this.label,
      this.focusNode,
      this.error});

  final String requiredMsg;
  final Function? onFieldSubmit;
  final TextEditingController controller;
  final String label;
  final FocusNode? focusNode;
  final String? error;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return widget.requiredMsg;
        }
        return null;
      },
      onFieldSubmitted: (value) {
        if (widget.onFieldSubmit != null) widget.onFieldSubmit!();
      },
      focusNode: widget.focusNode,
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      cursorHeight: 26,
      obscureText: isHidden,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          height: 1.2,
          fontWeight: FontWeight.normal),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: isHidden == true
              ? Icon(
                  Icons.lock,
                  color: blackColor[300],
                  size: 20,
                )
              : const Icon(
                  Icons.lock_open,
                  color: primaryColor,
                  size: 20,
                ),
          onPressed: () {
            setState(() {
              isHidden = !isHidden;
            });
          },
        ),
        label: Text(
          widget.label,
        ),
        errorText: widget.error
      ),
    );
  }
}

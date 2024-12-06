import 'package:flutter/material.dart';
import 'package:gymm/theme/colors.dart';

void showSnackBar(BuildContext context, String message, String state) {
  final snackBar = SnackBar(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
    content: SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(
              fontSize: 18,
              color: state == "info" ? Colors.green : Colors.red[600],
              fontWeight: FontWeight.bold),
        ),
      ),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: blackColor[100],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

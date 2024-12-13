import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

bool firstInitialization = true;

void showAddToCartDialog(BuildContext context) {
  final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      autoHide: const Duration(milliseconds: 2000),
      headerAnimationLoop: false,
      body: const Padding(
        padding: EdgeInsets.only(left: 14, bottom: 26, right: 14, top: 12),
        child: Center(
          child: Text(
            'Product has been added to your cart!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ));

  dialog.show();
}

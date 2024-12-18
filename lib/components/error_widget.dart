import 'package:flutter/material.dart';

Widget errorWidget = SizedBox(
  width: 240,
  height: 240,
  child: Center(
    child: Text(
      "Oops! Error Happened",
      style: TextStyle(
          color: Colors.red[600], fontSize: 20, fontWeight: FontWeight.bold),
    ),
  ),
);

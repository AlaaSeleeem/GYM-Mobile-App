
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
void goTO({required BuildContext context,required Widget screen}) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => screen));
              }
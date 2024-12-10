import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme/colors.dart';

class ActionButtons extends StatefulWidget {
  const ActionButtons({super.key});

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 45,
              height: 45,
              child: FloatingActionButton(
                onPressed: () {
                  // Handle edit action
                },
                backgroundColor: blackColor[800],
                child: const Icon(
                  FontAwesomeIcons.clockRotateLeft,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 14), // Space between buttons
            FloatingActionButton(
              onPressed: () {
                // Handle camera action
              },
              backgroundColor: primaryColor,
              child: const Icon(
                Icons.shopping_cart_rounded,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

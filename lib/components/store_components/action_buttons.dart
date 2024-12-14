import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymm/screens/cart_screen.dart';
import 'package:gymm/screens/orders_screen.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 45,
            height: 45,
            child: FloatingActionButton(
              heroTag: 'orders history',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const OrdersHistoryPage()));
              },
              backgroundColor: blackColor[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(
                FontAwesomeIcons.clockRotateLeft,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 12), // Space between buttons
          FloatingActionButton(
            heroTag: 'cart',
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CartPage()));
            },
            backgroundColor: primaryColor[900],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Icon(
              Icons.shopping_cart_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

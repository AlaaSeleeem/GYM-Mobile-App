import 'package:flutter/material.dart';
import 'package:gymm/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart,
            size: 80,
            color: primaryColor,
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.emptyCart,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.addItems,
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.continueShopping,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )),
        ],
      ),
    );
  }
}

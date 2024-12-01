import 'package:flutter/material.dart';

class NoOffers extends StatefulWidget {
  const NoOffers({super.key});

  @override
  State<NoOffers> createState() => _NoOffersState();
}

class _NoOffersState extends State<NoOffers> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(26),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Image.asset("assets/offers/coming-soon.jpg"),
      ),
    );
  }
}

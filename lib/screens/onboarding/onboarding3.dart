import 'package:flutter/material.dart';
import 'package:my_network_app/shared/Widgets/action_button.dart';

import '../../shared/Themes/Texts.dart';
import '../../shared/methods/navigation.dart';
import '../screens.dart';

class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(image: AssetImage('assets/kaffo.jpeg'))),
                SizedBox(
                  height: 47,
                ),
                Text(
                  '3خلـــيك كفو',
                  style: h5,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 16, right: 24),
            child: ActionButton(
                title: 'start',
                action: () {
                  goTO(context: context, screen: HomeScreen());
                })));
  }
}

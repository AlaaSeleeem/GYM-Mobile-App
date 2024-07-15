import 'package:flutter/material.dart';
import 'package:my_network_app/shared/Widgets/action_button.dart';
import 'package:my_network_app/shared/methods/navigation.dart';

import '../../shared/Themes/Texts.dart';
import '../screens.dart';

class Onboarding1Screen extends StatelessWidget {
  const Onboarding1Screen({super.key});

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
                  'خلـــيك كفو',
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
                title: 'Next',
                action: () {
                  goTO(context: context, screen: Onboarding2Screen());
                })));
  }
}

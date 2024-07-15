import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/Themes/colors.dart';
import '../shared/Widgets/action_button.dart';
import 'wedgets/socialMediaIcon.dart';

class FriendScreen extends StatelessWidget {
  FriendScreen({super.key});

  final Uri phoneNumber = Uri.parse('tel:+201147617485');
  final Map myContacts = {
    'whatsapp': Uri.parse('https://wa.me/+201147617485'),
    'facebook': Uri.parse('https://www.facebook.com/Kaffo.co?mibextid=ZbWKwL'),
    'insta': Uri.parse('https://www.instagram.com/Kaffo.co'),
    'x': Uri.parse('https://x.com/kaffo_co'),
    'tiktok': Uri.parse('http://tiktok.com/kaffo.co/'),
    'youtube': Uri.parse('http://www.youtube.com/kaffo_co/'),
    'kaffo.': Uri.parse('https://kaffo.co/'),
  };

  @override
  Widget build(BuildContext myContext) {
    return SafeArea(
        bottom: true,
        left: true,
        top: true,
        right: true,
        maintainBottomViewPadding: true,
        minimum: EdgeInsets.zero,
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(
              Icons.arrow_back,
              color: orange,
            ),
          ),
          body: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 80),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/kaffo.jpeg'),
                      radius: 100,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'هــلا .. خليــك كفوّ',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 4, 107, 129)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ActionButtonWithIcon(
                        title: 'Add To Group',
                        icon: Icons.add,
                        action: () {
                          print('Frind Added to Group');
                        }),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '00201147617485',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 14, 107, 129)),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        IconButton(
                          icon: Icon(Icons.phone,
                              size: 30,
                              color: Color.fromARGB(255, 14, 107, 129)),
                          onPressed: () {
                            launchUrl(phoneNumber);
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    GridView.builder(
                      itemCount: myContacts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10),
                      itemBuilder: (BuildContext context, index) {
                        return contactChanelCard(
                          url: myContacts.values.toList()[index],
                          platForm: myContacts.keys.toList()[index],
                        );
                      },
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                  ]),
            ),
          ),
        ));
  }
}

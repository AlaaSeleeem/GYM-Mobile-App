import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactInfo extends StatefulWidget {
  const ContactInfo({super.key});

  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  bool isHelpExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 34, 34, 34),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isHelpExpanded = !isHelpExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.help, color: Colors.yellow),
                      SizedBox(width: 8),
                      Text('Help & Support',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                  Icon(isHelpExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white),
                ],
              ),
            ),
            if (isHelpExpanded) ...[
              const SizedBox(height: 10),

              // Gym Information
              const ExpansionTile(
                title: Text('Gym Information',
                    style: TextStyle(color: Colors.white)),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Founded in 2020, our gym aims to provide an ideal sporting environment.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              // Frequently Asked Questions
              const ExpansionTile(
                title: Text('Frequently Asked Questions',
                    style: TextStyle(color: Colors.white)),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '1. What are the operating hours?\n2. Are there group classes?\n3. How can I register?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              // Contact Information
              ExpansionTile(
                title: const Text('Contact Information',
                    style: TextStyle(color: Colors.white)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.email, color: Colors.yellow),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text('Email: info@gym.com',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Icon(Icons.phone, color: Colors.yellow),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text('Phone: 123456789',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.yellow),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text('Address: Gym Street, City',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            // Open Google Maps
                          },
                          child: const Text('View on Google Maps',
                              style: TextStyle(color: Colors.yellow)),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 20, // المسافة بين الأيقونات
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                // اضف الرابط الخاص بفيسبوك
                              },
                              icon: const Icon(FontAwesomeIcons.facebook,
                                  color: Colors.yellow),
                              label: const Text('Facebook',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                // اضف الرابط الخاص بانستغرام
                              },
                              icon: const Icon(FontAwesomeIcons.instagram,
                                  color: Colors.yellow),
                              label: const Text('Instagram',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                // اضف الرابط الخاص بتويتر
                              },
                              icon: const Icon(FontAwesomeIcons.twitter,
                                  color: Colors.yellow),
                              label: const Text('Twitter',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

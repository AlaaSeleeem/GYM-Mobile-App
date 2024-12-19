import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme/colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // Open URL in default browser
  Future<void> _launchURL(String url) async {
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aboutProGym),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Center(
                child: Container(
                    height: 300,
                    margin: const EdgeInsets.all(12),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset("assets/logo2.jpeg")),
              ),
              const SizedBox(height: 20),
              // Gym Terms Section
              _buildSectionHeader(AppLocalizations.of(context)!.termsTitle,
                  FontAwesomeIcons.fileContract),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.terms,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              // Conditions of Use
              _buildSectionHeader(AppLocalizations.of(context)!.conditionsTitle,
                  FontAwesomeIcons.scaleBalanced),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.conditions,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              // Contact Info Section
              _buildSectionHeader(AppLocalizations.of(context)!.contact,
                  FontAwesomeIcons.addressCard),
              const SizedBox(height: 10),
              _buildContactItem(AppLocalizations.of(context)!.phone,
                  FontAwesomeIcons.phone, "01020202030"),
              _buildContactItem(AppLocalizations.of(context)!.facebook,
                  FontAwesomeIcons.facebook, "https://facebook.com/ProGym"),
              _buildContactItem(AppLocalizations.of(context)!.instagram,
                  FontAwesomeIcons.instagram, "https://instagram.com/ProGym"),
              _buildContactItem(AppLocalizations.of(context)!.tiktok,
                  FontAwesomeIcons.tiktok, "https://tiktok.com/@ProGym"),
              _buildContactItem(
                  AppLocalizations.of(context)!.address,
                  FontAwesomeIcons.locationDot,
                  "123 Paris Street, Shebin, Menofia"),
              const SizedBox(height: 20),
              // Location Button
              ElevatedButton.icon(
                onPressed: () {
                  _launchURL("https://maps.google.com/?q=123+Gym+Street");
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                icon: const Icon(FontAwesomeIcons.map, color: Colors.black),
                label: Text(
                  AppLocalizations.of(context)!.viewLocation,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              // Feedback Section
              // _buildSectionHeader(
              //     "Feedback & Support", FontAwesomeIcons.mobile),
              // const SizedBox(height: 10),
              // const Text(
              //   "We value your feedback! Let us know how we can improve your experience.",
              //   style: TextStyle(fontSize: 16),
              // ),
              // const SizedBox(height: 10),
              // TextField(
              //   maxLines: 5,
              //   decoration: InputDecoration(
              //     hintText: "Write your feedback here...",
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Handle feedback submission logic
              //     },
              //     style: ElevatedButton.styleFrom(
              //         backgroundColor: primaryColor,
              //         padding: const EdgeInsets.symmetric(
              //             vertical: 12, horizontal: 24),
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(10))),
              //     child: const Text(
              //       "Submit Feedback",
              //       style: TextStyle(color: Colors.white, fontSize: 16),
              //     ),
              //   ),
              // ),
              _buildDeveloperSection(context),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for section headers
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
        ),
      ],
    );
  }

  // Widget for contact items
  Widget _buildContactItem(String title, IconData icon, String content) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(content),
      onTap: content.startsWith("http")
          ? () => _launchURL(content)
          : null, // Open URL if the content is a link
    );
  }

  Widget _buildDeveloperSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1, color: Colors.grey),
        const SizedBox(height: 20),
        // Developer Logo
        Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(
                  "assets/kaffo.jpeg", // Replace with the path to your logo
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.developedBy,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Developer Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizations.of(context)!.aboutKaffo,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        // Contact Information
        ListTile(
          leading: const Icon(Icons.phone, color: primaryColor),
          title: Text(
            AppLocalizations.of(context)!.phone,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text("+123-456-7890"),
          onTap: () {
            launchUrl(Uri.parse("tel:+1234567890"));
          },
        ),
        ListTile(
          leading: const Icon(Icons.email, color: primaryColor),
          title: Text(
            AppLocalizations.of(context)!.email,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text("support@kaffo.co"),
          onTap: () {
            launchUrl(Uri.parse("mailto:support@kaffo.co"));
          },
        ),
        ListTile(
          leading: const Icon(Icons.web, color: primaryColor),
          title: Text(
            AppLocalizations.of(context)!.website,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text("https://kaffo.co"),
          onTap: () {
            launchUrl(Uri.parse("https://kaffo.co"));
          },
        ),
        const SizedBox(height: 20),
        // Copyright and Footer
        Center(
          child: Text(
            AppLocalizations.of(context)!.rights,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
        title: const Text("About Pro Gym"),
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
              _buildSectionHeader(
                  "Terms & Conditions", FontAwesomeIcons.fileContract),
              const SizedBox(height: 10),
              const Text(
                "1. Membership fees are non-refundable.\n"
                "2. All equipment should be used responsibly.\n"
                "3. Gym members must wear proper attire.\n"
                "4. Personal belongings should be stored in lockers.\n"
                "5. Report any injuries or issues to the staff immediately.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              // Conditions of Use
              _buildSectionHeader(
                  "Conditions of Use", FontAwesomeIcons.scaleBalanced),
              const SizedBox(height: 10),
              const Text(
                "By accessing the gym facilities, you agree to:\n"
                "- Follow all safety guidelines.\n"
                "- Respect staff and fellow members.\n"
                "- Avoid misuse of equipment.\n"
                "- Comply with gym timings and policies.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              // Contact Info Section
              _buildSectionHeader(
                  "Contact Information", FontAwesomeIcons.addressCard),
              const SizedBox(height: 10),
              _buildContactItem("Phone", FontAwesomeIcons.phone, "01116603637"),
              _buildContactItem("Facebook", FontAwesomeIcons.facebook,
                  "https://www.facebook.com/share/12Cz2wymouW/?mibextid=wwXIfr"),
              _buildContactItem("Instagram", FontAwesomeIcons.instagram,
                  "https://www.instagram.com/pro.gym9?igsh=MWpwanRqMGU1eGF4ag=="),

              _buildContactItem("Address", FontAwesomeIcons.locationDot,
                  "123 Paris Street, Shebin, Menofia"),
              const SizedBox(height: 20),
              // Location Button
              ElevatedButton.icon(
                onPressed: () {
                  _launchURL("https://maps.app.goo.gl/5x4VcSVJhXAt9rGE8");
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                icon: const Icon(FontAwesomeIcons.map, color: Colors.black),
                label: const Text(
                  "Open Location in Maps",
                  style: TextStyle(
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
              _buildDeveloperSection(),
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

  Widget _buildDeveloperSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1, color: Colors.grey),
        const SizedBox(height: 20),
        // Developer Logo
        const Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(
                  "assets/kaffo.jpeg", // Replace with the path to your logo
                ),
              ),
              SizedBox(height: 10),
              Text(
                "App Developed by Kaffo",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Developer Description
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Kaffo is a leading app development company specializing in innovative, "
            "user-friendly solutions tailored to meet the needs of businesses and users alike.",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        // Contact Information
        ListTile(
          leading: const Icon(Icons.phone, color: primaryColor),
          title: const Text(
            "Phone",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text("+123-456-7890"),
          onTap: () {
            launchUrl(Uri.parse("tel:+1234567890"));
          },
        ),
        ListTile(
          leading: const Icon(Icons.email, color: primaryColor),
          title: const Text(
            "Email",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text("support@kaffo.co"),
          onTap: () {
            launchUrl(Uri.parse("mailto:support@kaffo.co"));
          },
        ),
        ListTile(
          leading: const Icon(Icons.web, color: primaryColor),
          title: const Text(
            "Website",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text("https://kaffo.co"),
          onTap: () {
            launchUrl(Uri.parse("https://kaffo.co"));
          },
        ),
        const SizedBox(height: 20),
        // Copyright and Footer
        const Center(
          child: Text(
            "© 2024 Kaffo. All rights reserved.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

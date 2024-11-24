import 'package:flutter/material.dart';
import 'package:gymm/theme/colors.dart';

class NewsDetailPage extends StatelessWidget {
  final String image;
  final String title;
  final DateTime date;
  final String content;

  const NewsDetailPage({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            // Picture
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Published on: ${_formatDate(date)}",
                style: TextStyle(
                  fontSize: 16,
                  color: blackColor[400],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Helper to format the date
  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }
}

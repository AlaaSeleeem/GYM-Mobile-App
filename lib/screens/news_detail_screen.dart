import 'package:flutter/material.dart';
import 'package:gymm/theme/colors.dart';

import '../models/news.dart';

class NewsDetailPage extends StatelessWidget {
  final News item;

  const NewsDetailPage({super.key, required this.item});

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
            const SizedBox(
              height: 20,
            ),
            // Picture
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: item.picture != null
                      ? NetworkImage(item.picture!)
                      : const AssetImage("assets/logo1.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                item.title ?? "",
                style: const TextStyle(
                  fontSize: 28,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Date
            if (item.createdAt != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Published on: ${_formatDate(item.createdAt!)}",
                  style: TextStyle(
                    fontSize: 16,
                    color: blackColor[400],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Content
            if (item.content != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  item.content!,
                  style: const TextStyle(
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

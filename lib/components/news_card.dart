import 'package:flutter/material.dart';
import 'package:gymm/theme/colors.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String image;

  const NewsCard({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 200,
      decoration: BoxDecoration(
          border: Border.all(color: blackColor[400]!, width: 3),
          borderRadius: BorderRadius.circular(10.0)),
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          )),
          // Bottom Gradient Shadow
          Positioned.fill(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100, // Adjust shadow height
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.3),
                      Colors.grey.withOpacity(0.2),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  )),
            ),
          ),
          // Title Text
          Positioned(
            bottom: 16,
            left: 16,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: primaryColor[300],
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

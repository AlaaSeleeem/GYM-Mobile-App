import 'package:flutter/material.dart';
import 'package:gymm/models/news.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/globals.dart';

class NewsCard extends StatelessWidget {
  final News item;

  const NewsCard({super.key, required this.item});

  Widget _buildContentWithImage(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
            child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            item.picture!,
            errorBuilder: (context, error, stackTrace) => Container(
              color: blackColor[900],
            ),
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
                    Colors.black.withValues(alpha: 0.9),
                    Colors.black.withValues(alpha: 0.3),
                    Colors.grey.withValues(alpha: 0.2),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )),
          ),
        ),
        // Title Text
        Positioned(
          bottom: 16,
          left: isArabic(context) ? null : 16,
          right: isArabic(context) ? 16 : null,
          child: Text(
            item.title ?? "",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: primaryColor[300],
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentWithoutImage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 2, child: Image.asset("assets/logo1.jpeg")),
        Expanded(
            flex: 3,
            child: Container(
              color: blackColor[800],
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  item.title ?? "",
                  softWrap: true,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 200,
      decoration: BoxDecoration(
          border: Border.all(color: blackColor[400]!, width: 3),
          borderRadius: BorderRadius.circular(10.0)),
      child: item.picture != null
          ? _buildContentWithImage(context)
          : _buildContentWithoutImage(),
    );
  }
}

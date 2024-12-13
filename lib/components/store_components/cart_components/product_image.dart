import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymm/models/product.dart';

import '../../../theme/colors.dart';

class ProductImage extends StatelessWidget {
  const ProductImage(
      {super.key,
      required this.product,
      this.height = 150,
      this.iconSize = 100});

  final Product product;
  final double height;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return product.image != null
        ? Image.network(
            product.image!,
            fit: BoxFit.cover,
            height: height,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child; // Image loaded successfully
              }
              return SizedBox(
                height: height,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              // Display a placeholder if the image fails to load
              return SizedBox(
                height: height,
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.image,
                    size: iconSize,
                    color: blackColor[400],
                  ),
                ),
              );
            },
          )
        : Icon(
            FontAwesomeIcons.image,
            size: iconSize,
            color: blackColor[400],
          );
  }
}

import 'package:flutter/material.dart';
import 'package:gymm/components/store_components/product_card.dart';
import 'package:gymm/models/product.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({super.key, required this.productList});

  final List<Product> productList;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Wrap(
              spacing: isLandscape ? 20 : 6,
              runSpacing: 16,
              alignment:
                  isLandscape ? WrapAlignment.spaceEvenly : WrapAlignment.start,
              children: productList.map((item) {
                return ProductCard(product: item);
              }).toList()),
        )
      ],
    );
  }
}

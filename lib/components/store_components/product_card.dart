import 'package:flutter/material.dart';
import 'package:gymm/components/store_components/cart_components/product_image.dart';
import 'package:gymm/models/product.dart';
import 'package:gymm/providers/Cart.dart';
import 'package:gymm/screens/product_detail_screen.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/globals.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final double cardWidth =
        isLandscape ? (screenWidth - 40) / 3 : (screenWidth - 38) / 2;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product)));
      },
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: blackColor[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min, // Ensure it takes minimum height
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: ProductImage(product: product)),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style:
                            const TextStyle(fontSize: 23, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (product.discount != null) ...[
                            Text(
                              '${(product.sellPrice - (product.discount! * product.sellPrice / 100)).toInt()}',
                              style: const TextStyle(
                                fontSize: 26,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${product.sellPrice.toInt()}',
                              softWrap: false,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ] else ...[
                            Text(
                              '${product.sellPrice.toInt()}',
                              style: const TextStyle(
                                fontSize: 26,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 40,
                        child: Text(
                          product.description ?? "",
                          style: const TextStyle(color: Colors.white54),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            cart.addToCart(product: product);
                            showAddToCartDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.all(4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_shopping_cart,
                                  color: Colors.black, size: 23),
                              SizedBox(width: 6),
                              Text('Add to Cart',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (product.discount != null)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${(product.discount!.toInt())}% OFF',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

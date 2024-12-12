import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymm/models/product.dart';
import 'package:gymm/theme/colors.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: SizedBox(
                        width: double.infinity,
                        child: widget.product.image != null
                            ? Image.network(
                                widget.product.image!,
                                fit: BoxFit.cover,
                                height: 150,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child; // Image loaded successfully
                                  }
                                  return SizedBox(
                                    height: 150,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  // Display a placeholder if the image fails to load
                                  return SizedBox(
                                    height: 150,
                                    child: Center(
                                      child: Icon(
                                        FontAwesomeIcons.image,
                                        size: 100,
                                        color: blackColor[400],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Icon(
                                FontAwesomeIcons.image,
                                size: 100,
                                color: blackColor[400],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.category,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (widget.product.discount != null) ...[
                              Text(
                                '${widget.product.sellPrice - (widget.product.discount! * widget.product.sellPrice / 100)} L.E',
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.product.sellPrice} L.E',
                                softWrap: false,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ] else ...[
                              Text(
                                '${widget.product.sellPrice} L.E',
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.description ?? "",
                          style:
                              TextStyle(color: blackColor[200], fontSize: 18),
                        ),
                        // const SizedBox(height: 16),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFF373739),
                ),
                child: Column(
                  children: [
                    // Counter widget
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (_count <= 1) {
                                    _count = 1;
                                    return;
                                  }
                                  _count--;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: blackColor[600],
                              ),
                              child:
                                  const Icon(Icons.remove, color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "$_count", // Display quantity dynamically
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _count++;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: blackColor[600],
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Add to Cart button
                    Container(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 12),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add to cart logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_shopping_cart,
                                color: Colors.black, size: 26),
                            SizedBox(width: 6),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
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

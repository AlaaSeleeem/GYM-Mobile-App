import 'package:flutter/material.dart';
import 'package:gymm/components/store_components/cart_components/product_image.dart';
import 'package:gymm/models/product.dart';
import 'package:gymm/providers/Cart.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/globals.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    Cart cart = Provider.of<Cart>(context);

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
                        child: ProductImage(product: widget.product)),
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
                                '${widget.product.sellPrice - (widget.product.discount! * widget.product.sellPrice / 100)} ${AppLocalizations.of(context)!.pound}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.product.sellPrice} ${AppLocalizations.of(context)!.pound}',
                                softWrap: false,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ] else ...[
                              Text(
                                '${widget.product.sellPrice} ${AppLocalizations.of(context)!.pound}',
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
                    Container(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 12),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          cart.addToCart(
                              product: widget.product, amount: _count);
                          showAddToCartDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_shopping_cart,
                                color: Colors.black, size: 26),
                            const SizedBox(width: 6),
                            Text(
                              AppLocalizations.of(context)!.addToCart,
                              style: const TextStyle(
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

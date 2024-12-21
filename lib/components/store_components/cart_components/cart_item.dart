import 'package:flutter/material.dart';
import 'package:gymm/components/store_components/cart_components/product_image.dart';
import 'package:gymm/models/order_item.dart';
import 'package:gymm/utils/globals.dart';
import 'package:provider/provider.dart';
import '../../../providers/Cart.dart';
import '../../../theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartItemCard extends StatelessWidget {
  final OrderItem item;
  final bool forCart;

  const CartItemCard({super.key, required this.item, this.forCart = true});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    return Container(
      color: Colors.transparent,
      child: Dismissible(
        direction:
            forCart ? DismissDirection.horizontal : DismissDirection.none,
        key: Key(item.product.id.toString()),
        onDismissed: (direction) {
          cart.removeFromCart(item);
        },
        background: Container(
          color: Colors.red,
          alignment:
              isArabic(context) ? Alignment.centerRight : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: const Icon(
            Icons.delete,
            size: 30,
            color: Colors.white,
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          alignment:
              isArabic(context) ? Alignment.centerLeft : Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: const Icon(
            Icons.delete,
            size: 30,
            color: Colors.white,
          ),
        ),
        child: ListTile(
          tileColor: const Color(0xFF373739),
          contentPadding: const EdgeInsets.all(8),
          leading: SizedBox(
            width: 60,
            height: 60,
            child: ProductImage(
              product: item.product,
              height: 50,
              iconSize: 30,
            ),
          ),
          title: Text(item.product.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 20)),
          subtitle: Text(
              '${item.unitPrice} ${AppLocalizations.of(context)!.pound}',
              style: const TextStyle(color: Colors.white54, fontSize: 16)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Decrement Button
              if (forCart)
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    cart.decrementProduct(item);
                  },
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    backgroundColor: blackColor[600],
                  ),
                ),
              // Quantity Display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Center(
                  child: Text('${item.amount}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              // right padding when disabling icon buttons
              if (!forCart) const SizedBox(width: 20),
              // Increment Button
              if (forCart)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    cart.incrementProduct(item);
                  },
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    backgroundColor: blackColor[600],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

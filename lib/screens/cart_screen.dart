import 'package:flutter/material.dart';
import 'package:gymm/components/store_components/cart_components/order_details.dart';
import 'package:gymm/utils/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:gymm/providers/Cart.dart';
import '../components/store_components/cart_components/cart_item.dart';
import '../components/store_components/cart_components/empty_cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);

    void deleteCartDialog() async {
      final bool? result = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "Remove all products in cart?",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 44,
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )),
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        "Clear",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.red[500],
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ));

      if (result == true) {
        cart.clear();
        Navigator.of(context).pop();
        showSnackBar(context, "Your cart is cleared", "info");
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Cart',
        ),
        actions: [
          if (cart.cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  onPressed: deleteCartDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon:
                      const Icon(Icons.delete, color: Colors.white, size: 24)),
            ),
        ],
      ),
      body: cart.cartItems.isEmpty
          ? const EmptyCartView()
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.cartItems.length,
                    itemBuilder: (context, index) {
                      return CartItemCard(item: cart.cartItems[index]);
                    },
                    separatorBuilder: (context, index) => const Divider(
                        thickness: 1, color: Colors.grey, height: 1),
                  ),
                ),
                const OrderDetails(),
              ],
            ),
    );
  }
}

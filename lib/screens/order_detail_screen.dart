import 'package:flutter/material.dart';
import 'package:gymm/components/store_components/cart_components/order_details.dart';
import 'package:gymm/models/order.dart';
import '../components/store_components/cart_components/cart_item.dart';
import '../utils/snack_bar.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    void cancelOrderDialog() async {
      final bool? result = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "Are you sure you want cancel this order?",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                icon: const Icon(
                  Icons.cancel,
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
                        "Cancel",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.red[500],
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ));

      if (result == true) {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
        showSnackBar(context, "Order has been removed", "info");
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Order Detail',
        ),
        actions: [
          if (order.state == "معلق")
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  onPressed: cancelOrderDialog,
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
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                return CartItemCard(
                  item: order.items[index],
                  forCart: false,
                );
              },
              separatorBuilder: (context, index) =>
                  const Divider(thickness: 1, color: Colors.grey, height: 1),
            ),
          ),
          OrderDetails(order: order, forCart: false),
        ],
      ),
    );
  }
}

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/components/store_components/cart_components/order_details.dart';
import 'package:gymm/models/order.dart';
import '../components/store_components/cart_components/cart_item.dart';
import '../utils/snack_bar.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key, required this.order});

  final Order order;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  CancelableOperation? _currentOperation;
  bool _removing = false;

  @override
  void dispose() {
    super.dispose();
    _currentOperation?.cancel();
  }

  Future<void> _removeOrder() async {
    if (_removing) return;

    setState(() {
      _removing = true;
    });

    _currentOperation?.cancel();
    _currentOperation =
        CancelableOperation.fromFuture(removeOrder(widget.order.id));

    _currentOperation!.value.then((value) {
      if (!mounted) return;
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
      showSnackBar(context, "Order has been removed", "info");
    }).catchError((e) {
      showSnackBar(context, "Failed removing order", "error");
    }).whenComplete(() {
      setState(() {
        _removing = false;
      });
    });
  }

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
                        "Remove",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.red[500],
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ));

      if (result == true) {
        _removeOrder();
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Order Detail',
        ),
        actions: [
          if (widget.order.state == "معلق")
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _removing
                  ? const SizedBox(
                      width: 27,
                      height: 27,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    )
                  : IconButton(
                      onPressed: cancelOrderDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.all(2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      icon: const Icon(Icons.delete,
                          color: Colors.white, size: 24)),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: widget.order.items.length,
              itemBuilder: (context, index) {
                return CartItemCard(
                  item: widget.order.items[index],
                  forCart: false,
                );
              },
              separatorBuilder: (context, index) =>
                  const Divider(thickness: 1, color: Colors.grey, height: 1),
            ),
          ),
          OrderDetails(order: widget.order, forCart: false),
        ],
      ),
    );
  }
}

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gymm/models/order.dart';
import 'package:gymm/providers/Cart.dart';
import 'package:gymm/screens/orders_screen.dart';
import 'package:provider/provider.dart';
import '../../../theme/colors.dart';
import '../../../utils/snack_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetails extends StatefulWidget {
  final bool forCart;
  final Order? order;

  const OrderDetails({super.key, this.forCart = true, this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool _loading = false;
  CancelableOperation? _currentOperation;

  @override
  void dispose() {
    super.dispose();
    _currentOperation?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);

    void placeOrder() async {
      if (_loading) return;
      setState(() {
        _loading = true;
      });

      _currentOperation?.cancel();
      _currentOperation = CancelableOperation.fromFuture(cart.placeOrder());

      _currentOperation!.value.then((value) {
        if (!mounted) return;
        showSnackBar(
            context, AppLocalizations.of(context)!.orderSubmitted, "info");
        cart.clear();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const OrdersHistoryPage()));
      }).catchError((e) {
        showSnackBar(context,
            AppLocalizations.of(context)!.orderSubmittingError, "error");
      }).whenComplete(() {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      });
    }

    return Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: blackColor[900],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.orderSummary,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 16),

                // display order information
                if (widget.order != null) ...[
                  // order number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.orderNumber,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${widget.order!.id}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // order state
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.state,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.order!.state == "معلق"
                            ? AppLocalizations.of(context)!.pending
                            : AppLocalizations.of(context)!.confirmed,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.order!.state == "معلق"
                              ? primaryColor
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // order created at date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.createdAt,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${widget.order!.createdAt.year}-${widget.order!.createdAt.month}-${widget.order!.createdAt.day}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // order confirmed at date
                  if (widget.order?.confirmedAt != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.confirmedAt,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${widget.order!.confirmedAt!.year}-${widget.order!.confirmedAt!.month}-${widget.order!.confirmedAt!.day}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8)
                  ],
                ],

                // order items count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.totalItems,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.forCart
                          ? cart.cartItems
                              .fold(0, (sum, item) => sum + item.amount)
                              .toString()
                          : widget.order!.items
                              .fold(0, (sum, item) => sum + item.amount)
                              .toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(
                  height: widget.forCart ? 8 : 24,
                  thickness: 1,
                  color: Colors.grey,
                ),

                // order total price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.totalPrice,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      widget.forCart
                          ? '${cart.calculateTotalPrice.toStringAsFixed(2)} ${AppLocalizations.of(context)!.pound}'
                          : widget.order!.afterDiscount.toString(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: widget.forCart ? 10 : 18),
          // Place Order button
          if (widget.forCart)
            Container(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_loading) return;
                  placeOrder();
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
                    if (_loading) ...[
                      Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(right: 12),
                          child: CircularProgressIndicator(
                            color: blackColor[900],
                          ))
                    ],
                    const Icon(Icons.library_add_check_outlined,
                        color: Colors.black, size: 26),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.placeOrder,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

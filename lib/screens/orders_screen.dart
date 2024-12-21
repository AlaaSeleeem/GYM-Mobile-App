import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/components/loading.dart';
import 'package:gymm/models/order.dart';
import 'package:gymm/screens/order_detail_screen.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/globals.dart';
import '../utils/snack_bar.dart';

class OrdersHistoryPage extends StatefulWidget {
  const OrdersHistoryPage({super.key});

  @override
  State<OrdersHistoryPage> createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends State<OrdersHistoryPage> {
  int currentPage = 1;
  bool loading = false;
  bool hasMore = true;
  late List<Order> orders = [];
  CancelableOperation? _currentOperation;

  @override
  void initState() {
    super.initState();
    _loadMoreOrders();
  }

  @override
  void dispose() {
    super.dispose();
    _currentOperation?.cancel();
  }

  Future<void> _refreshOrders() async {
    setState(() {
      orders = [];
      currentPage = 1;
      hasMore = true;
    });
    await _loadMoreOrders();
  }

  Future<void> _loadMoreOrders() async {
    if (loading || !hasMore) return;
    setState(() {
      loading = true;
    });

    String clientId = (await getClientSavedData()).id!;

    _currentOperation?.cancel();
    _currentOperation =
        CancelableOperation.fromFuture(getOrdersHistory(currentPage, clientId));

    _currentOperation!.value.then((value) {
      if (!mounted) return;

      final (List<Order> newOrders, bool next) = value;
      setState(() {
        currentPage++;
        orders.addAll(newOrders);
        if (!next) {
          hasMore = false;
        }
      });
    }).catchError((e) {
      showSnackBar(
          context, AppLocalizations.of(context)!.failedLoadingOrders, "error");
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.orderHistory),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOrders,
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEndNotification) {
            if (scrollEndNotification.metrics.extentAfter < 100) {
              _loadMoreOrders();
            }
            return false;
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isLandscape ? 2 : 1,
                      // 2 per row in landscape
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 4, // Adjust height-to-width ratio
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return _buildOrderBox(context, order);
                    },
                  ),
                  if (loading)
                    const Loading(
                      height: 100,
                    ),
                  if (!loading && orders.isEmpty)
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.noOrderHistory,
                        style: const TextStyle(fontSize: 24),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderBox(BuildContext context, Order order) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OrderDetailPage(order: order)));
      },
      child: SizedBox(
        height: 100,
        child: Row(
          children: [
            // Left section: Order ID
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: blackColor[300],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(isArabic(context) ? 8 : 0),
                    bottomRight: Radius.circular(isArabic(context) ? 8 : 0),
                    topLeft: Radius.circular(isArabic(context) ? 0 : 8),
                    bottomLeft: Radius.circular(isArabic(context) ? 0 : 8),
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    "#${order.id}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: blackColor[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),

            // Center section: order date
            Expanded(
              flex: 9,
              child: Container(
                decoration: BoxDecoration(
                  color: blackColor[900],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${order.createdAt.day}-${order.createdAt.month}-${order.createdAt.year}",
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right section: stat indicator
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: (order.state == "معلق") ? primaryColor : Colors.green,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(isArabic(context) ? 0 : 8),
                    bottomRight: Radius.circular(isArabic(context) ? 0 : 8),
                    topLeft: Radius.circular(isArabic(context) ? 8 : 0),
                    bottomLeft: Radius.circular(isArabic(context) ? 8 : 0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

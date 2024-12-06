import 'package:flutter/material.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/components/loading.dart';
import 'package:gymm/models/subscription.dart';
import 'package:gymm/screens/subscription_detail_screen.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/snack_bar.dart';
import 'package:async/async.dart';

class SubscriptionsHistoryPage extends StatefulWidget {
  const SubscriptionsHistoryPage({super.key, required this.id});

  final int id;

  @override
  State<SubscriptionsHistoryPage> createState() =>
      _SubscriptionsHistoryPageState();
}

class _SubscriptionsHistoryPageState extends State<SubscriptionsHistoryPage> {
  int currentPage = 1;
  bool loading = false;
  bool hasMore = true;
  late List<Subscription> subscriptions = [];

  CancelableOperation? _currentOperation;

  @override
  void initState() {
    super.initState();
    _loadMoreSubscriptions();
  }

  Future<void> _refreshSubscriptions() async {
    setState(() {
      subscriptions = [];
      currentPage = 1;
      hasMore = true;
    });
    await _loadMoreSubscriptions();
  }

  Future<void> _loadMoreSubscriptions() async {
    if (loading || !hasMore) return;
    setState(() {
      loading = true;
    });

    _currentOperation = CancelableOperation.fromFuture(
        getClientSubscriptionsHistory(widget.id, currentPage), onCancel: () {
      print("operation canceled");
    });

    _currentOperation!.value.then((value) {
      if (!mounted) return;

      final (List<Subscription> newSubscriptions, bool next) = value;
      setState(() {
        currentPage++;
        subscriptions.addAll(newSubscriptions);
        if (!next) {
          hasMore = false;
        }
      });
    }).catchError((e) {
      if (!mounted) return;
      showSnackBar(context, "Failed loading subscriptions history", "error");
    }).whenComplete(() {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _currentOperation?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Subscriptions History',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSubscriptions,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.extentAfter < 100) {
              _loadMoreSubscriptions();
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
                      childAspectRatio: 3, // Adjust height-to-width ratio
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: subscriptions.length,
                    itemBuilder: (context, index) {
                      final subscription = subscriptions[index];
                      return _buildSubscriptionBox(context, subscription);
                    },
                  ),
                  if (loading)
                    const Loading(
                      height: 100,
                    ),
                  if (!loading && subscriptions.isEmpty)
                    const Center(
                      child: Text(
                        "No History",
                        style: TextStyle(fontSize: 24),
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

  Widget _buildSubscriptionBox(
      BuildContext context, Subscription subscription) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                SubscriptionDetailsPage(subscription: subscription)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Left section: Subscription details
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: blackColor[900],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.plan.name,
                      textDirection: TextDirection.rtl,
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

            // Right section: Price
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: subscription.daysLeft() <= 0 || subscription.isExpired
                      ? Colors.red[500]
                      : subscription.startDate.isAfter(DateTime.now())
                          ? Colors.purpleAccent
                          : (subscription.isFrozen
                              ? primaryColor
                              : Colors.green),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    subscription.id.toString(),
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
          ],
        ),
      ),
    );
  }
}

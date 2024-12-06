import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/components/loading.dart';
import 'package:gymm/models/subscription_plan.dart';
import 'package:gymm/screens/subscription_plan_screen.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/snack_bar.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  int currentPage = 1;
  bool loading = false;
  bool hasMore = true;
  late List<SubscriptionPlan> plans = [];
  CancelableOperation? _currentOperation;

  @override
  void initState() {
    super.initState();
    _loadMorePlans();
  }

  @override
  void dispose() {
    super.dispose();
    _currentOperation?.cancel();
  }

  Future<void> _refreshPlans() async {
    setState(() {
      plans = [];
      currentPage = 1;
      hasMore = true;
    });
    await _loadMorePlans();
  }

  Future<void> _loadMorePlans() async {
    if (loading || !hasMore) return;
    setState(() {
      loading = true;
    });

    _currentOperation?.cancel();
    _currentOperation =
        CancelableOperation.fromFuture(getSubscriptionPlans(currentPage));

    _currentOperation!.value.then((value) {
      if (!mounted) return;

      final (List<SubscriptionPlan> newPlans, bool next) = value;
      setState(() {
        currentPage++;
        plans.addAll(newPlans);
        if (!next) {
          hasMore = false;
        }
      });
    }).catchError((e) {
      showSnackBar(context, "Failed loading plans", "error");
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
        title: const Text('Plans'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPlans,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.extentAfter < 100) {
              _loadMorePlans();
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
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      return _buildSubscriptionBox(context, plan);
                    },
                  ),
                  if (loading)
                    const Loading(
                      height: 100,
                    ),
                  if (!loading && plans.isEmpty)
                    const Center(
                      child: Text(
                        "No current Plans",
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

  Widget _buildSubscriptionBox(BuildContext context, SubscriptionPlan plan) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                SubscriptionPlanPage(subscriptionPlan: plan)));
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
                      plan.name,
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
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    "${plan.price}\nL.E",
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

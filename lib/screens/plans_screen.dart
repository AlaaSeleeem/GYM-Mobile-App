import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/components/loading.dart';
import 'package:gymm/models/subscription_plan.dart';
import 'package:gymm/screens/subscription_plan_screen.dart';
import 'package:gymm/theme/colors.dart';
import 'package:gymm/utils/snack_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/globals.dart';

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
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEndNotification) {
            if (scrollEndNotification.metrics.extentAfter < 100) {
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
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.noPlans,
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
        child: Stack(
          children: [
            Row(
              children: [
                // Left section: Subscription details
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: blackColor[900],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(isArabic(context) ? 16 : 0),
                        bottomRight:
                            Radius.circular(isArabic(context) ? 16 : 0),
                        topLeft: Radius.circular(isArabic(context) ? 0 : 16),
                        bottomLeft: Radius.circular(isArabic(context) ? 0 : 16),
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
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(isArabic(context) ? 0 : 16),
                        bottomRight:
                            Radius.circular(isArabic(context) ? 0 : 16),
                        topLeft: Radius.circular(isArabic(context) ? 16 : 0),
                        bottomLeft: Radius.circular(isArabic(context) ? 16 : 0),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: (plan.discount != null)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                  plan.price.toInt().toString(),
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${(plan.price - (plan.discount! * plan.price / 100)).toInt()}',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: blackColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.pound,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                  ),
                                ),
                              ])
                        : Center(
                            child: Text(
                              "${(plan.price.toInt())}\n${AppLocalizations.of(context)!.pound}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
            if (plan.discount != null)
              Positioned(
                top: 10,
                left: isArabic(context) ? null : 10,
                right: isArabic(context) ? 10 : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${(plan.discount!.toInt())}% ${AppLocalizations.of(context)!.off}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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

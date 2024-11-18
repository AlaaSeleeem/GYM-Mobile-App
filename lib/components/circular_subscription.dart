import 'package:flutter/material.dart';
import 'package:gymm/models/subscriptions.dart';
import 'package:gymm/screens/subscription_detail_screen.dart';
import 'package:gymm/theme/colors.dart';

class CircularSubscription extends StatefulWidget {
  const CircularSubscription({super.key, required this.subscription});

  final Subscription subscription;

  @override
  State<CircularSubscription> createState() => _CircularSubscriptionState();
}

class _CircularSubscriptionState extends State<CircularSubscription>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _updateSubscriptionDetails(widget.subscription);
  }

  void _updateSubscriptionDetails(Subscription subscription) {
    // if (selectedSubscriptionType == "Basic Plan") {
    //   totalDays = 30;
    //   daysUsed = 12;
    //   subscriptionStartDate = DateTime.now().subtract(Duration(days: 10));
    //   subscriptionEndDate = DateTime.now().add(Duration(days: 20));
    // } else {
    //   totalDays = 15;
    //   daysUsed = 5;
    //   subscriptionStartDate = DateTime.now().subtract(Duration(days: 5));
    //   subscriptionEndDate = DateTime.now().add(Duration(days: 10));
    // }
    // daysLeft = totalDays - daysUsed;

    _animation = Tween<double>(
            begin: 0.0,
            end: subscription.attendanceDays.toDouble() /
                subscription.totalDays())
        .animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Subscription subscription = widget.subscription;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          // Navigate to a details page when the component is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SubscriptionDetailsPage(subscription: subscription),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return SizedBox(
                        height: 250,
                        width: 250,
                        child: CircularProgressIndicator(
                          value: _animation.value,
                          backgroundColor: Colors.grey[800],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            subscription.daysLeft() <= 0
                                ? Colors.red
                                : (subscription.attendanceDays >=
                                        subscription.totalDays() * 0.9
                                    ? Colors.red
                                    : Colors.green),
                          ),
                        ),
                      );
                    },
                  ),
                  // Render details based on `is_duration`
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subscription.plan.name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subscription.remaining(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      if (subscription.daysLeft() <= 1)
                        const Column(
                          children: [
                            SizedBox(height: 8),
                            Text(
                              'Expires',
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(height: 4),
                            Icon(
                              Icons.add_alert,
                              color: Colors.red,
                              size: 24,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

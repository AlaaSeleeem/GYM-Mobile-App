import 'package:flutter/material.dart';
import 'package:gymm/models/subscription.dart';
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
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _updateSubscriptionDetails(widget.subscription);
  }

  @override
  void didUpdateWidget(covariant CircularSubscription oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.subscription != oldWidget.subscription) {
      _updateSubscriptionDetails(widget.subscription);
    }
  }

  void _updateSubscriptionDetails(Subscription subscription) {
    _animation = Tween<double>(
            begin: 0.0,
            end: subscription.attendanceDays.toDouble() /
                subscription.totalDays())
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
    _controller.forward();
  }

  Color _getIndicatorColor(Subscription sub) {
    // Subscription sub = widget.subscription;
    if (sub.isExpired) return Colors.red[500]!;
    if (sub.startDate.isAfter(DateTime.now())) return Colors.purpleAccent;
    if (sub.isFrozen) return primaryColor;
    return Colors.green;
  }

  Widget _timingDetails(Subscription sub) {
    return Column(children: [
      // start|end dates
      Text(
        sub.startDate.isAfter(DateTime.now())
            ? "Starts: ${sub.startDate.day}-${sub.startDate.month}-${sub.startDate.year}"
            : "Expires: ${sub.endDate?.day}-${sub.endDate?.month}-${sub.endDate?.year}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 8),
      if (sub.startDate.isAfter(DateTime.now()))
        const Text(
          "Waiting",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.purpleAccent,
            fontSize: 16,
          ),
        ),
      if (!sub.isExpired && sub.startDate.isBefore(DateTime.now()))
        Text(
          sub.remaining(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: sub.daysLeft() <= 1 ? Colors.red : primaryColor,
            fontSize: 16,
          ),
        ),
      if (sub.isExpired)
        const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_alert,
                  color: Colors.red,
                  size: 24,
                ),
                SizedBox(width: 4),
                Text(
                  'Expired',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ],
        )
    ]);
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
                          strokeWidth: 8,
                          value: subscription.isExpired ? 1 : _animation.value,
                          backgroundColor: Colors.grey[800],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            subscription.daysLeft() <= 0 ||
                                    subscription.isExpired
                                ? Colors.red
                                : (subscription.isFrozen
                                    ? primaryColor
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
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 120),
                        child: Text(
                          subscription.plan.name,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${subscription.id}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _timingDetails(subscription),
                    ],
                  ),
                  Positioned(
                      top: 40,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: _getIndicatorColor(subscription),
                            shape: BoxShape.circle),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

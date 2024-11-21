import 'package:flutter/material.dart';
import 'package:gymm/theme/colors.dart';
import '../models/subscriptions.dart';

class SubscriptionDetailsPage extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionDetailsPage({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subscription: ${subscription.id}"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subscription.plan.name,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                "Code: ${subscription.id}",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Status: ${subscription.isExpired ? "Expired" : subscription.isFrozen ? "Frozen" : "Active"}",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Start Date: "
                "${subscription.startDate.day}"
                "-${subscription.startDate.month}"
                "-${subscription.startDate.year}",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Start Date: "
                "${subscription.endDate?.day}"
                "-${subscription.endDate?.month}"
                "-${subscription.endDate?.year}",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Attendance: ${subscription.attendanceDays} "
                "${subscription.plan.isDuration ? "Days" : "Classes"}",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                subscription.remaining(),
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Freezable: ${subscription.plan.freezable ? "Yes" : "No"}",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              if (subscription.plan.freezable)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      "Max Freeze Days: ${subscription.plan?.freezeNo} Days",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Freeze Days Used: ${subscription.freezeDaysUsed} Days",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              Text(
                "Invitations: ${subscription.plan.invitations}",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              if (subscription.plan.description != null &&
                  subscription.plan.description!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 26),
                    const Text(
                      'Description:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subscription.plan.description!,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

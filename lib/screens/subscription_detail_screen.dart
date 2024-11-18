import 'package:flutter/material.dart';
import '../models/subscriptions.dart';

class SubscriptionDetailsPage extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionDetailsPage({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subscription.plan.name),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${subscription.plan.name}',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              subscription.remaining(),
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            if (subscription.plan.description != null &&
                subscription.plan.description!.isNotEmpty)
              SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              subscription.plan.description ?? 'No description available.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

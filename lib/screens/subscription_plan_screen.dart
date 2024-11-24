import 'package:flutter/material.dart';
import 'package:gymm/theme/colors.dart';
import '../models/subscription_plan.dart';

class SubscriptionPlanPage extends StatelessWidget {
  final SubscriptionPlan subscriptionPlan;

  const SubscriptionPlanPage({super.key, required this.subscriptionPlan});

  @override
  Widget build(BuildContext context) {
    // Define the parameters to display
    final List<Map<String, dynamic>> details = [
      {
        "icon": Icons.attach_money,
        "label": "Price",
        "value": subscriptionPlan.price.toStringAsFixed(2)
      },
      {
        "icon": Icons.calendar_today,
        "label": "Duration",
        "value": subscriptionPlan.isDuration
            ? "${subscriptionPlan.days} Days"
            : "${subscriptionPlan.classesNo} Classes"
      },
      {
        "icon": Icons.timer_off_outlined,
        "label": "Freezable",
        "value": subscriptionPlan.freezable ? "Yes" : "No"
      },
      if (subscriptionPlan.freezable)
        {
          "icon": Icons.lock,
          "label": "Freeze No",
          "value": subscriptionPlan.freezeNo ?? "N/A"
        },
      {
        "icon": Icons.people,
        "label": "Invitations",
        "value": subscriptionPlan.invitations
      },
      {
        "icon": Icons.school,
        "label": "For Students",
        "value": subscriptionPlan.forStudents ? "Yes" : "No"
      },
      {
        "icon": Icons.timelapse,
        "label": "Validity",
        "value": "${subscriptionPlan.validity} Days"
      }
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Plan Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subscriptionPlan.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              LayoutBuilder(builder: (context, constraints) {
                final int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 3 / 2.5, // Adjust for card shape
                  ),
                  itemCount: details.length,
                  itemBuilder: (context, index) {
                    final detail = details[index];
                    return Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: blackColor[900],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              detail["icon"] as IconData,
                              size: 36.0,
                              color: primaryColor,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              detail["value"].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              detail["label"] as String,
                              style: TextStyle(
                                color: blackColor[500],
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
              if (subscriptionPlan.description != null && subscriptionPlan.description!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 10),
                      child: Text(
                        subscriptionPlan.description!,
                        style: const TextStyle(
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

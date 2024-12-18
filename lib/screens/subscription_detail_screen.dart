import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymm/screens/invitations_screen.dart';
import 'package:gymm/theme/colors.dart';
import '../models/subscription.dart';

class SubscriptionDetailsPage extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionDetailsPage({super.key, required this.subscription});

  TableRow _buildRow(
      {required String title,
      required String value,
      Color color = Colors.white}) {
    return TableRow(children: [
      ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40),
        child: Row(
          children: [
            Expanded(
                child: Text(
              title,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ))
          ],
        ),
      ),
      ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Text(
              value,
              style: TextStyle(fontSize: 20, color: color),
            ))
          ],
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subscription: ${subscription.id}"),
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
              const SizedBox(height: 12),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.7),
                  1: FlexColumnWidth(3)
                },
                children: [
                  // Code
                  _buildRow(title: "Code", value: subscription.id.toString()),

                  // Status
                  _buildRow(
                      title: "Status",
                      value: subscription.isExpired
                          ? "Expired"
                          : subscription.startDate.isAfter(DateTime.now())
                              ? "Waiting"
                              : subscription.isFrozen
                                  ? "Frozen"
                                  : "Active",
                      color: subscription.isExpired
                          ? Colors.red
                          : subscription.startDate.isAfter(DateTime.now())
                              ? Colors.purpleAccent
                              : subscription.isFrozen
                                  ? primaryColor
                                  : Colors.green),

                  // Start date
                  _buildRow(
                      title: "Start Date",
                      value: "${subscription.startDate.day}"
                          "-${subscription.startDate.month}"
                          "-${subscription.startDate.year}"),

                  // End date
                  _buildRow(
                      title: "End Date",
                      value: "${subscription.endDate?.day}"
                          "-${subscription.endDate?.month}"
                          "-${subscription.endDate?.year}"),

                  // Attendance
                  _buildRow(
                      title: "Attendance",
                      value:
                          "${subscription.attendanceDays} ${subscription.plan.isDuration ? "Days" : "Classes"}"),

                  // Remaining
                  _buildRow(
                      title: "Remaining",
                      value: subscription.remaining(prefix: false)),

                  // Remaining
                  _buildRow(
                      title: "Freezable",
                      value: subscription.plan.freezable ? "Yes" : "No"),

                  // Max freeze days
                  if (subscription.plan.freezable)
                    _buildRow(
                        title: "Max Freeze Days",
                        value: "${subscription.plan.freezeNo} Days"),

                  // Freeze days used
                  if (subscription.plan.freezable)
                    _buildRow(
                        title: "Freeze Days Used",
                        value: "${subscription.freezeDaysUsed} Days"),

                  // Invitations
                  _buildRow(
                      title: "Invitations",
                      value: "${subscription.plan.invitations}"),
                ],
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
                ),
              const SizedBox(height: 40),
              if (!subscription.isExpired &&
                  subscription.plan.invitations > 0 &&
                  !subscription.startDate.isAfter(DateTime.now()) &&
                  !subscription.isFrozen)
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: blackColor[800],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    icon: const Icon(
                      FontAwesomeIcons.solidEnvelope,
                      size: 26,
                    ),
                    label: const Text(
                      "Manage Invitations",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InvitationsPage(
                                subId: subscription.id,
                              )));
                    },
                  ),
                )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

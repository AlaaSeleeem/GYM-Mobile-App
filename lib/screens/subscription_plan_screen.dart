import 'package:flutter/material.dart';
import 'package:gymm/theme/colors.dart';
import '../models/subscription_plan.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubscriptionPlanPage extends StatelessWidget {
  final SubscriptionPlan subscriptionPlan;

  const SubscriptionPlanPage({super.key, required this.subscriptionPlan});

  @override
  Widget build(BuildContext context) {
    // Define the parameters to display
    final List<Map<String, dynamic>> details = [
      {
        "icon": Icons.attach_money,
        "label": AppLocalizations.of(context)!.price,
        "value": subscriptionPlan.price.toStringAsFixed(2)
      },
      {
        "icon": Icons.calendar_today,
        "label": AppLocalizations.of(context)!.duration,
        "value": subscriptionPlan.isDuration
            ? "${subscriptionPlan.days} ${AppLocalizations.of(context)!.days}"
            : "${subscriptionPlan.classesNo} ${AppLocalizations.of(context)!.classes}"
      },
      {
        "icon": Icons.timer_off_outlined,
        "label": AppLocalizations.of(context)!.freezable,
        "value": subscriptionPlan.freezable
            ? AppLocalizations.of(context)!.yes
            : AppLocalizations.of(context)!.no
      },
      if (subscriptionPlan.freezable)
        {
          "icon": Icons.lock,
          "label": AppLocalizations.of(context)!.freezeNo,
          "value": subscriptionPlan.freezeNo ?? AppLocalizations.of(context)!.na
        },
      {
        "icon": Icons.people,
        "label": AppLocalizations.of(context)!.invitations,
        "value": subscriptionPlan.invitations
      },
      {
        "icon": Icons.school,
        "label": AppLocalizations.of(context)!.forStudents,
        "value": subscriptionPlan.forStudents
            ? AppLocalizations.of(context)!.yes
            : AppLocalizations.of(context)!.no
      },
      {
        "icon": Icons.timelapse,
        "label": AppLocalizations.of(context)!.validity,
        "value":
            "${subscriptionPlan.validity} ${AppLocalizations.of(context)!.days}"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.planDetails),
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
                    return ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 300),
                      child: Container(
                        // height: 300,
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
                              if (detail['label'] ==
                                      AppLocalizations.of(context)!.price &&
                                  subscriptionPlan.discount != null) ...[
                                Text(
                                  detail["value"].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.red,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.white,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      decorationThickness: 1.3),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  detail["value"].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ] else
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
                      ),
                    );
                  },
                );
              }),
              if (subscriptionPlan.description != null &&
                  subscriptionPlan.description!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      AppLocalizations.of(context)!.descriptions,
                      style: const TextStyle(
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

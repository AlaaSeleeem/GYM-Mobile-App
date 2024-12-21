import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.exercises,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEndNotification) {
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.comingSoon,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercises',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEndNotification) {
            return false;
          },
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                "Coming Soon ...",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

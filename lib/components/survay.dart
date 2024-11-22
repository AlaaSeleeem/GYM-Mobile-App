import 'package:flutter/material.dart';

// المتغيرات لتخزين تقييمات الأسئلة
int _serviceRating = 0;
int _trainerRating = 0;
int _scheduleRating = 0;
int _equipmentRating = 0;
int _staffRating = 0;
String _feedbackNotes = '';

void _showSurveyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              'Rate Our Service',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // أسئلة التقييم
                  _buildRatingQuestion('Service', _serviceRating, (int value) {
                    setState(() {
                      _serviceRating = value;
                    });
                  }),
                  _buildRatingQuestion('Trainer', _trainerRating, (int value) {
                    setState(() {
                      _trainerRating = value;
                    });
                  }),
                  _buildRatingQuestion('Schedule', _scheduleRating,
                      (int value) {
                    setState(() {
                      _scheduleRating = value;
                    });
                  }),
                  _buildRatingQuestion('Equipment', _equipmentRating,
                      (int value) {
                    setState(() {
                      _equipmentRating = value;
                    });
                  }),
                  _buildRatingQuestion('Staff', _staffRating, (int value) {
                    setState(() {
                      _staffRating = value;
                    });
                  }),

                  // خانة الملاحظات
                  TextField(
                    onChanged: (text) {
                      _feedbackNotes = text;
                    },
                    decoration: InputDecoration(
                      labelText: 'Additional Notes',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // هنا يمكنك إضافة كود لحفظ التقييم في قاعدة البيانات
                  print('Service Rating: $_serviceRating');
                  print('Trainer Rating: $_trainerRating');
                  print('Schedule Rating: $_scheduleRating');
                  print('Equipment Rating: $_equipmentRating');
                  print('Staff Rating: $_staffRating');
                  print('Feedback Notes: $_feedbackNotes');

                  Navigator.of(context).pop();
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.yellow),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildRatingQuestion(
    String question, int currentRating, ValueChanged<int> onRatingChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        question,
        style: TextStyle(color: Colors.white),
      ),
      Row(
        children: List.generate(5, (index) {
          return IconButton(
            icon: Icon(
              index < currentRating ? Icons.star : Icons.star_border,
              color: Colors.yellow,
            ),
            onPressed: () {
              onRatingChanged(index + 1);
            },
          );
        }),
      ),
    ],
  );
}

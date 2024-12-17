import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  ActionButton(
      {super.key,
        required this.title,
        required this.action,
        this.buttonColor,
        this.buttonWidth,
        this.buttonHight,
        this.titleStyle});
  String title;
  Color? buttonColor;
  Function() action;
  double? buttonWidth;
  double? buttonHight;
  TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHight,
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: action,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(buttonColor ?? const Color.fromARGB(1000, 63, 65, 78)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        child: Text(
          title,
          style: titleStyle,
        ),
      ),
    );
  }
}

class ActionButtonWithIcon extends StatelessWidget {
  ActionButtonWithIcon(
      {super.key,
        required this.title,
        required this.icon,
        required this.action,
        this.buttonColor});
  String title;
  Color? buttonColor;
  IconData icon;
  Function() action;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: action,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(buttonColor ?? const Color.fromARGB(1000, 63, 65, 78)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(
        title,
       
      ),
    );
  }
}

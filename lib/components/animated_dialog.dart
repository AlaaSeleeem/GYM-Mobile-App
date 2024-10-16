import 'package:flutter/material.dart';

class AnimatedDialog extends StatefulWidget {
  final String productName;

  const AnimatedDialog({super.key, required this.productName});

  @override
  AnimatedDialogState createState() {
    return AnimatedDialogState();
  }
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..forward();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Icon(Icons.check_circle, color: Colors.yellow, size: 40),
            ),
            SizedBox(height: 8),
            Text('Product Added', style: TextStyle(color: Colors.yellow)),
          ],
        ),
        content: Text('${widget.productName} has been added to your cart.',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center),
      ),
    );
  }
}

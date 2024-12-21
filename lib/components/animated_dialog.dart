import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Column(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Icon(Icons.check_circle, color: Colors.yellow, size: 40),
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.productAdded,
                style: const TextStyle(color: Colors.yellow)),
          ],
        ),
        content: Text(
            '${widget.productName} ${AppLocalizations.of(context)!.addedToCart}.',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center),
      ),
    );
  }
}

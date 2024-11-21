import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key, this.height, this.width});

  final double? height;
  final double? width;

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 16,
            ),
            CircularProgressIndicator(),
            SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gymm/components/circular_subscription.dart';
import 'package:gymm/theme/colors.dart';

class MultipleSubscriptions extends StatefulWidget {
  final List<dynamic>
      subscriptions; // Replace 'dynamic' with your subscription model type

  const MultipleSubscriptions({super.key, required this.subscriptions});

  @override
  State<MultipleSubscriptions> createState() => _MultipleSubscriptionsState();
}

class _MultipleSubscriptionsState extends State<MultipleSubscriptions> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 315,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.subscriptions.length,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return CircularSubscription(
                subscription: widget.subscriptions[index],
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.subscriptions.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage == index ? 20 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? primaryColor
                    : blackColor[500],
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

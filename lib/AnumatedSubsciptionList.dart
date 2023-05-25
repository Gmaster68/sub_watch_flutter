import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sub_watch_flutter/colors.dart';
import 'package:sub_watch_flutter/subscription.dart';
import 'package:sub_watch_flutter/subscription_widgets.dart';

class AnimatedSubscriptionList extends StatefulWidget {
  final List<Subscription> subscriptions;

  AnimatedSubscriptionList({required this.subscriptions});

  @override
  _AnimatedSubscriptionListState createState() =>
      _AnimatedSubscriptionListState();
}

class _AnimatedSubscriptionListState extends State<AnimatedSubscriptionList>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _offsetAnimations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(widget.subscriptions.length, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 350),
        vsync: this,
      );
    });

    _offsetAnimations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.subscriptions.asMap().entries.map((entry) {
        int index = entry.key;
        Subscription subscription = entry.value;
        return SlideTransition(
            position: _offsetAnimations[index],
            child: SubscriptionWidgets.subscriptionItem(subscription));
      }).toList(),
    );
  }
}

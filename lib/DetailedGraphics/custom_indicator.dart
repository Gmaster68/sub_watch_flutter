import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({Key? key}) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabController = DefaultTabController.of(context);

    return TabBar(
      tabs: const <Widget>[
        Tab(icon: Icon(Icons.home, size: 30)),
        Tab(icon: Icon(Icons.list, size: 30)),
        Tab(icon: Icon(Icons.bar_chart, size: 30)),
      ],
      controller: tabController,
      indicatorColor: Colors.orange,
      indicatorSize: TabBarIndicatorSize.label,
      enableFeedback: true,
    );
  }
}

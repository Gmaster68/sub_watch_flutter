import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sub_watch_flutter/DetailedGraphics/custom_indicator.dart';
import 'package:sub_watch_flutter/Pages/home_page.dart';
import 'package:sub_watch_flutter/Pages/subscription_budget_page.dart';
import 'package:sub_watch_flutter/Pages/subscription_list_page.dart';
import 'package:sub_watch_flutter/Utils/colors.dart';
import 'package:sub_watch_flutter/Utils/constants.dart';
import 'package:sub_watch_flutter/model/subscription.dart';
import '../Database/auth_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  List<Subscription> subscriptions = [];
  int currIndex = 0;
  bool isMenuOpen = false;
  late TabController _tabController;
  late final AnimationController _animationController;
  final screens = const [
    HomePage(),
    SubscriptionListPage(),
    BudgetPage(),
  ];
  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return Text(
      'SubWatch',
      style: Constants.basicTextStyle(),
    );
  }

  Widget _drawerHeader() {
    return const SizedBox(
      height: 65,
      child: DrawerHeader(
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        child: Text(
          'Menu',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Builder(
        builder: (BuildContext context) {
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
          ));
          return SafeArea(
            child: Container(
              color: Colors.black,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _drawerHeader(),
                  ListTile(
                    leading: const Icon(Icons.home, color: AppColors.textColor),
                    title: Text(
                      'Home',
                      style: Constants.basicTextStyle().copyWith(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.settings, color: AppColors.textColor),
                    title: Text(
                      'Settings',
                      style: Constants.basicTextStyle().copyWith(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.power_settings_new_outlined,
                        color: AppColors.textColor),
                    title: Text(
                      'Sign Out',
                      style: Constants.basicTextStyle().copyWith(fontSize: 16),
                    ),
                    onTap: () {
                      signOut();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      backgroundColor: AppColors.secondaryColor,
      title: _title(),
      centerTitle: true,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: AppColors.backgroundColor),
      child: DefaultTabController(
        length: screens.length,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: _appBar(),
          drawer: Constants.drawer(context),
          body: TabBarView(
            children: screens,
          ),
          bottomNavigationBar: const CustomTabBar(),
        ),
      ),
    );
  }
}

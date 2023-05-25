import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sub_watch_flutter/AnumatedSubsciptionList.dart';
import 'package:sub_watch_flutter/add_subscription_page.dart';
import 'package:sub_watch_flutter/colors.dart';
import 'package:sub_watch_flutter/subscription.dart';
import './auth_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Subscription> subscriptions = List.empty();
  final User? user = Auth().currentUser;
  bool isMenuOpen = false;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text(
      'SubWatch',
      style: TextStyle(color: AppColors.textColor, fontFamily: 'OpenSans'),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(AppColors.secondaryColor),
          backgroundColor:
              MaterialStateProperty.all<Color>(AppColors.accentColor)),
      child: const Text(
        'Sign out',
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor),
      ),
    );
  }

  Future<List<Subscription>> fetchSubscriptions(String? userId) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('users/$userId');

    DatabaseEvent event = await databaseReference.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> subscriptionsData = event.snapshot.value as Map;
      List<Subscription> subscriptions = [];

      subscriptionsData.forEach((key, value) {
        Subscription subscription = Subscription.fromMap(value);
        subscriptions.add(subscription);
      });

      return subscriptions;
    } else {
      return [];
    }
  }

  Widget subItemList() {
    return FutureBuilder<List<Subscription>>(
      future: fetchSubscriptions(user?.uid),
      builder:
          (BuildContext context, AsyncSnapshot<List<Subscription>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Subscription> subList = snapshot.data ?? [];

          if (subList.isEmpty) {
            return const Text('No elements added!');
          }

          return AnimatedSubscriptionList(subscriptions: subList);
        }
      },
    );
  }

  Widget _drawerHeader() {
    return const SizedBox(
      height: 70,
      child: DrawerHeader(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
        ),
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

  // Widget _drawer(BuildContext context) {
  //   return Drawer(
  //     child: SafeArea(
  //       child: Container(
  //         color: AppColors.backgroundColor,
  //         child: ListView(
  //           padding: EdgeInsets.zero,
  //           children: <Widget>[
  //             _drawerHeader(),
  //             ListTile(
  //               leading: const Icon(Icons.home, color: AppColors.textColor),
  //               title: const Text(
  //                 'Home',
  //                 style: TextStyle(
  //                   color: AppColors.textColor,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.settings, color: AppColors.textColor),
  //               title: const Text(
  //                 'Settings',
  //                 style: TextStyle(
  //                   color: AppColors.textColor,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Builder(
        builder: (BuildContext context) {
          // Set the status bar color to match the drawer when it's opened
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor:
                Colors.black, // Change this to match your drawer color
          ));
          return SafeArea(
            child: Container(
              color: Colors.black, // Sets the background color to black
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _drawerHeader(),
                  ListTile(
                    leading: const Icon(Icons.home, color: AppColors.textColor),
                    title: const Text(
                      'Home',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.settings, color: AppColors.textColor),
                    title: const Text(
                      'Settings',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
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

  Widget yourSubscriptions() {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: const Text(
          'Your Subscriptions:',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.textColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: AppColors.backgroundColor),
      child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
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
            actions: [_signOutButton()],
          ),
          body: Builder(
            builder: (BuildContext context) {
              return SafeArea(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      yourSubscriptions(),
                      subItemList(),
                      addASub()
                    ],
                  ),
                ),
              );
            },
          ),
          drawer: _drawer(context)),
    );
  }

  final ButtonStyle addSubBtnStyle = ElevatedButton.styleFrom(
      elevation: 1,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))));

  Widget addASub() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddSubscription(
                      userId: user!.uid,
                    )));
      },
      style: addSubBtnStyle.copyWith(
          backgroundColor:
              const MaterialStatePropertyAll(AppColors.primaryColor)),
      label: const Text(
        'Create A Subscription',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontFamily: 'OpenSans'),
      ),
      icon: const Icon(
        Icons.add_box_outlined,
        color: AppColors.accentColor,
      ),
    );
  }
}

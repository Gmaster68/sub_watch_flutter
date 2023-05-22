import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:sub_watch_flutter/AnumatedSubsciptionList.dart';
import 'package:sub_watch_flutter/colors.dart';
import 'package:sub_watch_flutter/subscription.dart';
import './auth_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Subscription> subscriptions = List.empty();
  final User? user = Auth().currentUser;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

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
        print("first addition of $subscription");
        subscriptions.add(subscription);
      });

      return subscriptions;
    } else {
      return []; // Return an empty list if no subscriptions found
    }
  }

  TextStyle _subItemLabelStyle() {
    return const TextStyle(
        color: AppColors.textColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans');
  }

  TextStyle _subItemElementStyle() {
    return const TextStyle(
      color: AppColors.textColor,
      fontFamily: 'OpenSans',
    );
  }

  Widget _subItemElement(String labelName, String elementName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(labelName, style: _subItemLabelStyle()),
        Text(elementName, style: _subItemElementStyle())
      ],
    );
  }

  Widget _subscriptionItem(Subscription subscription) {
    return Container(
        padding: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.accentColor),
            color: AppColors.secondaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                //COLUMN1: Sub type, with type name
                children: [
                  _subscriptionType(subscription.subscriptionType),
                  Text(
                    subscription.subscriptionType,
                  )
                ]),
            const VerticalDivider(
              color: AppColors.accentColor,
              thickness: 1,
            ),
            Column(
              //COLUMN2: Sub name, price, date, all other detes.
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _subItemElement('Name:', subscription.name),
                _subItemElement('Date of subscription: ',
                    subscription.formatDate(subscription.acquisitionDate)),
                _subItemElement('Day of payment',
                    subscription.monthlyPaymentDay.toString()),
                _subItemElement('Price', subscription.price.toString()),
              ],
            )
          ],
        ));
  }

  Widget _subscriptionType(String subscriptionType) {
    Icon icon;
    switch (subscriptionType) {
      case 'MUSIC':
        icon = const Icon(Icons.music_note, size: 20);
        break;
      case 'MOVIES':
        icon = const Icon(Icons.movie, size: 20);
        break;
      case 'BOOKS':
        icon = const Icon(Icons.book, size: 20);
        break;
      case 'GAMES':
        icon = const Icon(Icons.gamepad_rounded, size: 20);
        break;
      case 'DATING':
        icon = const Icon(Icons.heat_pump_rounded, size: 20);
        break;
      case 'EDUCATION':
        icon = const Icon(Icons.school, size: 20);
        break;
      case 'FOOD':
        icon = const Icon(Icons.local_pizza, size: 20);
        break;
      case 'MISCELLANEOUS':
        icon = const Icon(Icons.miscellaneous_services, size: 20);
        break;
      default:
        icon = const Icon(Icons.error, size: 20);
    }
    return icon;
  }

  Widget subItemList() {
    return FutureBuilder<List<Subscription>>(
      future: fetchSubscriptions(user?.uid),
      builder:
          (BuildContext context, AsyncSnapshot<List<Subscription>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading spinner while waiting
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show an error message if something went wrong
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: _title(),
        actions: [_signOutButton()],
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              subItemList(),
            ],
          )),
    );
  }
}

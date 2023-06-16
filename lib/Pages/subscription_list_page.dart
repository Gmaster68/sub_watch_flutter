import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sub_watch_flutter/Database/subscription_db_retrieval.dart';
import 'package:sub_watch_flutter/Utils/constants.dart';

import '../SubscriptionModelling/AnumatedSubsciptionList.dart';
import '../Database/auth_page.dart';
import '../Utils/colors.dart';
import '../model/subscription.dart';
import 'add_subscription_page.dart';

class SubscriptionListPage extends StatefulWidget {
  const SubscriptionListPage({Key? key}) : super(key: key);

  State<SubscriptionListPage> createState() => _SubscriptionListPageState();
}

class _SubscriptionListPageState extends State<SubscriptionListPage> {
  // List<Subscription> subscriptions = List.empty();
  final User? user = Auth().currentUser;

  Widget yourSubscriptions() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text('Your Subscriptions:',
          style: Constants.basicTextStyle()
              .copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      userId: Auth().getCurrentUserId(),
                    )));
      },
      style: addSubBtnStyle.copyWith(
          backgroundColor:
              const MaterialStatePropertyAll(AppColors.primaryColor)),
      label: Text(
        'Create A Subscription',
        style: Constants.basicTextStyle().copyWith(fontSize: 16),
      ),
      icon: const Icon(
        Icons.add_box_outlined,
        color: AppColors.accentColor,
      ),
    );
  }

  Widget yourSubscriptionsBodyListWidget() {
    return FutureBuilder<List<Subscription>>(
      future: SubscriptionsDataHandler().fetchSubscriptions(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Subscription>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Subscription> subList = snapshot.data ?? [];
          return Column(
            children: [
              yourSubscriptions(),
              Expanded(
                child: Stack(
                  children: [
                    subList.isEmpty
                        ? const Text('No elements added!')
                        : AnimatedSubscriptionList(subscriptions: subList),
                    Positioned(
                      bottom: 16.0,
                      right: 16.0,
                      child: addASub(),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: yourSubscriptionsBodyListWidget()),
        );
      },
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../Database/auth_page.dart';
import '../model/subscription.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  List<Subscription> subscriptions = List.empty();
  final User? user = Auth().currentUser;
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Text('something something');
  }
}

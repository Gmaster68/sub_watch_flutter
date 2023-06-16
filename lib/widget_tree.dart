import 'package:flutter/material.dart';

import 'Database/auth_page.dart';
import 'Pages/start_page.dart';
import 'Pages/login_register_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const StartPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

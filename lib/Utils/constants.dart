import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_watch_flutter/Pages/start_page.dart';
import 'package:sub_watch_flutter/Utils/colors.dart';

import '../Database/auth_page.dart';

class Constants {
  static TextStyle basicTextStyle() {
    return GoogleFonts.openSans().copyWith(color: AppColors.textColor);
  }

  static Widget _drawerHeader() {
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

  static Widget drawer(BuildContext context) {
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StartPage()));
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

  static Future<void> signOut() async {
    await Auth().signOut();
  }
}

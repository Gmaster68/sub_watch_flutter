import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sub_watch_flutter/colors.dart';
import './auth_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _obscurePassword = true;

  Future<void> signInWithEmailAndPassword() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _welcomeMessage() {
    return const Text(
      'Welcome Aboard!',
      style: TextStyle(
          color: Color(0xfafafafa),
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: 'Opensans'),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          style: const TextStyle(color: AppColors.textColor),
          decoration: InputDecoration(
              fillColor: AppColors.secondaryColor,
              filled: true,
              hintText: title,
              hintStyle: const TextStyle(
                  color: Color.fromARGB(249, 113, 107, 107),
                  fontFamily: 'OpenSans'),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accentColor)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade600))),
          controller: controller,
        ));
  }

  Widget _entryPasswordField(String title, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          obscureText: _obscurePassword,
          style: const TextStyle(color: AppColors.textColor),
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  color: AppColors.accentColor,
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  }),
              fillColor: AppColors.secondaryColor,
              filled: true,
              hintText: title,
              hintStyle: const TextStyle(
                  color: Color.fromARGB(249, 113, 107, 107),
                  fontFamily: 'OpenSans'),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accentColor)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade600))),
          controller: controller,
        ));
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Error: $errorMessage');
  }

  Widget _submitButton() {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppColors.primaryColor)),
          onPressed: isLogin
              ? signInWithEmailAndPassword
              : createUserWithEmailAndPassword,
          child: Text(
            isLogin ? 'Login' : 'Register',
            style: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.w600),
          )),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColors.secondaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)))),
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(
          isLogin
              ? 'First time here? Register instead!'
              : 'You have an accout? Login instead!',
          style: const TextStyle(
              color: AppColors.textColor, fontFamily: 'OpenSans'),
        ));
  }

  Widget _logoImage() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: 200,
            height: 200,
            color: AppColors.accentColor,
            child: Center(
              child: SvgPicture.asset(
                'assets/logo.svg',
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _welcomeMessage(),
            _logoImage(),
            _entryField('email', _controllerEmail),
            _entryPasswordField('password', _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sub_watch_flutter/colors.dart';

const List<String> list = <String>[
  'MOVIES',
  'MUSIC',
  'GAMING',
  'MISCELLANEOUS',
  'BOOKS',
  'DATING',
  'EDUCATION',
  'FOOD'
];

class AddSubscription extends StatefulWidget {
  const AddSubscription({super.key});

  @override
  State<AddSubscription> createState() => _AddSubscription();
}

class _AddSubscription extends State<AddSubscription> {
  final TextEditingController _nameController = TextEditingController();
  int _subscriptionPrice = 0;
  DateTime dateTime = DateTime.now();
  String subscriptionType = list.first;

  TextStyle _basicTextStyle() {
    return const TextStyle(color: AppColors.textColor, fontFamily: 'OpenSans');
  }

  Widget _selectSubscriptionType() {
    return DropdownButton<String>(
        icon: const Icon(Icons.keyboard_arrow_down),
        elevation: 16,
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            subscriptionType = value!;
          });
        });
  }

  Widget _setSubscriptionName(TextEditingController nameController) {
    return TextField(
      controller: nameController,
      style: _basicTextStyle().copyWith(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
          hintText: 'Name of subscription...',
          hintStyle: _basicTextStyle(),
          fillColor: AppColors.secondaryColor,
          filled: true,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.accentColor)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600))),
    );
  }

  Widget _setSubscriptionPrice(int numberInputElement) {
    return NumberPicker(
        minValue: 1,
        maxValue: 31,
        value: 1,
        onChanged: (int value) {
          setState(() {
            _subscriptionPrice = value;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sub_watch_flutter/colors.dart';
import 'package:sub_watch_flutter/subscription.dart';

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
  AddSubscription({required this.userId});
  final String userId;

  @override
  State<AddSubscription> createState() => _AddSubscription();
}

class _AddSubscription extends State<AddSubscription> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  var _subscriptionDay = 6;
  DateTime dateTime = DateTime.now();
  String subscriptionType = list.first;

  TextStyle _basicTextStyle() {
    return const TextStyle(color: AppColors.textColor, fontFamily: 'OpenSans');
  }

  Widget _selectSubscriptionType() {
    return DropdownButton<String>(
        isExpanded: true,
        iconSize: 40,
        hint: Text('Pick A Type', style: _basicTextStyle()),
        dropdownColor: AppColors.secondaryColor,
        icon: const Icon(
          Icons.arrow_drop_down_rounded,
          color: AppColors.primaryColor,
        ),
        elevation: 16,
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: _basicTextStyle(),
            ),
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

  Widget _setSubscriptionDay(int numberInputElement) {
    return Container(
      color: AppColors.secondaryColor,
      child: NumberPicker(
          minValue: 1,
          maxValue: 31,
          value: _subscriptionDay,
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'OpenSans',
              color: AppColors.accentColor),
          selectedTextStyle: const TextStyle(
              fontSize: 25,
              fontFamily: 'OpenSans',
              color: AppColors.primaryColor),
          axis: Axis.horizontal,
          onChanged: (int value) {
            setState(() {
              _subscriptionDay = value;
            });
          }),
    );
  }

  Widget _title() {
    return const Text(
      'Add A Subscription',
      style: TextStyle(color: AppColors.textColor, fontFamily: 'OpenSans'),
    );
  }

  Widget _setSupbscriptionDatePicker() {
    return MaterialButton(
      color: AppColors.primaryColor,
      onPressed: _setDatePicker,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Purchase Date',
            style: _basicTextStyle().copyWith(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  void _setDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2010),
            lastDate: DateTime.now())
        .then((value) => setState(() => dateTime = value!));
  }

  Widget _setSubscriptionPrice() {
    return TextField(
      controller: _priceController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: const InputDecoration(
        labelText: 'Price: ',
      ),
    );
  }

  void addSubscriptionToDB(String userId) {
    Subscription sub = Subscription(
        acquisitionDate: dateTime,
        monthlyPaymentDay: _subscriptionDay,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        subscriptionType: subscriptionType);

    sub.saveToDatabase(userId);
  }

  Widget _saveSubscriptionBtn() {
    return MaterialButton(
      color: AppColors.primaryColor,
      onPressed: () => {addSubscriptionToDB(widget.userId)},
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Save Subscription',
            style: _basicTextStyle().copyWith(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _title(),
        ),
        body: Column(
          children: [
            _selectSubscriptionType(),
            _setSubscriptionName(_nameController),
            _setSubscriptionDay(_subscriptionDay),
            _setSubscriptionPrice(),
            _setSupbscriptionDatePicker(),
            _saveSubscriptionBtn()
          ],
        ));
  }
}

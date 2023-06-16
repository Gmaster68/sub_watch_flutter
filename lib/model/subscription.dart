import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Subscription {
  late DateTime acquisitionDate;
  late int monthlyPaymentDay;
  late String name;
  late double price;
  late String subscriptionType;
  late double stars;
  late String notes;

  Subscription({
    required this.acquisitionDate,
    required this.monthlyPaymentDay,
    required this.name,
    required this.price,
    required this.subscriptionType,
    this.stars = 0,
    this.notes = '',
  });

  Subscription.setStars(this.stars);
  Subscription.setNotes(this.notes);

  Subscription.fromMap(Map<dynamic, dynamic> map) {
    acquisitionDate = DateTime.parse(map['acquisitionDate']);
    monthlyPaymentDay = map['monthlyPaymentDay'];
    name = map['name'];
    subscriptionType = map['subscriptionType'];
    price = map['price'].toDouble();
    stars = map.containsKey('stars') ? map['stars'].toDouble() : 0.0;
    notes = map['notes'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'acquisitionDate': acquisitionDate.toIso8601String(),
      'monthlyPaymentDay': monthlyPaymentDay,
      'subscriptionType': subscriptionType,
      'name': name,
      'price': price,
      'stars': stars,
      'notes': notes
    };
  }

  @override
  String toString() {
    return 'Subscription { '
        'acquisitionDate: $acquisitionDate, '
        'monthlyPaymentDay: $monthlyPaymentDay, '
        'name: $name, '
        'price: $price, '
        'subscriptionType: $subscriptionType '
        'stars: $stars'
        'notes: $notes'
        '}';
  }

  String formatDate() {
    return DateFormat('dd MM yyyy').format(acquisitionDate);
  }

  Future<bool> saveToDatabase(String userId) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref('subscriptions/$userId');

    DataSnapshot snapshot = (await databaseReference.once()).snapshot;
    if (snapshot.value != null) {
      // The data exists
      Map<dynamic, dynamic> values = Map.from(snapshot.value as Map);
      bool exists = false;
      values.forEach((key, value) {
        if (value['name'].toLowerCase() == toMap()['name'].toLowerCase()) {
          // The data already exists in the database
          exists = true;
        }
      });
      if (!exists) {
        // The data does not exist in the database, so we can add it
        databaseReference.push().set(toMap());
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "You already added a subscription from $name",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      }
    } else {
      // The data does not exist in the database, so we can add it
      databaseReference.push().set(toMap());
      return true;
    }
  }

  void updateSubscriptionByName(String userId) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child('users/$userId');

    // Get a snapshot of the subscriptions
    DataSnapshot snapshot = (await ref.once()) as DataSnapshot;

    Map<dynamic, dynamic> subscriptions = Map.from(snapshot.value as Map);
    subscriptions.forEach((key, value) {
      if (value['name'] == name) {
        // Update the subscription with the new data
        ref.child(key).update(toMap());
      }
    });
  }
}

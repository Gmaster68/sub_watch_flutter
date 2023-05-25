import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class Subscription {
  late DateTime acquisitionDate;
  late int monthlyPaymentDay;
  late String name;
  late double price;
  late String subscriptionType;

  Subscription({
    required this.acquisitionDate,
    required this.monthlyPaymentDay,
    required this.name,
    required this.price,
    required this.subscriptionType,
  });

  Subscription.fromMap(Map<dynamic, dynamic> map) {
    acquisitionDate = DateTime.parse(map['acquisitionDate']);
    monthlyPaymentDay = map['monthlyPaymentDay'];
    name = map['name'];
    subscriptionType = map['subscriptionType'];
    price = map['price'].toDouble();
  }

  Map<String, dynamic> toMap() {
    return {
      'acquisitionDate': acquisitionDate.toIso8601String(),
      'monthlyPaymentDay': monthlyPaymentDay,
      'subscriptionType': subscriptionType,
      'name': name,
      'price': price,
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
        '}';
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MM yyyy').format(date);
  }

  void saveToDatabase(String userId) {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref('users/$userId');
    databaseReference.push().set(toMap());
  }
}

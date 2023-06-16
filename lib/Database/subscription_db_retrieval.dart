import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'auth_page.dart';
import '../model/subscription.dart';

class SubscriptionsDataHandler {
  final int = 3;
  final User? user = Auth().currentUser;

  Future<List<Subscription>> fetchSubscriptions() async {
    var userId = user!.uid;
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('users/$userId');

    DatabaseEvent event = await databaseReference.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> subscriptionsData = event.snapshot.value as Map;
      List<Subscription> subscriptions = [];

      subscriptionsData.forEach((key, value) {
        Subscription subscription = Subscription.fromMap(value);
        subscriptions.add(subscription);
      });

      return subscriptions;
    } else {
      return [];
    }
  }
}

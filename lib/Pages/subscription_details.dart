import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sub_watch_flutter/Database/subscription_db_retrieval.dart';
import 'package:sub_watch_flutter/Utils/constants.dart';
import 'package:sub_watch_flutter/model/subscription.dart';
import '../Utils/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SubscriptionDetails extends StatefulWidget {
  final Subscription subscription;
  const SubscriptionDetails({Key? key, required this.subscription})
      : super(key: key);

  @override
  State<SubscriptionDetails> createState() => _SubscriptionDetailsState();
}

class _SubscriptionDetailsState extends State<SubscriptionDetails> {
  Future<List<Subscription>> subscriptionsFuture =
      SubscriptionsDataHandler().fetchSubscriptions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      drawer: Constants.drawer(context),
      body: FutureBuilder<List<Subscription>>(
        future: subscriptionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Subscription> subscriptions =
                snapshot.data as List<Subscription>;
            Subscription? currentSubscription;
            List<Subscription> otherSubscriptions = [];
            List<Subscription> otherCategorizedSubscriptions = [];

            for (Subscription subscription in subscriptions) {
              if (subscription.name == widget.subscription.name) {
                currentSubscription = subscription;
              } else {
                otherSubscriptions.add(subscription);
              }
              if (subscription.subscriptionType ==
                  widget.subscription.subscriptionType) {
                otherCategorizedSubscriptions.add(subscription);
              }
            }

            double otherTotalPrice = otherSubscriptions.fold(
                0, (prev, subscription) => prev + subscription.price);
            Subscription otherSubscription = Subscription(
                acquisitionDate: DateTime.now(),
                monthlyPaymentDay: 1,
                name: 'other',
                price: otherTotalPrice,
                subscriptionType: 'BOOKS');

            double otherCategorizedPrice = otherCategorizedSubscriptions.fold(
                0, (prev, subscription) => prev + subscription.price);

            Subscription otherCategorizedSubscription = Subscription(
                acquisitionDate: DateTime.now(),
                monthlyPaymentDay: 1,
                name: 'other',
                price: otherCategorizedPrice,
                subscriptionType: 'BOOKS');

            List<Subscription> displaySubscriptions = [
              currentSubscription!,
              otherSubscription
            ];

            List<Subscription> displayCategorizedSubscriptions = [
              currentSubscription,
              otherCategorizedSubscription
            ];

            return Column(
              children: [
                primaryInfoSection(),
                allCharts(
                    displaySubscriptions, displayCategorizedSubscriptions),
                ratingSection(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget primaryInfoSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.darkerSecondaryColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _subscriptionRowSection(
              'Price: ', _subItemPrice(widget.subscription.price)),
          _subscriptionRowSection(
              'Category: ', widget.subscription.subscriptionType),
          _subscriptionRowSection('Day of payment: ',
              widget.subscription.monthlyPaymentDay.toString()),
          _subscriptionRowSection(
              'Date of purchase: ', widget.subscription.formatDate()),
        ],
      ),
    );
  }

  Widget allCharts(List<Subscription> displaySubscriptions,
      List<Subscription> displayCategorizedSubscriptions) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.darkerSecondaryColor,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.8,
                    child: chart(
                        displaySubscriptions, '% Of All Your Subscriptions'),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 1,
                    child: chart(displayCategorizedSubscriptions,
                        '% Of Subcriptions in ${widget.subscription.subscriptionType} Category'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget chart(List<Subscription> subscriptions, String title) {
    double total =
        subscriptions.fold(0, (prev, element) => prev + element.price);

    return SfCircularChart(
      title: ChartTitle(
          text: title,
          textStyle: Constants.basicTextStyle()
              .copyWith(fontWeight: FontWeight.bold, fontSize: 9)),
      series: <CircularSeries>[
        PieSeries<Subscription, String>(
          dataSource: subscriptions,
          xValueMapper: (Subscription subscription, _) => subscription.name,
          yValueMapper: (Subscription subscription, _) => subscription.price,
          pointColorMapper: (Subscription subscription, _) =>
              subscription.name == widget.subscription.name
                  ? AppColors.primaryColor
                  : Colors.blueGrey,
          dataLabelMapper: (Subscription subscription, _) => subscription
                      .name ==
                  widget.subscription.name
              ? '(${(subscription.price / total * 100).toStringAsFixed(2)}%) '
              : '(${(subscription.price / total * 100).toStringAsFixed(2)}%) ',
          dataLabelSettings: const DataLabelSettings(
              isVisible: true, color: AppColors.darkerSecondaryColor),
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      actions: const [],
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      backgroundColor: AppColors.primaryColor,
      title: _title(),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      toolbarHeight: 80,
    );
  }

  Widget _title() {
    return Text(
      widget.subscription.name,
      style: Constants.basicTextStyle()
          .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }

  Widget _subscriptionRowSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label,
              style: Constants.basicTextStyle()
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
          const Spacer(),
          Text(value, style: Constants.basicTextStyle().copyWith(fontSize: 20)),
        ],
      ),
    );
  }

  static String _subItemPrice(double price) {
    return '$price LEI';
  }

  Widget ratingSection() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.darkerSecondaryColor),
      child: RatingBar.builder(
        initialRating: widget.subscription.stars.toDouble(),
        minRating: 0,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {},
        ignoreGestures: true,
      ),
    );
  }

  Widget notesSection() {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.darkerSecondaryColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text(
            'Little Observations: ',
            style: Constants.basicTextStyle().copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

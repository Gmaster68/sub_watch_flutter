import 'package:flutter/material.dart';
import 'package:sub_watch_flutter/Utils/colors.dart';
import 'package:sub_watch_flutter/Utils/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Database/subscription_db_retrieval.dart';
import '../SubscriptionModelling/subscription_widgets.dart';
import '../model/subscription.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<DateTime, List<Subscription>> _events = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Subscription> subscriptions = [];
  List<Subscription> _selectedSubscriptions = [];

  @override
  void initState() {
    super.initState();
    fetchSubscriptions();
  }

  void fetchSubscriptions() async {
    SubscriptionsDataHandler handler = SubscriptionsDataHandler();
    subscriptions = await handler.fetchSubscriptions();
    _events = _groupSubscriptionsByDate(subscriptions);
    setState(() {}); // call setState to rebuild the widget
  }

  Map<DateTime, List<Subscription>> _groupSubscriptionsByDate(
      List<Subscription> subscriptions) {
    Map<DateTime, List<Subscription>> map = {};
    for (var subscription in subscriptions) {
      final date = DateTime(DateTime.now().year, DateTime.now().month,
          subscription.monthlyPaymentDay);
      if (map[date] == null) map[date] = [];
      map[date]!.add(subscription);
    }
    return map;
  }

  List<Subscription> _getEventsForDay(DateTime date) {
    List<Subscription> events = [];
    _events.forEach((dateTime, subscriptions) {
      if (dateTime.day == date.day) {
        events.addAll(subscriptions);
      }
    });
    return events;
  }

  Widget calendarTitle() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 10, top: 20, bottom: 10),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text('Calendar Of Subscriptions This Month:',
            style: Constants.basicTextStyle()
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget recentlyAddedSubscriptionsTitle() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 10, top: 20, bottom: 10),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text('Recently Added :',
            style: Constants.basicTextStyle()
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget recentSubscriptionsRow(BuildContext context) {
    subscriptions
        .sort((a, b) => b.acquisitionDate.compareTo(a.acquisitionDate));
    List<Subscription> top3 = subscriptions.take(3).toList();
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      padding: const EdgeInsets.only(left: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: top3
            .map((subscription) =>
                SubscriptionWidgets.subscriptionItem(context, subscription))
            .toList(),
      ),
    );
  }

  Widget mostExpensiveSubscriptionsTitle() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 10, top: 20, bottom: 10),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text('Most Expensive :',
            style: Constants.basicTextStyle()
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget mostExpensivbeSubscriptionsRow(BuildContext context) {
    subscriptions.sort((a, b) => b.price.compareTo(a.price));
    List<Subscription> top3 = subscriptions.take(3).toList();

    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: top3
            .map((subscription) =>
                SubscriptionWidgets.subscriptionItem(context, subscription))
            .toList(),
      ),
    );
  }

  Widget calendar() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TableCalendar<Subscription>(
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              return Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.thirdColor,
                  ),
                  child: Text(
                    '${events.length}',
                    style: const TextStyle().copyWith(
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              );
            } else {
              return null;
            }
          },
        ),
        headerVisible: false,
        firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
        lastDay: DateTime.utc(DateTime.now().year, DateTime.now().month + 1, 0),
        focusedDay: _focusedDay,
        eventLoader: _getEventsForDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _selectedSubscriptions = _getEventsForDay(selectedDay);
          });
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: Constants.basicTextStyle().copyWith(fontSize: 20),
          defaultDecoration: const BoxDecoration(color: Colors.black),
          weekendDecoration:
              const BoxDecoration(color: AppColors.backgroundColor),
          defaultTextStyle: Constants.basicTextStyle().copyWith(fontSize: 20),
          isTodayHighlighted: false,
          selectedDecoration: const BoxDecoration(
              color: AppColors.primaryColor,
              backgroundBlendMode: BlendMode.colorDodge),
          selectedTextStyle: const TextStyle()
              .copyWith(color: AppColors.textColor, fontSize: 20),
        ),
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  List<Widget> _buildSelectedSubscriptions(BuildContext context) {
    return _selectedSubscriptions.map((subscription) {
      return SubscriptionWidgets.subscriptionItem(context, subscription);
    }).toList();
  }

  Widget calendarWithSelectedItems(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: AppColors.darkerSecondaryColor,
          borderRadius: BorderRadius.circular(15)),
      child: Column(children: [
        calendar(),
        ..._buildSelectedSubscriptions(context),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                calendarTitle(),
                calendarWithSelectedItems(context),
                recentlyAddedSubscriptionsTitle(),
                recentSubscriptionsRow(context),
                mostExpensiveSubscriptionsTitle(),
                mostExpensivbeSubscriptionsRow(context)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

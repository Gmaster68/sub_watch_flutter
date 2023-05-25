import 'package:flutter/material.dart';
import 'package:sub_watch_flutter/colors.dart';
import 'package:sub_watch_flutter/subscription.dart';

class SubscriptionWidgets {
  static Widget _subscriptionType(String subscriptionType) {
    Icon icon;
    switch (subscriptionType) {
      case 'MUSIC':
        icon = const Icon(
          Icons.music_note,
          size: 20,
          color: AppColors.accentColor,
        );
        break;
      case 'MOVIES':
        icon = const Icon(
          Icons.movie,
          size: 20,
          color: AppColors.accentColor,
        );
        break;
      case 'BOOKS':
        icon = const Icon(
          Icons.book,
          size: 20,
          color: AppColors.accentColor,
        );
        break;
      case 'GAMES':
        icon = const Icon(
          Icons.gamepad_rounded,
          size: 20,
          color: AppColors.accentColor,
        );
        break;
      case 'DATING':
        icon = const Icon(
          Icons.heat_pump_rounded,
          size: 20,
          color: AppColors.accentColor,
        );
        break;
      case 'EDUCATION':
        icon = const Icon(
          Icons.school,
          size: 20,
          color: AppColors.accentColor,
        );
        break;
      case 'FOOD':
        icon = const Icon(
          Icons.local_pizza,
          size: 20,
          color: AppColors.accentColor,
        );
        break;
      case 'SOCIAL MEDIA':
        icon = const Icon(
          Icons.facebook,
          size: 20,
          color: AppColors.accentColor,
        );
        break;
      case 'MISCELLANEOUS':
        icon = const Icon(
          Icons.miscellaneous_services,
          size: 20,
          color: AppColors.accentColor,
        );
        break;
      default:
        icon = const Icon(
          Icons.error,
          size: 20,
          color: AppColors.accentColor,
        );
    }
    return icon;
  }

  static TextStyle _subItemLabelStyle() {
    return const TextStyle(
        color: AppColors.textColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans');
  }

  static TextStyle _subItemElementStyle() {
    return const TextStyle(
      color: AppColors.textColor,
      fontFamily: 'OpenSans',
    );
  }

  static Widget _subItemElement(String labelName, String elementName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(labelName, style: _subItemLabelStyle()),
        Text(elementName, style: _subItemElementStyle())
      ],
    );
  }

  static Widget subscriptionItem(Subscription subscription) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 5,
        shadowColor: Color.fromARGB(255, 132, 132, 132),
        color: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accentColor),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.secondaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _subscriptionType(subscription.subscriptionType),
                      Text(
                        subscription.subscriptionType,
                        style: _subItemLabelStyle()
                            .copyWith(color: AppColors.primaryColor),
                      ),
                    ],
                  )),
              Container(
                width: 2,
                height: 60,
                color: AppColors.accentColor,
              ),
              Expanded(
                  flex: 6,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _subItemElement('Name: ', subscription.name),
                          _subItemElement(
                            'Date: ',
                            subscription
                                .formatDate(subscription.acquisitionDate),
                          ),
                          _subItemElement(
                            'Day of payment: ',
                            subscription.monthlyPaymentDay.toString(),
                          ),
                          _subItemElement(
                              'Price: ', subscription.price.toString()),
                        ],
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}

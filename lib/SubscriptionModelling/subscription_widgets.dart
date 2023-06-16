import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_watch_flutter/Pages/subscription_details.dart';
import 'package:sub_watch_flutter/Utils/colors.dart';
import 'package:sub_watch_flutter/model/subscription.dart';

class SubscriptionWidgets {
  static Widget _subscriptionType(String subscriptionType) {
    Icon icon;

    switch (subscriptionType) {
      case 'MUSIC':
        icon = const Icon(
          Icons.music_note,
          size: 38,
          color: AppColors.accentColor,
        );
        break;
      case 'MOVIES':
        icon = const Icon(
          Icons.movie,
          size: 38,
          color: AppColors.accentColor,
        );
        break;
      case 'BOOKS':
        icon = const Icon(
          Icons.book,
          size: 38,
          color: AppColors.accentColor,
        );
        break;
      case 'GAMING':
        icon = const Icon(
          Icons.gamepad_rounded,
          size: 38,
          color: AppColors.accentColor,
        );
        break;
      case 'DATING':
        icon = const Icon(
          Icons.heat_pump_rounded,
          size: 38,
          color: AppColors.accentColor,
        );
        break;
      case 'EDUCATION':
        icon = const Icon(
          Icons.school,
          size: 38,
          color: AppColors.accentColor,
        );
        break;
      case 'FOOD':
        icon = const Icon(
          Icons.local_pizza,
          size: 38,
          color: AppColors.accentColor,
        );
        break;
      case 'SOCIAL MEDIA':
        icon = const Icon(
          Icons.facebook,
          size: 38,
          color: AppColors.accentColor,
        );
        break;
      case 'MISCELLANEOUS':
        icon = const Icon(
          Icons.miscellaneous_services,
          size: 38,
          color: AppColors.accentColor,
        );
        break;
      default:
        icon = const Icon(
          Icons.error,
          size: 38,
          color: AppColors.accentColor,
        );
    }
    return Center(child: icon);
  }

  static TextStyle _subItemElementStyle() {
    return GoogleFonts.robotoCondensed()
        .copyWith(color: AppColors.textColor, fontSize: 15);
  }

  static _subItemTitle(String labelName) {
    return Text(labelName,
        style: _subItemElementStyle().copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ));
  }

  static _subItemPrice(double price) {
    String value = '$price LEI';
    return Text(
      value,
      style: _subItemElementStyle(),
    );
  }

  static Widget subscriptionItem(
      BuildContext context, Subscription subscription) {
    return GestureDetector(
      onLongPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SubscriptionDetails(subscription: subscription)));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.085,
          padding: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accentColor),
            borderRadius: BorderRadius.circular(50),
            color: AppColors.secondaryColor,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 20,
                  child: _subscriptionType(subscription.subscriptionType),
                ),
                Flexible(
                  flex: 80,
                  child: Container(
                    padding: const EdgeInsets.only(right: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _subItemTitle(subscription.name),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              subscription.subscriptionType,
                              style: _subItemElementStyle(),
                            ),
                            _subItemPrice(subscription.price)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

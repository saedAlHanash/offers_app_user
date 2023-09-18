import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/models/notification.dart';
import 'package:offers_awards/screens/offer_details/offer_details_screen.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:timeago/timeago.dart' as timeago;

class OfferNotification extends StatelessWidget {
  final NotificationModel notification;

  const OfferNotification({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    String timeAgo = timeago.format(notification.date, locale: 'ar');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: Dimensions.notificationCardHeight,
          margin: EdgeInsets.only(
              top: Dimensions.padding16, bottom: Dimensions.padding4),
          decoration: BoxDecoration(
            borderRadius: Dimensions.borderRadius10,
            color: AppUI.greyCardColor,
          ),
          child: InkWell(
            onTap: () {
              if (notification.type == 'new' || notification.type == 'hot') {
                Get.to(() => OfferDetailsScreen(
                      id: notification.data["voucher_id"],
                    ));
              }
            },
            child: LayoutBuilder(builder: (context, constraints) {
              return Row(
                children: [
                  Container(
                    width: constraints.maxWidth * 0.12,
                    height: constraints.maxHeight,
                    padding: EdgeInsets.all(
                      Dimensions.padding8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Dimensions.radius10),
                        bottomRight: Radius.circular(Dimensions.radius10),
                      ),
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppUI.gradient2Color,
                            AppUI.gradient1Color,
                          ]),
                    ),
                    child: SvgPicture.asset(
                      notification.type == 'new' || notification.type == 'hot'
                          ? AppAssets.typeNew
                          : AppAssets.typePercentage,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.padding8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (AppConstant.notificationType[notification.type] !=
                                null &&
                            AppConstant.notificationType[notification.type]!
                                .isNotEmpty)
                          Text(
                            AppConstant.notificationType[notification.type] ??
                                'عروض',
                            style: const TextStyle(
                              color: AppUI.primaryColor,
                            ),
                          ),
                        Text(notification.body),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        Text(
          timeAgo,
          style: const TextStyle(
            color: AppUI.hintTextColor,
          ),
        )
      ],
    );
  }
}

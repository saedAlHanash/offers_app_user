import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/models/notification.dart';
import 'package:offers_awards/screens/order/invoice_screen.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrderNotification extends StatelessWidget {
  final NotificationModel notification;

  const OrderNotification({Key? key, required this.notification}) : super(key: key);

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
            top: Dimensions.padding16,
            bottom: Dimensions.padding4,
          ),
          decoration: BoxDecoration(
            borderRadius: Dimensions.borderRadius10,
            color: AppUI.greyCardColor,
          ),
          child: InkWell(
            onTap: () {
              Get.to(() => InvoiceScreen(
                id: notification.data["order_id"],
                orderNumber: notification.data["order_number"],
              ));
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
                        ],
                      ),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.lightFavorite,
                    ),
                  ),
                  SizedBox(width: Dimensions.padding8), // Added space here
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.padding8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notification.data["provider_name"],
                                  style: const TextStyle(
                                    color: AppUI.primaryColor,
                                  ),
                                ),
                                Text(
                                  notification.data["order_number"].toString(),
                                  style: const TextStyle(
                                    color: AppUI.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(notification.body),
                        ],
                      ),
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
        ),
      ],
    );
  }
}
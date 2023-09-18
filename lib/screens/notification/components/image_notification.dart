import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/models/notification.dart';
import 'package:offers_awards/screens/offer_details/offer_details_screen.dart';
import 'package:offers_awards/screens/order/invoice_screen.dart';
import 'package:offers_awards/screens/widgets/custom_network_image.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:timeago/timeago.dart' as timeago;

class ImageNotification extends StatelessWidget {
  final NotificationModel notification;

  const ImageNotification({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    String timeAgo = timeago.format(notification.date, locale: 'ar');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Dimensions.padding16, bottom: Dimensions.padding4),
          decoration: BoxDecoration(
            borderRadius: Dimensions.borderRadius10,
            color: AppUI.greyCardColor,
          ),
          child: InkWell(
            onTap: () {
              if (notification.type == 'new' ||
                  notification.type == 'hot'){
                Get.to(() => OfferDetailsScreen(
                  id: notification.data["voucher_id"],
                ));
              }
              else if(notification.type == 'order'){
                Get.to(() => InvoiceScreen(
                  id: notification.data["order_id"],
                  orderNumber: notification.data["order_number"],
                ));
              }
            },
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: Dimensions.borderRadius10,
                    child: CustomNetworkImage(
                      imageUrl: notification.image!,
                      width: constraints.maxWidth,
                      height: Dimensions.notificationImageHeight,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all( Dimensions.padding8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(AppConstant.notificationType[notification.type]!=null &&   AppConstant.notificationType[notification.type]!.isNotEmpty)
                        Text(
                          AppConstant.notificationType[notification.type]!,
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

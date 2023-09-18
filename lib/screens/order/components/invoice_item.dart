import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:offers_awards/models/order.dart';
import 'package:offers_awards/screens/offer_details/offer_details_screen.dart';
import 'package:offers_awards/screens/widgets/custom_network_image.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/screens/widgets/custom_title_text.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class InvoiceItem extends StatelessWidget {
  final OrderItem orderItem;
  final String providerName;
  const InvoiceItem(
      {super.key, required this.orderItem, required this.providerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: Dimensions.borderRadius10,
        color: AppUI.greyCardColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.padding4,
        vertical: Dimensions.padding8,
      ),
      margin: EdgeInsets.symmetric(
        // horizontal: Dimensions.padding8,
        vertical: Dimensions.padding8,
      ),
      child: InkWell(
        onTap: () {
          if (orderItem.isAvailable) {
            Get.to(() => OfferDetailsScreen(id: orderItem.id));
          } else {
            CustomSnackBar.showRowSnackBarError("هذا المنتج لم يعد متوافر");
          }
        },
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: Dimensions.borderRadius10,
                child: CustomNetworkImage(
                  imageUrl: orderItem.cover,
                  height: MediaQuery.of(context).size.width * 0.27,
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
              ),
            ),
            // const Spacer(),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.padding8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomTitleText(
                          title: orderItem.name,
                          fontSize: Dimensions.font14,
                        ),
                        Text(
                          "${orderItem.quantity}",
                          style: const TextStyle(
                            fontSize: Dimensions.font18,
                            fontWeight: FontWeight.bold,
                            // color: AppUI.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: Dimensions.padding8),
                      child: Text(
                        '${NumberFormat('#,###').format(orderItem.offer)} د.ع',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${NumberFormat('#,###').format(orderItem.total)} د.ع',
                      style: const TextStyle(
                          fontSize: Dimensions.font14,
                          color: AppUI.hintTextColor),
                    ),
                  ],
                ),
              ),
            ),
            // const Spacer(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:offers_awards/models/order.dart';
import 'package:offers_awards/screens/order/invoice_screen.dart';
import 'package:offers_awards/screens/widgets/custom_network_image.dart';
import 'package:offers_awards/screens/widgets/custom_title_text.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class OrderItemWidget extends StatefulWidget {
  final Order order;

  const OrderItemWidget({super.key, required this.order});

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
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
        horizontal: Dimensions.padding8,
        vertical: Dimensions.padding8,
      ),
      child: InkWell(
        onTap: () {
          Get.to(() => InvoiceScreen(
              id: widget.order.id, orderNumber: widget.order.orderNumber));
        },
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: Dimensions.borderRadius10,
                child: CustomNetworkImage(
                  imageUrl: widget.order.provider.logo,
                  height: MediaQuery.of(context).size.width * 0.27,
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
              ),
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitleText(
                  title: widget.order.provider.name,
                  fontSize: Dimensions.font14,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.padding8),
                  child: Text(
                    '${NumberFormat('#,###').format(widget.order.total)} ${AppConstant.currency[widget.order.currency] ?? widget.order.currency}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  AppConstant.orderStatus[widget.order.status] ??
                      widget.order.status,
                  style: const TextStyle(
                    fontSize: Dimensions.font14,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${widget.order.orderNumber}",
                  style: const TextStyle(
                    fontSize: Dimensions.font14,
                    // color: AppUI.secondaryColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.padding8),
                  child: Text(
                    '${NumberFormat('#,###').format(widget.order.totalBefore)} ${AppConstant.currency[widget.order.currency] ?? widget.order.currency}',
                    style: const TextStyle(
                        fontSize: Dimensions.font14,
                        color: AppUI.hintTextColor),
                  ),
                ),
                const Text(
                  '',
                  style: TextStyle(
                    fontSize: Dimensions.font14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

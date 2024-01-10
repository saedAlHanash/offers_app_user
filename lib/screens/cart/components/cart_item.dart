import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:offers_awards/controllers/cart_controller.dart';
import 'package:offers_awards/models/cart.dart';
import 'package:offers_awards/screens/widgets/custom_network_image.dart';
import 'package:offers_awards/screens/widgets/custom_title_text.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CartWidget extends StatefulWidget {
  final CartItem cartItem;

  const CartWidget({Key? key, required this.cartItem}) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
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
      child: GetBuilder<CartController>(builder: (cartController) {
        var cartItem = cartController.getItem(widget.cartItem.id);
        if (cartItem != null) {
          return Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      cartController.addItem(
                        cartItem.offer,
                        1,
                      );
                    },
                    icon: SvgPicture.asset("assets/svg/buttons/add.svg"),
                  ),
                  Text(cartItem.quantity.toString()),
                  IconButton(
                    onPressed: () {
                      cartController.addItem(
                        cartItem.offer,
                        -1,
                      );
                    },
                    icon: SvgPicture.asset("assets/svg/buttons/remove.svg"),
                  ),
                ],
              ),
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: Dimensions.borderRadius10,
                  child: CustomNetworkImage(
                    imageUrl: cartItem.offer.cover,
                    width: MediaQuery.of(context).size.width * 0.27,
                    height: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTitleText(
                    title: cartItem.offer.name,
                    fontSize: Dimensions.font14,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.padding8),
                    child: Text(
                      '${NumberFormat('#,###').format(cartItem.offer.offer??cartItem.offer.price)} ${AppConstant.currency[cartItem.offer.currency] ?? cartItem.offer.currency}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${NumberFormat('#,###').format(cartItem.amount)} ${AppConstant.currency[cartItem.offer.currency] ?? cartItem.offer.currency}',
                    style: const TextStyle(
                        fontSize: Dimensions.font14,
                        color: AppUI.hintTextColor),
                  ),
                  // Text(
                  //   '${cartItem.offer.description.substring(0, 5)}...اقرأ المزيد',
                  //   style: const TextStyle(
                  //     fontSize: Dimensions.font12,
                  //   ),
                  // ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      cartController.removeItem(cartItem.offer);
                    },
                    icon: const Icon(Icons.close),
                  ),
                  SizedBox(
                    height: Dimensions.padding16 * 2,
                  ),
                  SizedBox(
                    height: Dimensions.padding16 * 2,
                  ),
                ],
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:offers_awards/controllers/cart_controller.dart';
import 'package:offers_awards/controllers/favorite_controller.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/qr_code/qr_code_screen.dart';
import 'package:offers_awards/screens/widgets/custom_light_text.dart';
import 'package:offers_awards/screens/widgets/custom_old_price.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/services/offers_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class FavOfferInfo extends StatefulWidget {
  final Offer offer;

  const FavOfferInfo({Key? key, required this.offer}) : super(key: key);

  @override
  State<FavOfferInfo> createState() => _FavOfferInfoState();
}

class _FavOfferInfoState extends State<FavOfferInfo> {
  final FavoriteController _favoriteController = Get.find<FavoriteController>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomLightText(
              text: widget.offer.name,
              fontSize: Dimensions.font14,
              color: AppUI.textColor,
            ),
            IconButton(
              onPressed: () {
                if (_isLoading) {
                  CustomSnackBar.showRowSnackBarError("الرجاء الانتظار");
                } else {
                  setState(() {
                    _isLoading = true;
                  });
                  OfferServices.toggalFavorite(widget.offer.id).then((value) {
                    if (value) {
                      setState(() {
                        _isLoading = false;
                      });
                      if (!widget.offer.isFavorite) {
                        CustomSnackBar.showRowSnackBarSuccess(
                            "تمت الإضافة إلى المفضلة");
                      } else {
                        CustomSnackBar.showRowSnackBarSuccess(
                            "تمت الإزالة من المفضلة");
                        _favoriteController.removeFromFavorites(widget.offer);
                      }
                      setState(() {
                        widget.offer.isFavorite = !widget.offer.isFavorite;
                      });
                    } else {
                      CustomSnackBar.showRowSnackBarError("عذرا حدث خطأ");
                    }
                  });
                }
              },
              icon: SvgPicture.asset(
                widget.offer.isFavorite
                    ? AppAssets.activeFavorite
                    : AppAssets.favorite,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<CartController>(builder: (cartController) {
                return GestureDetector(
                  onTap: () {
                    if (widget.offer.type == 'store_and_delivery' ||
                        widget.offer.type == 'delivery') {
                      if (!cartController.existInCart(widget.offer)) {
                        bool result = cartController.addItem(widget.offer, 1);
                        if (result) {
                          CustomSnackBar.showRowSnackBarSuccess(
                              "تمت الإضافة إلى السلة ✔️");
                        }
                      } else {
                        CustomSnackBar.showRowSnackBarError(
                            "المنتج موجود في السلة مسبقاً ✖️");
                      }
                    } else {
                      Get.to(() => QrCodeScreen(
                            offer: widget.offer,
                          ));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: Dimensions.borderRadius24,
                      color: AppUI.primaryColor,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.padding8,vertical: Dimensions.padding4,),
                    // margin: EdgeInsets.symmetric(vertical: Dimensions.padding4,),
                    child: Text(
                      widget.offer.type == 'store_and_delivery' ||
                              widget.offer.type == 'delivery'
                          ? "أضف الى السلة"
                          : "عرض الكود",
                      style: const TextStyle(
                        fontSize: Dimensions.font12,
                        color: AppUI.secondaryColor,
                      ),
                    ),
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: Dimensions.borderRadius50),
                    // backgroundColor: AppUI.primaryColor,
                  ),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomLightText(
                    text:
                        '${NumberFormat('#,###').format(widget.offer.offer??widget.offer.price)} ${AppConstant.currency[widget.offer.currency]??widget.offer.currency}',
                    fontSize: Dimensions.font16,
                    color: AppUI.primaryColor,
                  ),
                  SizedBox(
                    width: Dimensions.padding16,
                  ),
                  if(widget.offer.offer !=null)
                  CustomOldPrice(
                    price: widget.offer.price,
                    currency: widget.offer.currency,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

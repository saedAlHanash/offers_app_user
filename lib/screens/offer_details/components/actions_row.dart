import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/cart_controller.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/qr_code/qr_code_screen.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/services/offers_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class ActionsRow extends StatefulWidget {
  final Offer offer;

  const ActionsRow({Key? key, required this.offer}) : super(key: key);

  @override
  State<ActionsRow> createState() => _ActionsRowState();
}

class _ActionsRowState extends State<ActionsRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.padding8,
        horizontal: Dimensions.padding24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              borderRadius: Dimensions.borderRadius10,
              color: AppUI.primaryColor,
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              if (widget.offer.type == 'store_and_delivery') {
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => QrCodeScreen(
                              offer: widget.offer,
                            ));
                      },
                      child: Container(
                        width: constraints.maxWidth * 0.25,
                        padding: EdgeInsets.all(
                          Dimensions.padding8 + Dimensions.padding4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: Dimensions.borderRadius10,
                          color: AppUI.gradient1Color,
                        ),
                        child: SvgPicture.asset(
                          AppAssets.qrCode,
                        ),
                      ),
                    ),
                    GetBuilder<CartController>(builder: (cartController) {
                      return InkWell(
                        onTap: () {
                          if (!cartController.existInCart(widget.offer)) {
                            bool result =
                                cartController.addItem(widget.offer, 1);
                            if (result) {
                              CustomSnackBar.showRowSnackBarSuccess(
                                  "تمت الإضافة إلى السلة ✔️");
                            }
                          } else {
                            CustomSnackBar.showRowSnackBarError(
                                "المنتج موجود في السلة مسبقاً ✖️");
                          }
                        },
                        child: SizedBox(
                          width: constraints.maxWidth * 0.75,
                          child: SvgPicture.asset(AppAssets.addToCart),
                        ),
                      );
                    }),
                  ],
                );
              } else if (widget.offer.type == 'store') {
                return InkWell(
                  onTap: () {
                    Get.to(
                      () => QrCodeScreen(
                        offer: widget.offer,
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(
                      Dimensions.padding8,
                    ),
                    width: constraints.maxWidth,
                    child: SvgPicture.asset(AppAssets.qrCode),
                  ),
                );
              } else if (widget.offer.type == 'delivery') {
                return GetBuilder<CartController>(builder: (cartController) {
                  return InkWell(
                    onTap: () {
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
                    },
                    child: Container(
                      padding: EdgeInsets.all(
                        Dimensions.padding8,
                      ),
                      width: constraints.maxWidth * 0.75,
                      child: SvgPicture.asset(AppAssets.addToCart),
                    ),
                  );
                });
              } else {
                return SizedBox(
                  width: constraints.maxWidth,
                );
              }
            }),
          ),
          InkWell(
            onTap: () {
              OfferServices.toggalFavorite(widget.offer.id).then((value) {
                if (value) {
                  if (!widget.offer.isFavorite) {
                    CustomSnackBar.showRowSnackBarSuccess(
                        "تمت الإضافة إلى المفضلة");
                  } else {
                    CustomSnackBar.showRowSnackBarSuccess(
                        "تمت الإزالة من المفضلة");
                  }
                  setState(() {
                    widget.offer.isFavorite = !widget.offer.isFavorite;
                  });
                } else {
                  CustomSnackBar.showRowSnackBarError("عذرا حدث خطأ");
                }
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              padding:
                  EdgeInsets.all(Dimensions.padding8 + Dimensions.padding4),
              decoration: BoxDecoration(
                  borderRadius: Dimensions.borderRadius10,
                  color: AppUI.greyCardColor),
              child: SvgPicture.asset(
                widget.offer.isFavorite
                    ? AppAssets.activeFavorite
                    : AppAssets.favorite,
                height: Dimensions.icon21,
                width: Dimensions.icon21,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

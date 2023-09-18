import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/widgets/custom_light_text.dart';
import 'package:offers_awards/screens/widgets/custom_old_price.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/services/offers_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class OfferInfo extends StatefulWidget {
  final bool displayRate;
  final bool displayType;
  final Offer offer;

  const OfferInfo({
    Key? key,
    this.displayRate = false,
    this.displayType = true,
    required this.offer,
  }) : super(key: key);

  @override
  State<OfferInfo> createState() => _OfferInfoState();
}

class _OfferInfoState extends State<OfferInfo> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.only(top: Dimensions.padding8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomLightText(
                text: widget.offer.name,
                fontSize: Dimensions.font14,
              ),
              if (widget.displayRate && !widget.displayType)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.padding8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset("assets/svg/icons/rating.svg"),
                      SizedBox(
                        width: Dimensions.padding4,
                      ),
                      CustomLightText(
                        text: widget.offer.stars.toString(),
                        fontSize: null,
                      ),
                    ],
                  ),
                ),
              if (!widget.displayRate && widget.displayType)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.padding8,
                  ),
                  child: CustomLightText(
                    text: AppConstant.offerType[widget.offer.type] ?? '',
                    fontSize: null,
                  ),
                ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomLightText(
                  text:
                  '${NumberFormat('#,###').format(widget.offer.offer)} د.ع',
                  fontSize: null,
                ),
                SizedBox(
                  width: Dimensions.padding4,
                ),
                CustomOldPrice(
                  price: widget.offer.price,
                )
              ],
            ),
            IconButton(
              onPressed: () {
                if (_isLoading) {
                  CustomSnackBar.showRowSnackBarError(
                      "الرجاء الانتظار");
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
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/offer_details/offer_details_screen.dart';
import 'package:offers_awards/screens/widgets/custom_network_image.dart';
import 'package:offers_awards/screens/widgets/offer/fav_offer_info.dart';
import 'package:offers_awards/screens/widgets/offer/offer_info.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class OfferItem extends StatelessWidget {
  final Offer offer;
  final bool displayRate;
  final bool displayType;
  final bool isFav;

  const OfferItem({
    super.key,
    required this.offer,
    this.displayRate = false,
    this.displayType = true,
    this.isFav = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight,
        width: MediaQuery.of(context).size.width * 0.75,
        padding: EdgeInsets.all(Dimensions.padding8),
        decoration: BoxDecoration(
          borderRadius: Dimensions.borderRadius24,
        ),
        child: InkWell(
          onTap: () {
            Get.to(
              () => OfferDetailsScreen(
                id: offer.id,
              ),
              preventDuplicates: false,
            );
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                // bottom: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius10),
                    topRight: Radius.circular(Dimensions.radius10),
                  ),
                  child: CustomNetworkImage(
                    imageUrl: offer.cover,
                    height: constraints.maxHeight * 0.7,
                    logo1: true,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: constraints.maxHeight * 0.3,
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.padding8,
                  ),
                  decoration: const BoxDecoration(
                    color: AppUI.greyCardColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: isFav
                      ? FavOfferInfo(
                          offer: offer,
                        )
                      : OfferInfo(
                          offer: offer,
                          displayRate: displayRate,
                          displayType: displayType,
                        ),
                ),
              ),
              Positioned(
                bottom: constraints.maxHeight * 0.27,
                right: Dimensions.padding16,
                child: ClipRRect(
                  borderRadius: Dimensions.borderRadius50,
                  child: CachedNetworkImage(
                    imageUrl: offer.provider.logo,
                    width: Dimensions.logoSize,
                    height: Dimensions.logoSize,
                    fit: BoxFit.fill,
                    errorWidget: (context, url, error) => SizedBox(
                      child: Image.asset(
                        AppAssets.logo2,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

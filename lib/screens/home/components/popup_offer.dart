import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/models/banner.dart';
import 'package:offers_awards/screens/offer_details/offer_details_screen.dart';
import 'package:offers_awards/screens/offers/offers_list_screen.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class PopUpOffer {
  static showDialogAds(BuildContext context,
      {required CustomBanner banner}) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            children: [
              InkWell(
                onTap: () async {
                  if (banner.adType == "voucher") {
                    Get.to(() =>
                        OfferDetailsScreen(id: banner.adID));
                  } else if (banner.adType == "provider") {
                    Get.to(() => OffersListScreen(
                        title: banner.name.toString()));
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(Dimensions.padding8),
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: Dimensions.borderRadius10,
                    child: CachedNetworkImage(
                      imageUrl: banner.cover,
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => SizedBox(
                        child: Image.asset(
                          AppAssets.logo2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0.0,
                top: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const CircleAvatar(
                    backgroundColor: AppUI.greyCardColor,
                    child: Icon(Icons.close, color: AppUI.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

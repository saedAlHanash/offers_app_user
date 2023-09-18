import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/models/banner.dart';
import 'package:offers_awards/screens/offer_details/offer_details_screen.dart';
import 'package:offers_awards/screens/offers/offers_list_screen.dart';
import 'package:offers_awards/screens/widgets/custom_network_image.dart';
import 'package:offers_awards/utils/dimensions.dart';

class FixedBanner extends StatefulWidget {
  final List<CustomBanner> banners;

  const FixedBanner({Key? key, required this.banners}) : super(key: key);

  @override
  State<FixedBanner> createState() => _FixedBannerState();
}

class _FixedBannerState extends State<FixedBanner> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.bannerListHeight,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: ListView.builder(
          padding: EdgeInsets.all(Dimensions.padding8),
          scrollDirection: Axis.horizontal,
          itemCount: widget.banners.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: Dimensions.bannerListHeight,
              width: Dimensions.bannerListWidth,
              padding: EdgeInsets.all(Dimensions.padding8),
              child: ClipRRect(
                borderRadius: Dimensions.borderRadius10,
                child: GestureDetector(
                  child: CustomNetworkImage(
                    imageUrl: widget.banners[index].cover,
                    height: Dimensions.bannerListHeight,
                    width: Dimensions.bannerListWidth,
                  ),
                  onTap: () {
                    if (widget.banners[index].adType == "voucher") {
                      Get.to(() =>
                          OfferDetailsScreen(id: widget.banners[index].adID));
                    } else if (widget.banners[index].adType == "provider") {
                      Get.to(() => OffersListScreen(
                          title: widget.banners[index].name.toString()));
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

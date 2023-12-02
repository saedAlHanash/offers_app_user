import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/offers/offers_list_screen.dart';
import 'package:offers_awards/screens/widgets/custom_title_text.dart';
import 'package:offers_awards/screens/widgets/offer/offer_item.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class HomeOffers extends StatelessWidget {
  final String filter;
  final List<Offer> offers;
  final int? customSliderID;

  const HomeOffers(
      {Key? key,
      required this.filter,
      required this.offers,
      this.customSliderID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.padding16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTitleText(
                title: AppConstant.offerFilter[filter] ?? filter,
                fontSize: Dimensions.font18,
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => OffersListScreen(
                        title: filter,
                        customSliderID: customSliderID,
                      ));
                },
                child: const Text(
                  "مشاهدة الكل",
                ),
              ),
            ],
          ),
        ),
        //hot offers
        SizedBox(
          height: Dimensions.offerHeight,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: offers.length,
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: [
                  OfferItem(
                    offer: offers[index],
                    displayRate: false,
                    displayType: true,
                  ),
                  if (index == offers.length - 1)
                    // && widget.offers.length >= 5
                    Positioned(
                      top: Dimensions.padding16,
                      left: Dimensions.padding16,
                      child: IconButton(
                        icon: SvgPicture.asset("assets/svg/buttons/more.svg"),
                        onPressed: () {
                          Get.to(() => OffersListScreen(
                                title: filter,
                                customSliderID: customSliderID,
                              ));
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

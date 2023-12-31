import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/models/home_slider.dart';
import 'package:offers_awards/screens/offer_details/offer_details_screen.dart';
import 'package:offers_awards/screens/provider/offers_list_screen.dart';
import 'package:offers_awards/screens/widgets/custom_light_text.dart';
import 'package:offers_awards/screens/widgets/custom_network_image.dart';
import 'package:offers_awards/screens/widgets/custom_slider_indicator.dart';
import 'package:offers_awards/services/provider_services.dart';
import 'package:offers_awards/utils/dimensions.dart';


class MainSlider extends StatefulWidget {
  final List<HomeSlider> sliders;

  const MainSlider({Key? key, required this.sliders}) : super(key: key);

  @override
  State<MainSlider> createState() => _MainSliderState();
}

class _MainSliderState extends State<MainSlider> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SafeArea(child: SizedBox.shrink()),
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 1.5,
            viewportFraction: 1,
            autoPlay: true,
            onPageChanged: (index, reason) => setState(() => activeIndex = index),
          ),
          items: widget.sliders.map((slide) {
            return GestureDetector(
              onTap: () async{
                if (slide.adType == "voucher" && slide.adID != null) {
                  Get.to(() => OfferDetailsScreen(id: slide.adID!));
                } else if (slide.adType == "provider") {

                  final  provider=await ProviderServices.getById(slide.adID!);
                  Get.to(() => OffersListScreen(provider: provider,
                  ));
                }
              },
              child: Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                    child: CustomNetworkImage(
                      imageUrl: slide.cover,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    bottom: Dimensions.padding16,
                    top: Dimensions.padding24 * 4,
                    right: Dimensions.padding16,
                    left: Dimensions.padding16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomLightText(text: slide.title),
                        CustomLightText(
                          text: slide.description,
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: Dimensions.padding24,
                        ),
                        Center(
                          child: CustomSliderIndicator(
                            activeIndex: activeIndex,
                            count: widget.sliders.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

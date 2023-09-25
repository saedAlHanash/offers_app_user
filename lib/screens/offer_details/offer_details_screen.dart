import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/offer_details/components/actions_row.dart';
import 'package:offers_awards/screens/offer_details/components/detail_slider.dart';
import 'package:offers_awards/screens/provider/components/provider_adress.dart';
import 'package:offers_awards/screens/offer_details/components/suggestion_list.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/screens/widgets/custom_flip_countdown_clock/flip_countdown_clock.dart';
import 'package:offers_awards/screens/widgets/custom_old_price.dart';
import 'package:offers_awards/screens/widgets/custom_title_text.dart';
import 'package:offers_awards/services/offers_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class OfferDetailsScreen extends StatefulWidget {
  final int id;

  const OfferDetailsScreen({super.key, required this.id});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  late Future<Map> offerDetails;
  bool isLoading = false;

  @override
  void initState() {
    offerDetails = OfferServices.getById(widget.id);
    super.initState();
  }

  Future<void> retry() async {
    setState(() {
      isLoading = true;
    });

    offerDetails = OfferServices.getById(widget.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<Map>(
            future: offerDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  isLoading) {
                return const Center(
                  child: SpinKitChasingDots(
                    color: AppUI.primaryColor,
                  ),
                );
              }
              if (snapshot.hasData) {
                Offer offer = snapshot.data!['offer'];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailSlider(
                          images: offer.images,
                          title: offer.name,
                          id: offer.id),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.padding16,
                          horizontal: Dimensions.padding24,
                        ),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(Dimensions.padding16),
                        decoration: BoxDecoration(
                          borderRadius: Dimensions.borderRadius10,
                          color: AppUI.lightCardColor,
                        ),
                        child: CustomTitleText(
                          title: offer.name,
                          fontSize: Dimensions.font18,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.padding16,
                          horizontal: Dimensions.padding24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "خصم حتى ${offer.percentage}%",
                                style: const TextStyle(
                                  fontSize: Dimensions.font18,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${intl.NumberFormat('#,###').format(offer.offer)} ${AppConstant.currency[offer.currency] ?? offer.currency}',
                                  style: const TextStyle(
                                    fontSize: Dimensions.font18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: Dimensions.padding8,
                                ),
                                CustomOldPrice(
                                  price: offer.price,
                                  fontSize: Dimensions.font16,
                                  currency: offer.currency,
                                  decorationColor: null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.padding16,
                          horizontal: Dimensions.padding24,
                        ),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(Dimensions.padding16),
                        decoration: BoxDecoration(
                          borderRadius: Dimensions.borderRadius10,
                          color: AppUI.lightCardColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "${AppConstant.offerType[offer.type]}",
                              style: const TextStyle(
                                fontSize: Dimensions.font16,
                              ),
                            ),
                            Text(
                              offer.description,
                              style: const TextStyle(
                                fontSize: Dimensions.font16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ProviderAddress(
                        provider: offer.provider,
                      ),
                      if (!offer.expiryDate
                          .difference(DateTime.now())
                          .isNegative)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.padding16,
                            horizontal: Dimensions.padding24,
                          ),
                          child: const Text(
                            "مده العرض",
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (!offer.expiryDate
                          .difference(DateTime.now())
                          .isNegative)
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.padding16,
                              horizontal: Dimensions.padding8,
                            ),
                            alignment: Alignment.center,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return FlipCountdownClock(
                                duration:
                                    offer.expiryDate.difference(DateTime.now()),
                                digitSize: constraints.maxWidth / 11,
                                width: constraints.maxWidth / 11,
                                height: Dimensions.countdownItemHeight,
                                digitColor: AppUI.secondaryColor,
                                backgroundColor: const [
                                  AppUI.gradient2Color,
                                  AppUI.gradient1Color,
                                ],
                                separatorColor: AppUI.secondaryColor,
                                hingeColor: AppUI.primaryColor,
                                borderRadius: Dimensions.borderRadius10,
                                onDone: () => {},
                              );
                            }),
                          ),
                        ),
                      ActionsRow(
                        offer: offer,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.padding16,
                          horizontal: Dimensions.padding24,
                        ),
                        child: const Text(
                          'عروض ذات صلة',
                          style: TextStyle(
                            fontSize: Dimensions.font16,
                          ),
                        ),
                      ),
                      SuggestionList(offers: snapshot.data!['suggestions']),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return CustomFailed(
                  onRetry: retry,
                );
              } else {
                return const Center(
                  child: SpinKitChasingDots(
                    color: AppUI.primaryColor,
                  ),
                );
              }
            }),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
            bottom: Dimensions.padding8,
            left: Dimensions.padding16,
          ),
          child: FloatingActionButton(
            heroTag: "support_chat_offer_detials",
            onPressed: () {
              Get.to(() => const ChatScreen());
            },
            child: SvgPicture.asset(AppAssets.supportChat),
          ),
        ),
      ),
    );
  }
}

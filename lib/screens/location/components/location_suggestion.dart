import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:offers_awards/models/api_response.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/models/provider.dart';
import 'package:offers_awards/screens/provider/offers_list_screen.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/screens/widgets/custom_icon_text_button.dart';
import 'package:offers_awards/screens/widgets/custom_load_more.dart';
import 'package:offers_awards/screens/widgets/custom_network_image.dart';
import 'package:offers_awards/screens/widgets/offer/offer_item.dart';
import 'package:offers_awards/services/offers_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LocationSuggestion extends StatefulWidget {
  final Function() hideLocationDetails;
  final String locationDetails;
  final Provider provider;

  const LocationSuggestion(
      {super.key,
      required this.hideLocationDetails,
      required this.locationDetails,
      required this.provider});

  @override
  State<LocationSuggestion> createState() => _LocationSuggestionState();
}

class _LocationSuggestionState extends State<LocationSuggestion> {
  late Future<ApiResponse<Offer>> contentList;
  int offset = 1;
  late int totalOffset;
  late int count;
  bool isLoading = false;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<bool> getContentList() async {
    offset++;
    if (offset > totalOffset) {
      setState(() {
        refreshController.loadNoData();
        refreshController.footerMode!.value = LoadStatus.noMore;
      });
      return true;
    }
    ApiResponse<Offer> result =
        await OfferServices.getByProvider(widget.provider.id, offset);

    setState(() {
      contentList.then((value) => value.items.addAll(result.items));
    });

    return result.items.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    contentList = OfferServices.getByProvider(widget.provider.id, offset);

    contentList.then((value) {
      totalOffset = value.offsetCount;
      count = value.count;
    });
  }

  Future<void> retry() async {
    setState(() {
      isLoading = true;
    });
    contentList =
        contentList = OfferServices.getByProvider(widget.provider.id, offset);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: widget.hideLocationDetails,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: AppUI.secondaryColor,
              ),
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.padding16,
                horizontal: Dimensions.padding24,
              ),
              child: Column(
                children: [
                  CustomIconTextButton(
                    text: widget.locationDetails,
                    iconPath: AppAssets.activeLocation,
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      Dimensions.padding8,
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.to(
                          () => OffersListScreen(
                            provider: widget.provider,
                          ),
                        );
                      },
                      tileColor: AppUI.greyCardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: Dimensions.borderRadius10,
                      ),
                      leading: ClipRRect(
                        borderRadius: Dimensions.borderRadius50,
                        child: CustomNetworkImage(
                          imageUrl: widget.provider.logo,
                          width: Dimensions.logoSize,
                          height: Dimensions.logoSize,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: Dimensions.icon16,
                      ),
                      title: Text(
                        widget.provider.name,
                        style: const TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'عرض ${widget.provider.offerNum}',
                        style: const TextStyle(
                          fontSize: Dimensions.font14,
                          color: AppUI.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: FutureBuilder<ApiResponse<Offer>>(
                        future: contentList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              isLoading) {
                            return const Center(
                              child: SpinKitChasingDots(
                                color: AppUI.primaryColor,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            return CustomLoadMore(
                              refreshController: refreshController,
                              getData: getContentList,
                              length: snapshot.requireData.items.length,
                              total: count,
                              body: ListView.builder(
                                itemCount: snapshot.requireData.items.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: Dimensions.offerHeight,
                                    child: OfferItem(
                                      offer: snapshot.requireData.items[index],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return CustomFailed(
                              onRetry: retry,
                            );
                          }
                          return const Center(
                            child: SpinKitChasingDots(
                              color: AppUI.primaryColor,
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: kBottomNavigationBarHeight,
            ),
          ],
        ),
      ),
    );
  }
}


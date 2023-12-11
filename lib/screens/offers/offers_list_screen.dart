import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:offers_awards/models/api_response.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/screens/widgets/custom_load_more.dart';
// import 'package:offers_awards/screens/widgets/custom_search_container.dart';
import 'package:offers_awards/screens/widgets/offer/offer_item.dart';
import 'package:offers_awards/services/offers_services.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OffersListScreen extends StatefulWidget {
  final String title;
  final int? customSliderID;

  const OffersListScreen({
    Key? key,
    required this.title,
    this.customSliderID,
  }) : super(key: key);

  @override
  State<OffersListScreen> createState() => _OffersListScreenState();
}

class _OffersListScreenState extends State<OffersListScreen> {
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
    late ApiResponse<Offer> result;
    if (widget.customSliderID == null) {
      result = await OfferServices.getWithFilter(widget.title, offset);
    } else {
      result = await OfferServices.getByCustomSlider(widget.customSliderID!, offset);
    }
    setState(() {
      contentList.then((value) => value.items.addAll(result.items));
    });

    return result.items.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    if (widget.customSliderID == null) {
      contentList = OfferServices.getWithFilter(widget.title, offset);
    } else {
      contentList =  OfferServices.getByCustomSlider(widget.customSliderID!, offset);
    }

    contentList.then((value) {
      totalOffset = value.offsetCount;
      count = value.count;
    });
  }
  Future<void> retry() async {
    setState(() {
      isLoading = true;
    });
    contentList = widget.customSliderID == null
        ? OfferServices.getWithFilter(widget.title, offset)
        :  OfferServices.getByCustomSlider(widget.customSliderID!, offset);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(
        title: AppConstant.offerFilter[widget.title] ?? widget.title,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.padding16,
          horizontal: Dimensions.padding16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (widget.customSlider != null)
            //   Padding(
            //     padding: EdgeInsets.only(
            //       bottom: Dimensions.padding24,
            //     ),
            //     child: const CustomSearchContainer(
            //       isWhite: false,
            //     ),
            //   ),
            Expanded(
              child: FutureBuilder<ApiResponse<Offer>>(
                  future: contentList,
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
    );
  }
}

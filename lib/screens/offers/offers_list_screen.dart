import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:offers_awards/models/api_response.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/screens/widgets/custom_load_more.dart';
import 'package:offers_awards/screens/widgets/custom_search_container.dart';
import 'package:offers_awards/screens/widgets/offer/offer_item.dart';
import 'package:offers_awards/services/offers_services.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OffersListScreen extends StatefulWidget {
  final String title;
  final int? providerId;

  const OffersListScreen({
    Key? key,
    required this.title,
    this.providerId,
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
    if (widget.providerId == null) {
      result = await OfferServices.getWithFilter(widget.title, offset);
    } else {
      result = await OfferServices.getByProvider(widget.providerId!, offset);
    }
    setState(() {
      contentList.then((value) => value.items.addAll(result.items));
    });

    return result.items.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    if (widget.providerId == null) {
      contentList = OfferServices.getWithFilter(widget.title, offset);
    } else {
      contentList = OfferServices.getByProvider(widget.providerId!, offset);
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
    contentList = widget.providerId == null
        ? OfferServices.getWithFilter(widget.title, offset)
        : OfferServices.getByProvider(widget.providerId!, offset);
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
            if (widget.providerId != null)
              Padding(
                padding: EdgeInsets.only(
                  bottom: Dimensions.padding24,
                ),
                child: const CustomSearchContainer(
                  isWhite: false,
                ),
              ),
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
                        length: snapshot.data!.items.length,
                        total: count,
                        body: ListView.builder(
                          itemCount: snapshot.data!.items.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: Dimensions.offerHeight,
                              child: OfferItem(
                                offer: snapshot.data!.items[index],
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

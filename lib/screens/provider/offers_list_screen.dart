import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:offers_awards/models/api_response.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/models/provider.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/screens/widgets/custom_load_more.dart';
import 'package:offers_awards/screens/widgets/custom_network_image.dart';
import 'package:offers_awards/screens/widgets/custom_title_text.dart';
import 'package:offers_awards/screens/widgets/offer/offer_item.dart';
import 'package:offers_awards/services/offers_services.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OffersListScreen extends StatefulWidget {
  final Provider provider;

  const OffersListScreen({
    Key? key,
    required this.provider,
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
    result = await OfferServices.getByProvider(widget.provider.id, offset);
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
    contentList = OfferServices.getByProvider(widget.provider.id, offset);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 2),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          widget.provider.name,
          style: const TextStyle(
            color: AppUI.secondaryColor,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppUI.secondaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(
              Dimensions.padding8,
            ),
            child: ClipRRect(
              borderRadius: Dimensions.borderRadius50,
              child: CustomNetworkImage(
                imageUrl: widget.provider.logo,
                width: Dimensions.logoSize,
                height: Dimensions.logoSize,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomNetworkImage(
            imageUrl: widget.provider.cover,
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.padding8,
              horizontal: Dimensions.padding16,
            ),
            child: const CustomTitleText(
              title: 'المنتجات',
              fontSize: Dimensions.font18,
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
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.padding20,
                      ),
                      child: CustomLoadMore(
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
    );
  }
}

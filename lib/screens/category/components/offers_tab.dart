import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:offers_awards/controllers/category_controller.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/widgets/custom_load_more.dart';
import 'package:offers_awards/screens/widgets/offer/offer_item.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OffersTab extends StatefulWidget {
  const OffersTab({
    Key? key,
  }) : super(key: key);

  @override
  State<OffersTab> createState() => _OffersTabState();
}

class _OffersTabState extends State<OffersTab> {
  final CategoryController categoryController = Get.find<CategoryController>();

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int offset = 1;

  Future<bool> getContentList() async {
    if (offset > categoryController.totalOffsets.value) {
      setState(() {
        refreshController.loadNoData();
        refreshController.footerMode!.value = LoadStatus.noMore;
      });
      return true;
    }
    bool result = await categoryController.nextPage();
    setState(() {
      offset++;
    });

    return result;
  }

  @override
  void initState() {
    super.initState();
    offset++;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (categoryController.isLoading.isTrue) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimensions.padding24),
            // Adjust the height as needed
            const SpinKitChasingDots(
              color: AppUI.primaryColor,
            ),
          ],
        );
      } else {
        if (categoryController.items.isNotEmpty) {
          return CustomLoadMore(
            refreshController: refreshController,
            getData: getContentList,
            length: categoryController.offers.length,
            total: categoryController.count.value,
            body: ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: categoryController.offers.length,
              itemBuilder: (context, index) {
                final Offer offer = categoryController.offers[index];
                return SizedBox(
                  height: Dimensions.offerHeight,
                  child: OfferItem(
                    offer: offer,
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            alignment: Alignment.topCenter,
            child: Lottie.asset(
              AppAssets.emptyList,
              fit: BoxFit.scaleDown,
              repeat: false,
            ),
          );
        }
      }
    });
  }
}

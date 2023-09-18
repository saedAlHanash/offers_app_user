import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:offers_awards/controllers/category_controller.dart';
import 'package:offers_awards/models/provider.dart';
import 'package:offers_awards/screens/offers/offers_list_screen.dart';
import 'package:offers_awards/screens/widgets/custom_load_more.dart';
import 'package:offers_awards/screens/widgets/custom_network_image.dart';
import 'package:offers_awards/screens/widgets/custom_title_text.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProvidersTab extends StatefulWidget {
  const ProvidersTab({Key? key}) : super(key: key);

  @override
  State<ProvidersTab> createState() => _ProvidersTabState();
}

class _ProvidersTabState extends State<ProvidersTab> {
  final CategoryController categoryController = Get.find<CategoryController>();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<bool> getContentList() async {
    if (categoryController.page > categoryController.totalOffsets.value) {
      setState(() {
        refreshController.loadNoData();
        refreshController.footerMode!.value = LoadStatus.noMore;
      });
      return true;
    }
    bool result = await categoryController.nextPage();

    return result;
  }

  @override
  void initState() {
    super.initState();
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
            length: categoryController.providers.length,
            total: categoryController.count.value,
            body: ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: categoryController.providers.length,
                itemBuilder: (BuildContext context, int index) {
                  final Provider provider = categoryController.providers[index];
                  return Padding(
                    padding: EdgeInsets.all(
                      Dimensions.padding8,
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.to(
                          () => OffersListScreen(
                            title: provider.name,
                            providerId: provider.id,
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
                          imageUrl: provider.logo,
                          width: Dimensions.logoSize,
                          height: Dimensions.logoSize,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: Dimensions.icon16,
                      ),
                      title: CustomTitleText(
                        title: provider.name,
                      ),
                      subtitle: Text(
                        " عرض${provider.offerNum}",
                        style: const TextStyle(
                          fontSize: Dimensions.font14,
                          color: AppUI.primaryColor,
                        ),
                      ),
                    ),
                  );
                }),
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

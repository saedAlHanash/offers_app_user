import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/category_controller.dart';
import 'package:offers_awards/screens/category/components/merchants_tab.dart';
import 'package:offers_awards/screens/category/components/offers_tab.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class OffersProvidersTabs extends StatelessWidget {
  const OffersProvidersTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final OffersProvidersGetTabs tabs = Get.put(OffersProvidersGetTabs());

    return Column(
      children: [
        //tab bar
        Container(
          decoration: BoxDecoration(
            color: AppUI.greyCardColor,
            borderRadius: Dimensions.borderRadius24,
          ),
          margin: EdgeInsets.all(Dimensions.padding8),
          child: TabBar(
            controller: tabs.tabController,
            indicator: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
            ),
            labelColor: AppUI.primaryColor,
            unselectedLabelColor: AppUI.textColor,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: tabs.myTabs,
          ),
        ),
        //tab bar view
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.9,
          child: TabBarView(
            controller: tabs.tabController,
            children: const [
              OffersTab(),
              //merchants tab content
              ProvidersTab(),
            ],

          ),
        ),
      ],
    );
  }
}
class OffersProvidersGetTabs extends GetxController with GetSingleTickerProviderStateMixin{
  late TabController tabController;
  final List<Tab> myTabs=[ const Tab(
    text: 'العروض',
  ),
    const Tab(
      text: 'التجار',
    ),];
  @override
  void onInit() {
    tabController=TabController(length: 2, vsync: this);
    tabController.addListener(() {
      final selectedTab = tabController.index;
      final CategoryController categoryController = Get.find<CategoryController>();

      if (selectedTab == 0) {
        categoryController.changeTab('vouchers');
      } else if (selectedTab == 1) {
        categoryController.changeTab('providers');
      }
    });
    super.onInit();
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

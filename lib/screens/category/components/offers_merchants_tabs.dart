import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/category_controller.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class OffersProvidersTabs extends StatefulWidget {
  const OffersProvidersTabs({super.key});

  @override
  State<OffersProvidersTabs> createState() => _OffersProvidersTabsState();
}

class _OffersProvidersTabsState extends State<OffersProvidersTabs> {
  late int selectedTab;
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  void initState() {
    selectedTab = categoryController.query.value == 'vouchers' ? 0 : 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppUI.greyCardColor,
        borderRadius: Dimensions.borderRadius24,
      ),
      margin: EdgeInsets.all(Dimensions.padding8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = 0;
              });
              categoryController.changeTab('vouchers');
            },
            child: Padding(
              padding: EdgeInsets.all(Dimensions.padding8),
              child: Text(
                'العروض',
                style: TextStyle(
                  color:
                      selectedTab == 0 ? AppUI.primaryColor : AppUI.textColor,
                  fontWeight:
                      selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = 1;
              });
              categoryController.changeTab('providers');
            },
            child: Padding(
              padding: EdgeInsets.all(Dimensions.padding8),
              child: Text(
                'التجار',
                style: TextStyle(
                  color:
                      selectedTab == 1 ? AppUI.primaryColor : AppUI.textColor,
                  fontWeight:
                      selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

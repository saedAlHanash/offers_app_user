import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/category_controller.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class OffersProvidersTabs extends StatelessWidget {
  const OffersProvidersTabs({super.key});


  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.find<CategoryController>();
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

              categoryController.changeTab('vouchers');
            },
            child: Padding(
              padding: EdgeInsets.all(Dimensions.padding8),
              child: Text(
                'العروض',
                style: TextStyle(
                  color:
                  categoryController.query.value == 'vouchers' ? AppUI.primaryColor : AppUI.textColor,
                  fontWeight:
                  categoryController.query.value == 'vouchers' ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              categoryController.changeTab('providers');
            },
            child: Padding(
              padding: EdgeInsets.all(Dimensions.padding8),
              child: Text(
                'التجار',
                style: TextStyle(
                  color:
                  categoryController.query.value == 'providers' ? AppUI.primaryColor : AppUI.textColor,
                  fontWeight:
                  categoryController.query.value == 'providers' ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

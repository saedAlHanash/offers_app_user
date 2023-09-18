import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/category_controller.dart';
import 'package:offers_awards/screens/widgets/custom_light_text.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class SortDialog {
  static show({
    required BuildContext context,
  }) {
    final CategoryController categoryController =
        Get.find<CategoryController>();
    String? selectedChoice = categoryController.sort.value;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: WillPopScope(
            onWillPop: () async => true,
            child: SizedBox(
              // height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.85,
              child: ClipRRect(
                borderRadius: Dimensions.borderRadius10,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: SingleChildScrollView(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.padding16,
                              vertical: Dimensions.padding24,
                            ),
                            alignment: Alignment.center,
                            child: const CustomLightText(
                              text: "ترتيب حسب",
                              fontSize: Dimensions.font24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            children: AppConstant.sortFields
                                .map(
                                  (sortItem) => RadioListTile(
                                    title: CustomLightText(
                                      text: sortItem['title']!,
                                      fontSize: Dimensions.font14,
                                    ),
                                    value: sortItem['value'],
                                    groupValue: selectedChoice,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedChoice = value!;
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (selectedChoice != null) {
                                categoryController.changeSort(selectedChoice!);
                              }
                              Get.back();
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: Dimensions.padding16,
                                vertical: Dimensions.padding24,
                              ),
                              padding: EdgeInsets.all(Dimensions.padding8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: Dimensions.borderRadius24,
                                color: AppUI.buttonColor3,
                              ),
                              child: const Text(
                                "حفظ التغيرات",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

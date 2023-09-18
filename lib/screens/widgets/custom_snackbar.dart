import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomSnackBar {
  static showRowSnackBarSuccess(String msg) {
    Get.rawSnackbar(
      message: msg,
      borderRadius: Dimensions.radius10,
      margin: EdgeInsets.all(Dimensions.padding24),
      barBlur: 0.5,
      backgroundColor: AppUI.darkCardColor.withOpacity(0.8),
    );
  }

  static showRowSnackBarError(String msg) {
    Get.rawSnackbar(
      message: msg,
      borderRadius: Dimensions.radius10,
      margin: EdgeInsets.all(Dimensions.padding24),
      barBlur: 0.5,
      backgroundColor: AppUI.redMap.shade400,
    );
  }

  static showSnackBarSuccess(String title, String msg) {
    Get.snackbar(
      title, msg,
        borderRadius: Dimensions.radius10,
        margin: EdgeInsets.all(Dimensions.padding24),
        barBlur: 0.5,
        colorText: AppUI.secondaryColor,
        backgroundColor: AppUI.darkCardColor.withOpacity(0.8),
        snackPosition: SnackPosition.BOTTOM);
  }

  static showSnackBarError(String title, String msg) {
    Get.snackbar(title, msg,
        borderRadius: Dimensions.radius10,
        colorText: AppUI.secondaryColor,
        margin: EdgeInsets.all(Dimensions.padding24),
        barBlur: 0.5,
        backgroundColor: AppUI.redMap.shade400,
        snackPosition: SnackPosition.BOTTOM);
  }
}

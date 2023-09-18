import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar {
  static AppBar appBar(
          {required String title, List<Widget>? actions, bool isBack = true}) =>
      AppBar(
        title: Text(title),
        leading: isBack
            ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
              )
            : null,
        actions: actions,
        automaticallyImplyLeading: isBack,
      );
}

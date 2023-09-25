import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dimensions {
  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;

  //const padding
  static double padding4 = 4.0;
  static double padding6 = 6.0;
  static double padding8 = 8.0;
  static double padding16 = 16.0;
  static double padding20 = 20.0;
  static double padding24 = 24.0;

  //const border radius
  static BorderRadius borderRadius10 = BorderRadius.circular(10.0);
  static BorderRadius borderRadius15 = BorderRadius.circular(15.0);
  static BorderRadius borderRadius24 = BorderRadius.circular(24.0);
  static BorderRadius borderRadius50 = BorderRadius.circular(50.0);

  //radius
  static double radius10 = screenHeight / 70.34;
  static double radius15 = screenHeight / 56.27;
  static double radius20 = screenHeight / 42.2;
  static double radius30 = screenHeight / 28.13;

  //icon size
  static const double icon10 = 10.0;
  static const double icon16 = 16.0;
  static const double icon21 = 21.0;
  static const double icon26 = 26.0;
  static const double icon32 = 32.0;

  static const int locationSize = 80;

  //font size
  static const double font12 = 12.0;
  static const double font14 = 14.0;
  static const double font16 = 16.0;
  static const double font18 = 18.0;
  static const double font20 = 20.0;
  static const double font24 = 24.0;

  //heights
  static double categoriesListWidth = Dimensions.screenWidth * 0.3; //125;
  static double categoriesListHeight = categoriesListWidth ; //120;

  // height: MediaQuery.of(context).size.height * 0.2,
  static double bannerListHeight = Dimensions.screenWidth * 0.45; //150;
  static double bannerListWidth = Dimensions.screenWidth * 0.9; //300;

  // height: MediaQuery.of(context).size.height * 0.3,
  static double offerHeight = 290;
  static double favOfferHeight = 300;

  static double logoSize = 40.0;
  static double countdownItemHeight = 62.0;
  static double notificationCardHeight = 70.0;
  static double notificationImageHeight = 135.0;
  static double notificationHeight = 100.0;
  static double splashIconWidth = 100.0;
}

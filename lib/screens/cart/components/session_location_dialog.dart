import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/place_controller.dart';
import 'package:offers_awards/models/session_data.dart';
import 'package:offers_awards/screens/auth/select_location_screen.dart';
import 'package:offers_awards/screens/location/components/customize_marker.dart';
import 'package:offers_awards/screens/widgets/custom_icon_text_button.dart';
import 'package:offers_awards/screens/widgets/custom_input_decoration.dart';
import 'package:offers_awards/screens/widgets/custom_light_text.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class SessionLocationDialog {
  static edit({
    required BuildContext context,
    required SessionData userInfo,
  }) {
    final formKey = GlobalKey<FormState>();
    final countryController = TextEditingController(text: userInfo.country);
    final areaController = TextEditingController(text: userInfo.area);
    final addressController = TextEditingController(text: userInfo.address);
    double latitude = userInfo.latitude;
    double longitude = userInfo.longitude;
    final PlaceController placeController = Get.find<PlaceController>();
    bool isLoading = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: WillPopScope(
            onWillPop: () async => true,
            child: Stack(
              children: [
                SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: ClipRRect(
                    borderRadius: Dimensions.borderRadius10,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: SingleChildScrollView(
                        child: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Form(
                            key: formKey,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.padding16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.padding16,
                                      vertical: Dimensions.padding24,
                                    ),
                                    alignment: Alignment.center,
                                    child: const CustomLightText(
                                      text: "تعديل العنوان",
                                      fontSize: Dimensions.font24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  CustomIconTextButton(
                                    text: ' التعديل بواسطة GPS',
                                    iconPath: AppAssets.activeLocation,
                                    function: () async {
                                      final hasPermission =
                                          await CustomizeLocation
                                              .handleLocationPermission();
                                      if (hasPermission) {
                                        final result = await Get.to(
                                            const SelectLocationScreen());
                                        if (result != null &&
                                            result is Map<String, String>) {
                                          areaController.text =
                                              result['address'] ??
                                                  userInfo.area;
                                          countryController.text =
                                              result['country'] ??
                                                  userInfo.country;
                                          addressController.text =
                                              result['homeStreet'] ??
                                                  userInfo.address;
                                          latitude = double.parse(
                                              result['latitude'] ??
                                                  userInfo.latitude.toString());
                                          longitude = double.parse(
                                              result['longitude'] ??
                                                  userInfo.latitude.toString());
                                        }
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.padding16),
                                    child: TextFormField(
                                      controller: countryController,
                                      // readOnly: preventEdit,
                                      readOnly: true,
                                      decoration: CustomInputDecoration.build(
                                          'المحافظة'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return FormValidator.countryNullError;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.padding16),
                                    child: TextFormField(
                                      controller: areaController,
                                      decoration: CustomInputDecoration.build(
                                          'اسم المنطقة'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return FormValidator.areaNullError;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.padding16),
                                    child: TextFormField(
                                      controller: addressController,
                                      decoration: CustomInputDecoration.build(
                                          'عنوان المنزل'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return FormValidator.homeNullError;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (isLoading) {
                                        CustomSnackBar.showRowSnackBarError(
                                            "الرجاء الانتظار");
                                      } else {
                                        isLoading = true;
                                        if (formKey.currentState!.validate()) {
                                          var result = await placeController
                                              .editUserInfo(
                                            address: addressController.text,
                                            country: countryController.text,
                                            area: areaController.text,
                                            latitude: latitude,
                                            longitude: longitude,
                                          );
                                          if (result && context.mounted) {
                                            isLoading = false;
                                            Navigator.pop(
                                                context); // Close the dialog using the current context
                                          }
                                        }
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: Dimensions.padding16,
                                        vertical: Dimensions.padding24,
                                      ),
                                      padding:
                                          EdgeInsets.all(Dimensions.padding8),
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
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  top: 0.0,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const CircleAvatar(
                      backgroundColor: AppUI.greyCardColor,
                      child: Icon(Icons.close, color: AppUI.textColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

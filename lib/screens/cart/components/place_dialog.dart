import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/place_controller.dart';
import 'package:offers_awards/screens/widgets/custom_input_decoration.dart';
import 'package:offers_awards/screens/widgets/custom_light_text.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/services/places_services.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class PlaceDialog {
  static create({
    required BuildContext context,
    required dynamic result,
  }) {
    final formKey = GlobalKey<FormState>();
    TextEditingController labelController = TextEditingController();
    TextEditingController locationController = TextEditingController(
        text:
            "${result['country']} ${result['address']} ${result['homeStreet'] ?? ''}");

    final PlaceController placeController = Get.find<PlaceController>();
    bool isLoading=false;
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
                                  TextFormField(
                                    controller: labelController,
                                    decoration:
                                        CustomInputDecoration.build('العنوان'),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return "الرجاء ملىء تفاصيل الموقع";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: Dimensions.padding16,
                                  ),
                                  TextFormField(
                                    controller: locationController,
                                    decoration:
                                        CustomInputDecoration.build('الموقع'),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return "الرجاء ملىء تفاصيل الموقع";
                                      }
                                      return null;
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (isLoading) {
                                        CustomSnackBar.showRowSnackBarError(
                                            "الرجاء الانتظار");
                                      } else {
                                        isLoading=true;
                                        FocusScope.of(context).unfocus();
                                        // Validate the form
                                        if (formKey.currentState!.validate()) {
                                          PlacesServices.create(
                                            label: labelController.text,
                                            location: locationController.text,
                                            latitude: double.parse(
                                                result['latitude'] ?? '0.0'),
                                            longitude: double.parse(
                                                result['longitude'] ?? '0.0'),
                                          ).then((value) {
                                            placeController.addPlace(value);
                                            placeController.select(value);
                                            isLoading=false;

                                            Get.back();
                                          });
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

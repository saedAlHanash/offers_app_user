import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/place_controller.dart';
import 'package:offers_awards/screens/widgets/custom_input_decoration.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({Key? key}) : super(key: key);

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  final PlaceController _placeController = Get.find<PlaceController>();
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: _placeController.places.length,
        itemBuilder: (context, index) {
          final reversedIndex = _placeController.places.length - index - 1;
          return GestureDetector(
            onTap: () {
              setState(() {
                _placeController.select(_placeController.places[reversedIndex]);
              });
            },
            child: Container(
              decoration: _placeController.selectedPlace.value?.id ==
                      _placeController.places[reversedIndex].id
                  ? BoxDecoration(
                      borderRadius: Dimensions.borderRadius24,
                      border: Border.all(
                        color: AppUI.primaryColor,
                        width: 2,
                      ),
                      // color: AppUI.redMap.shade50,
                    )
                  : null,
              margin: EdgeInsets.symmetric(vertical: Dimensions.padding16),
              child: TextFormField(
                enabled: false,
                controller: _placeController.areas[reversedIndex],
                style: const TextStyle(
                  color: AppUI.textColor,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                decoration: CustomInputDecoration.build('اسم المنطقة'),
              ),
            ),
          );
        },
      );
    });
  }
}

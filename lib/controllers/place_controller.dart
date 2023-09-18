import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/db/session.dart';
import 'package:offers_awards/models/place.dart';
import 'package:offers_awards/models/session_data.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/services/places_services.dart';
import 'package:offers_awards/services/profile_services.dart';

class PlaceController extends GetxController {
  RxList<Place> places = <Place>[].obs;
  RxList<TextEditingController> areas = <TextEditingController>[].obs;
  Rx<Place?> selectedPlace = Rx<Place?>(null);
  late Rx<SessionData> userInfo;

  PlaceController() {
    SessionManager.getSessionData().then((value) {
      userInfo.value = value;
    });
  }
  Future<List<Place>> fetchPlaces() async {
    Future<List<Place>> result = PlacesServices.fetch();

    userInfo = Rx<SessionData>(await SessionManager.getSessionData());

    places.value = await result;
    for (Place place in places) {
      areas.add(TextEditingController(text: place.label));
    }
    return result;
  }

  Future<void> retry() async {
    places.value = await PlacesServices.fetch();
    update();
  }

  void select(Place? place) {
    selectedPlace.value = place;
    update();
  }

  void addPlace(Place place) {
    places.add(place);
    // areas.add(TextEditingController(text: "${place.label} ${place.location}"));
    areas.add(TextEditingController(text: place.label));
    update();
  }

  Future<void> edit(Place place, String label, String location) async {
    Place updatedPlace = Place(
      id: place.id,
      label: label,
      location: location,
      latitude: place.latitude,
      longitude: place.longitude,
    );
    bool success = await PlacesServices.edit(place: updatedPlace);

    if (success) {
      int index = places.indexWhere((p) => p.id == place.id);
      if (index != -1) {
        places[index] = updatedPlace;
        areas[index].text = label;
      }
    }
    update();
  }

  void remove(Place place, TextEditingController controller) {
    if (places.length > 1) {
      PlacesServices.remove(place.id).then((value) {
        if (value) {
          places.remove(place);
          areas.remove(controller);
        }
      });
    } else {
      CustomSnackBar.showRowSnackBarError("على الأقل يجب ان تحوي موقع واحد");
    }
    update();
  }

  Future<bool> editUserInfo({
    required String address,
    required String country,
    required String area,
    required double latitude,
    required double longitude,
  }) async {
    try {
      var value = await ProfileServices.editInfo(
        name: userInfo.value.name,
        phone: userInfo.value.phone,
        email: userInfo.value.email,
        birthdate: userInfo.value.birthday.toString(),
        address: address,
        country: country,
        area: area,
        latitude: latitude,
        longitude: longitude,
      );

      if (value) {
        userInfo.value = SessionData(
          userInfo.value.name,
          userInfo.value.phone,
          userInfo.value.email,
          country,
          area,
          address,
          userInfo.value.image,
          userInfo.value.birthday,
          userInfo.value.token,
          latitude,
          longitude,
        );

        update();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}

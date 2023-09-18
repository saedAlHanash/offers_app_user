import 'dart:convert';

import 'package:offers_awards/models/place.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/utils/api_list.dart';
import 'package:offers_awards/utils/network.dart';

class PlacesServices {
  static Future<List<Place>> fetch() async {
    List<Place> places = [];
    final response = await Network.httpGetRequest(APIList.places, {});
    if (response.statusCode == 200) {
      for (final Map<String, dynamic> place
          in jsonDecode(response.body)['data']) {
        places.add(Place.fromJson(place));
      }
      return places;
    }
    throw Exception('Failed to connect remote data source');
  }

  static Future<Place> create({
    required String label,
    required String location,
    required double latitude,
    required double longitude,
  }) async {
    Map<String, dynamic> sendingMap = {
      "label": label,
      "location": location.isEmpty ? "_" : location,
      "latitude": latitude,
      "longitude": longitude
    };
    final response =
        await Network.httpPostMapBody(APIList.places, json.encode(sendingMap));
    if (response.statusCode == 200) {
      return Place.fromJson(jsonDecode(response.body)["data"]);
    } else if (response.statusCode == 422 ||
        response.statusCode == 401 ||
        response.statusCode == 404) {
      var body = jsonDecode(response.body);
      CustomSnackBar.showRowSnackBarError(body['message']);
    } else {
      CustomSnackBar.showRowSnackBarError("حدث خطا يرجى المحاولة مرة اخرى");
    }
    throw Exception('Failed to connect remote data source');
  }

  static Future<bool> edit(
      {required Place place}) async {
    Map<String, dynamic> sendingMap = {
      "label": place.label,
      "location": place.location,
      "latitude": place.latitude,
      "longitude": place.longitude
    };
    final response =
        await Network.httpPutRequest("${APIList.places}/${place.id}", json.encode(sendingMap));
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 422 ||
        response.statusCode == 401 ||
        response.statusCode == 404) {
      var body = jsonDecode(response.body);
      CustomSnackBar.showRowSnackBarError(body['message']);
      return false;
    } else {
      CustomSnackBar.showRowSnackBarError("حدث خطا يرجى المحاولة مرة اخرى");
      return false;
    }
  }

  static Future<bool> remove(int id) async {
    final response =
        await Network.httpDeleteRequest("${APIList.places}/$id", {});
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 422) {
      var body = jsonDecode(response.body);
      CustomSnackBar.showRowSnackBarError(body['message']);
    } else if (response.statusCode == 404) {
      CustomSnackBar.showRowSnackBarError("عذرا هذا الموقع لم يعد موجود");
      return false;
    } else {
      CustomSnackBar.showRowSnackBarError("حدث خطا يرجى المحاولة مرة اخرى");
      return false;
    }
    throw Exception('Failed to connect remote data source');
  }
}

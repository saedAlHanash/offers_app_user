import 'dart:convert';
import 'dart:io';
import 'package:offers_awards/db/session.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/utils/api_list.dart';
import 'package:offers_awards/utils/network.dart';

class ProfileServices {
  static Future<bool> editInfo({
    String? name,
    String? address,
    String? phone,
    String? email,
    String? country,
    String? area,
    String? birthdate,
    double? latitude,
    double? longitude,
  }) async {
    final response = await Network.httpPostRequest(APIList.updateInfo, {
      if (name != null) "name": name.toString(),
      if (address != null) "address": address.toString(),
      if (phone != null) "phone": phone.toString(),
      if (email != null) "email": email.toString(),
      if (country != null) "government": country.toString(),
      if (area != null) "area": area.toString(),
      if (birthdate != null) "birthdate": birthdate.toString(),
      if (latitude != null) "latitude": latitude.toString(),
      if (longitude != null) "longitude": longitude.toString(),
    });

    if (response.statusCode == 200) {
      CustomSnackBar.showRowSnackBarSuccess("تم التعديل بنجاح");

      await SessionManager.update(
        name: name,
        phone: phone,
        email: email,
        address: address,
        country: country,
        area: area,
        birthdate: birthdate,
        latitude: latitude,
        longitude: longitude,
      );
      return true;
    } else if (response.statusCode == 422) {
      var body = jsonDecode(response.body);
      var key = body['errors'].keys.toList().first;
      var value = body['errors'][key].first;
      CustomSnackBar.showSnackBarError(
        value,
        body['message'],
      );
      return false;
    } else {
      CustomSnackBar.showRowSnackBarError("حدث خطا يرجى المحاولة مرة اخرى");
      return false;
    }
  }

  static Future<String> editImage(File image) async {
    final response = await Network.httpPostMultipartRequest(
        APIList.updateImage, image, 'image');
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      await SessionManager.update(
          image: jsonDecode(respStr)['data']['profile_image_url']);
      CustomSnackBar.showRowSnackBarSuccess("تم التعديل بنجاح");
      return jsonDecode(respStr)['data']['profile_image_url'];
    } else if (response.statusCode == 422) {
      CustomSnackBar.showRowSnackBarError("خطأ في الصورة");
    } else {
      CustomSnackBar.showRowSnackBarError("حدث خطا يرجى المحاولة مرة اخرى");
    }
    throw Exception('Failed to connect remote data source');
  }

  static Future<bool> resetPassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final response = await Network.httpPostRequest(APIList.resetPassword, {
      "old_password": oldPassword.toString(),
      "new_password": newPassword.toString(),
      "new_password_confirmation": confirmNewPassword.toString(),
    });
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 422) {
      var body = jsonDecode(response.body);
      var key = body['errors'].keys.toList().first;
      var value = body['errors'][key].first;
      CustomSnackBar.showSnackBarError(
        value,
        body['message'],
      );
      return false;
    } else if (response.statusCode == 401) {
      var body = jsonDecode(response.body);
      CustomSnackBar.showRowSnackBarError(
        body['message'],
      );
      return false;
    } else {
      CustomSnackBar.showRowSnackBarError("حدث خطا يرجى المحاولة مرة اخرى");
      return false;
    }
  }


}

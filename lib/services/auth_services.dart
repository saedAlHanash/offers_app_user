import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/db/session.dart';
import 'package:offers_awards/db/settings.dart';
import 'package:offers_awards/screens/auth/vcode_screen.dart';
import 'package:offers_awards/screens/navigator_screen.dart';
import 'package:offers_awards/notifications/fcm.dart';
import 'package:offers_awards/screens/onboarding/welcome_screen.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/utils/api_list.dart';
import 'package:offers_awards/utils/network.dart';

class AuthServices {
  static Future<bool> login({
    required String phone,
    required String password,
  }) async {
    var data = {
      "phone": phone.toString(),
      "password": password.toString(),
    };
    var value = await getFcmToken();
    debugPrint("value $value");
    //dDzxzsnWQNCwATgRVbWcSq:APA91bEMUhIIcWXZfiZdObglqO6scYfSCsaRwfDmTFAludK9Pt7IoMaiV8UchU6VPz9_iyRKxfxDy_YuueVkG0qENPXJZ7w2m41PFjmfTBhvP93qbSDkMpGJ1yKMEJCK9aM5o3049rM1
    if (value != null) {
      data["fcm_token"] = value;
    }
    final response = await Network.httpPostRequest(APIList.login, data);
    var body = jsonDecode(response.body)['data'];
    if (response.statusCode == 200) {
      SessionManager.create(
        name: body['user']['name'],
        // authToken: body['token'],
        phone: phone,
        address: body['user']['address'] ?? "",
        image: body['user']['profile_image_url'],
        email: body['user']['email'] ?? "",
        country: body['user']['government'] ?? "",
        area: body['user']['area'] ?? "",
        latitude: body['user']['latitude'] ?? 0.0,
        longitude: body['user']['longitude'] ?? 0.0,
        birthdate: body['user']['birthdate'] != null
            ? DateTime.parse(body['user']['birthdate'])
            : null,
      );
      if (body['user']['is_confirmed']) {
        await SessionManager.setToken(body['token']);
        Settings.setNotification(true);
        Get.offAll(
          () => const MyHomePage(),
        );
      } else {
        Get.to(
          () => VCodeScreen(
            email: body['user']['email'],
            phone: phone,
            token: body['token'],
          ),
        );
      }
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

  static Future<bool> register({
    required String name,
    required String phone,
    required String email,
    required String address,
    required String country,
    required String area,
    required String password,
    required String passwordConf,
    required double latitude,
    required double longitude,
  }) async {
    var data = {
      "name": name.toString(),
      "phone": phone.toString(),
      "email": email.toString(),
      "password": password.toString(),
      "password_confirmation": passwordConf.toString(),
      "government": country.toString(),
      "address": address.toString(),
      "area": area.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    };
    var value = await getFcmToken();
    debugPrint("value $value");
    if (value != null) {
      data["fcm_token"] = value;
    }

    final response = await Network.httpPostRequest(APIList.register, data);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)['data'];
      SessionManager.create(
        name: name,
        // authToken: body['token'],
        phone: phone,
        email: email,
        address: address,
        country: country,
        area: area,
        latitude: latitude,
        longitude: longitude,
      );
      Settings.setNotification(true);
      Get.to(
        () => VCodeScreen(
          email: email,
          phone: phone,
          token: body['token'],
        ),
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

  static Future<bool> destroyAccount() async {
    final response =
        await Network.httpDeleteRequest(APIList.destroyAccount, {});

    if (response.statusCode == 200) {
      CustomSnackBar.showRowSnackBarSuccess(
          jsonDecode(response.body)['message']);
      SessionManager.clearSession();
      Settings.setNotification(false);
      return true;
    } else if (response.statusCode == 401) {
      CustomSnackBar.showRowSnackBarError("غير مصّرح لك");
      return false;
    } else {
      CustomSnackBar.showRowSnackBarError("حدث خطا يرجى المحاولة مرة اخرى");
      return false;
    }
  }

  static Future<bool> logout() async {
    final response = await Network.httpPostRequest(APIList.logout, {});
    await SessionManager.clearSession();
    if (response.statusCode == 200) {
      Settings.setNotification(false);
      return true;
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }

  static Future<Map<String, dynamic>> getEmail(String phone) async {
    final response = await Network.httpPostRequest(APIList.email, {
      'phone': phone.toString(),
    });
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return {'email': body['email']};
    } else if (response.statusCode == 401 || response.statusCode == 422) {
      var body = jsonDecode(response.body);
      CustomSnackBar.showRowSnackBarError(
        body['message'],
      );
      return {};
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }

  static Future<bool> verify(String phone, String code, String token) async {
    final response = await Network.httpPostRequest(APIList.verify, {
      'token': code.toString(),
      'phone': phone.toString(),
    });
    if (response.statusCode == 200) {
      await SessionManager.setToken(token);
      Get.to(() => const WelcomeScreen());
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 422) {
      var body = jsonDecode(response.body);
      CustomSnackBar.showRowSnackBarError(
        body['message'],
      );
      return false;
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }

  static Future<bool> forgotPassword({
    required String phone,
    required String token,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final response = await Network.httpPostRequest(APIList.forgotPassword, {
      "phone": phone.toString(),
      "token": token.toString(),
      "password": newPassword.toString(),
      "password_confirmation": confirmNewPassword.toString(),
    });
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401 ||
        response.statusCode == 422 ||
        response.statusCode == 400) {
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

  static Future<bool> resendVerification({
    required String phone,
  }) async {
    final response = await Network.httpPostRequest(APIList.resendVerification, {
      "phone": phone.toString(),
    });
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 422) {
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

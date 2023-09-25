import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:offers_awards/db/session.dart';
import 'package:offers_awards/screens/auth/login_screen.dart';
import 'package:offers_awards/screens/error_screen.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';

class Network {
  static const String _baseURL = "admin.offers-iq.com";
  static const String _api = "client/";

  static Future<http.Response> httpGetRequest(
      String apiURL, Map<String, dynamic> args) async {
    String token = await SessionManager.getToken();
    try {
      if (token.isEmpty) {
        Get.off(() => const LoginScreen());
      }

      final cacheManager = CacheManager(Config('http_cache'));
      var file = await cacheManager.getSingleFile(
        Uri.https(_baseURL, _api + apiURL, args).toString(),
        headers: {"Authorization": 'Bearer $token'},
      );

      if (await file.exists()) {
        var res = await file.readAsString();
        return http.Response(res, 200);
      }

      var response = await http.get(
        Uri.https(_baseURL, _api + apiURL, args),
        headers: {
          "Authorization": 'Bearer $token',
          "Accept": "application/json",
          HttpHeaders.cacheControlHeader: 'max-age=3600',
        },
      );

      if (response.statusCode == 401) {
        CustomSnackBar.showRowSnackBarSuccess("عذراً الجلسة انتهت");
        SessionManager.clearSession();
      } else if (response.statusCode == 404) {
        Get.off(() => const ErrorScreen());
        return response;
      }

      cacheManager.putFile(
        Uri.https(_baseURL, _api + apiURL, args).toString(),
        response.bodyBytes,
      );
      return response;
    } catch (e) {
      if (e is http.Response && e.statusCode == 404) {
        Get.off(() => const ErrorScreen());
        return e;
      }
      rethrow;
    }
  }

  static Future<http.Response> httpPostRequest(
      String apiURL, Map<String, dynamic> args) async {
    String token = await SessionManager.getToken();
    return http.post(Uri.https(_baseURL, _api + apiURL), body: args, headers: {
      "Authorization": 'Bearer $token',
      "Accept": "application/json",
    });
  }

  static Future<http.Response> httpPostGetRequest(
      String apiURL, Map<String, dynamic> args) async {
    String token = await SessionManager.getToken();
    return http
        .post(Uri.https(_baseURL, _api + apiURL, args), body: args, headers: {
      "Authorization": 'Bearer $token',
      "Accept": "application/json",
    });
  }

  static Future<http.Response> httpPostMapBody(
      String apiURL, dynamic args) async {
    String token = await SessionManager.getToken();
    var response = http.post(
      Uri.https(_baseURL, _api + apiURL),
      body: args,
      headers: {
        "Authorization": 'Bearer $token',
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    return response;
  }

  static Future<http.Response> httpDeleteRequest(
      String apiURL, Map<String, dynamic> args) async {
    String token = await SessionManager.getToken();
    return http
        .delete(Uri.https(_baseURL, _api + apiURL), body: args, headers: {
      "Authorization": 'Bearer $token',
      "Accept": "application/json",
    });
  }

  static Future<http.Response> httpPutRequest(
      String apiURL, dynamic args) async {
    String token = await SessionManager.getToken();
    return http.put(Uri.https(_baseURL, _api + apiURL), body: args, headers: {
      "Authorization": 'Bearer $token',
      "Accept": "application/json",
    });
  }

  static Future<http.StreamedResponse> httpPostMultipartRequest(
      String apiURL, File file, String key) async {
    String token = await SessionManager.getToken();
    var uri = Uri.https(_baseURL, _api + apiURL);
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      "Authorization": 'Bearer $token',
      "Accept": "application/json",
    });

    request.files.add(await http.MultipartFile.fromPath(key, file.path));
    return request.send();
  }

  static Future<http.StreamedResponse> httpPostMultipartRequestWithFields(
      {required String apiURL,
      File? file1,
      required String keyFile1,
      File? file2,
      String? keyFile2,
      required Map data}) async {
    String token = await SessionManager.getToken();
    var uri = Uri.https(_baseURL, _api + apiURL);
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      "Authorization": 'Bearer $token',
      "Accept": "application/json",
    });
    if (file1 != null) {
      request.files
          .add(await http.MultipartFile.fromPath(keyFile1, file1.path));
    }
    if (file2 != null && keyFile2 != null) {
      request.files
          .add(await http.MultipartFile.fromPath(keyFile2, file2.path));
    }
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    return request.send();
  }
}

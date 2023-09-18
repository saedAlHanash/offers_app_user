import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offers_awards/models/notification.dart';
import 'package:offers_awards/notifications/fcm.dart';
import 'package:offers_awards/utils/api_list.dart';
import 'package:offers_awards/utils/network.dart';

class NotificationsServices {
  static Future<List<NotificationModel>> fetch() async {
    List<NotificationModel> notificationList = [];
    final response = await Network.httpGetRequest(APIList.notifications, {});
    if (response.statusCode == 200) {
      for (final Map<String, dynamic> notification
          in jsonDecode(response.body)['data']) {
        notificationList.add(NotificationModel.fromJson(notification));
      }
      return notificationList;
    }
    throw Exception('Failed to connect remote data source');
  }

  Future<bool> enableNotification(bool enable) async {
    Map<String, dynamic> data = {};
    if (enable) {
      var value = await getFcmToken();
      debugPrint("value $value");
      if (value != null) {
        data["fcm_token"] = value;
      }
    } else {
      data["fcm_token"] = "";
    }

    final response = await Network.httpPostRequest(APIList.storeFcmToken, data);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 422) {
      return false;
    }
    throw Exception('Failed to connect remote data source');
  }
}

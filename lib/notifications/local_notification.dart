import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:offers_awards/screens/offer_details/offer_details_screen.dart';
import 'package:offers_awards/screens/order/invoice_screen.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notiPlugin =
      FlutterLocalNotificationsPlugin();

  void initialize(RemoteMessage message) {
    InitializationSettings initialSettings = InitializationSettings(
      android: const AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
      iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification:
              (int id, String? title, String? body, String? payload) async {}),
    );
    _notiPlugin.initialize(
      initialSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        handleMessage(message);
      },
    );
  }

  static void showNotification(RemoteMessage message) {

    const NotificationDetails notiDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'com.adam.store',
        'push_notification',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    _notiPlugin.show(
      DateTime.now().second,
      message.notification!.title,
      message.notification!.body,
      notiDetails,
      payload: message.data['image'],
    );
  }

  Future<void> setupInteractMessage() async {
    //app terminate
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }
    //app background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(message);
    });
  }

  void handleMessage(RemoteMessage message) {
    if (message.data.containsKey('order_id')) {
      Get.to(
        () => InvoiceScreen(
          id: int.parse(message.data["order_id"].toString()),
          orderNumber: int.parse(message.data["order_number"].toString()),
        ),
      );
    } else if (message.data.containsKey('voucher_id')) {
      Get.to(
        () => OfferDetailsScreen(
          id: int.parse(message.data["voucher_id"].toString()),
        ),
      );
    }
  }
}

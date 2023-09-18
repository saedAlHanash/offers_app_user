import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/cart_controller.dart';
import 'package:offers_awards/db/cart.dart';
import 'package:offers_awards/db/recent_search.dart';
import 'package:offers_awards/db/settings.dart';
import 'package:offers_awards/notifications/firebase_options.dart';
import 'package:offers_awards/notifications/local_notification.dart';
import 'package:offers_awards/screens/onboarding/slplash_screen.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/custom_theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppUI.secondaryColor,
    statusBarBrightness:  Brightness.light,
    statusBarIconBrightness: Brightness.dark,
  ));

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initGetController();
  runApp(const MyApp());
}

Future<void> initGetController() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => Cart(sharedPreferences: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.find<CartController>().getCartData();
  RecentSearch.init();
  Settings.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalNotification().initialize();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification.showNotification(message);
    });
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: CustomThemData.themeData,
        debugShowCheckedModeBanner: false,
        locale: const Locale("ar"),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: const SplashScreen(),
      ),
    );
  }
}

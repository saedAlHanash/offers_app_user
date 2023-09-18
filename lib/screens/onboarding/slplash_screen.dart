import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/db/session.dart';
import 'package:offers_awards/screens/navigator_screen.dart';
import 'package:offers_awards/screens/auth/login_screen.dart';
import 'package:offers_awards/screens/onboarding/onboarding_screen.dart';
import 'package:offers_awards/screens/widgets/deep_link.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> navigateToOnBoardingScreen(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool alreadyVisited = prefs.getBool('alreadyVisited') ?? false;
    // Get.off(() => const OnBoardingScreen());

    if (alreadyVisited) {
      SessionManager.isLoggedIn().then(
        (loggedIn) {
          if (!loggedIn) {
            Get.offAll(() => const LoginScreen());
          } else {
            Get.offAll(() => const MyHomePage());
            DeepLink.start(true);
          }
        },
      );

      DeepLink.start(true);
    } else {
      prefs.setBool('alreadyVisited', true);
      Get.off(() => const OnBoardingScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      navigateToOnBoardingScreen(context);
    });
  }

  @override
  void dispose() {
    // initGetController();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black54,
          image: DecorationImage(
            image: AssetImage(
              AppAssets.splash,
            ),
            fit: BoxFit.cover,
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Column(
            children: [
              const Spacer(
                flex: 1,
              ),
              ClipRRect(
                borderRadius: Dimensions.borderRadius50,
                child: Image.asset(
                  AppAssets.logo2,
                  width: Dimensions.splashIconWidth,
                  fit: BoxFit.cover,
                ),
              ),
              // CircleAvatar(
              //   radius: 50,
              //   backgroundImage: AssetImage(AppAssets.logo2),
              // ),
              const Spacer(
                flex: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

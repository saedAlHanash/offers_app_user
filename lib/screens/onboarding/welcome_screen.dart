import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offers_awards/screens/navigator_screen.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 2, microseconds: 5))
      ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.padding24,
            ),
            child: const SizedBox(
              height: kBottomNavigationBarHeight,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimensions.padding24),
            child: const Text(
              'مرحبا بك ف عروض وجوائز',
              style: TextStyle(
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.bold,
                  color: AppUI.primaryColor),
              textAlign: TextAlign.center,
            ),
          ),
          ScaleTransition(
            scale: animation,
            child: SvgPicture.asset(
              AppAssets.done,
              fit: BoxFit.scaleDown,
            ),
          ),
          // Lottie.asset(
          //   AppAssets.welcome,
          //   fit: BoxFit.fill,
          //   // repeat: true,
          // ),
          Padding(
            padding: EdgeInsets.all(Dimensions.padding24),
            child: const Text(
              'تم التسجيل بنجاح',
              style: TextStyle(
                fontSize: Dimensions.font18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.padding24,
            ),
            child: const SizedBox(
              height: kBottomNavigationBarHeight,
            ),
          )
        ],
      ),
    );
  }
}

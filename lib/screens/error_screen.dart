import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/utils/app_assets.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(title: "هذا العنصر غير موجود"),
      body: Container(
        alignment: Alignment.topCenter,
        child: Lottie.asset(
          AppAssets.emptyList,
          fit: BoxFit.scaleDown,
          repeat: false,
        ),
      ),
    );
  }
}

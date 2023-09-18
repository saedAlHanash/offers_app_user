import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomFailed extends StatelessWidget {
  final VoidCallback onRetry;
  const CustomFailed({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          AppAssets.failed,
          fit: BoxFit.fill,
          // repeat: true,
        ),
        Padding(
          padding: EdgeInsets.all(Dimensions.padding24),
          child: const Text(
            'عذراً حدث خطأ في تحميل البيانات',
            style: TextStyle(
              fontSize:Dimensions.font16,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.padding24,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRetry,
              child: const Text(
               "إعادة المحاولة ↻",
              ),
            ),
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
    );
  }
}

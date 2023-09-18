import 'package:flutter/material.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomSliderIndicator extends StatelessWidget {
  final int activeIndex;
  final int count;
  const CustomSliderIndicator(
      {super.key, required this.activeIndex, required this.count});

  @override
  Widget build(BuildContext context) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: count,
      effect: const ScaleEffect(
        dotColor: AppUI.secondaryColor,
        dotWidth: 6,
        dotHeight: 6,
        activeDotColor: AppUI.primaryColor,
      ),
    );

  }
}

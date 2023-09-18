import 'package:flutter/material.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class OnBoardingItem extends StatelessWidget {
  final int index;
  final int currentPageIndex;
  const OnBoardingItem(
      {super.key, required this.index, required this.currentPageIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(
          flex: 1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.padding16,
            // vertical: Dimensions.padding8,
          ),
          child: Text(
            AppConstant.screens[index].title,
            style: const TextStyle(
              fontSize: Dimensions.font24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.padding16,
            vertical: Dimensions.padding8,
          ),
          child: Text(
            AppConstant.screens[index].subtitle,
            style: const TextStyle(
              fontSize: Dimensions.font16,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.padding16,
            vertical: Dimensions.padding16,
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                AppConstant.screens.length,
                (index) => Container(
                  width: Dimensions.icon10,
                  height: Dimensions.icon10,
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.padding8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppUI.textColor),
                    color: currentPageIndex == index
                        ? AppUI.textColor
                        : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Spacer(
          flex: 5,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class UsageCount extends StatelessWidget {
  final int maxUsage;
  final int availableCount;

  const UsageCount(
      {Key? key, required this.maxUsage, required this.availableCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.padding16,
            horizontal: Dimensions.padding24,
          ),
          child: const Text(
            "العدد المتبقي",
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: Dimensions.padding16,
              right: Dimensions.padding16,
              bottom: Dimensions.padding16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppUI.gradient2Color,
                          AppUI.gradient2Color,
                          AppUI.gradient1Color,
                        ]),
                    borderRadius: Dimensions.borderRadius10,
                  ),
                  height: 48,
                  alignment: Alignment.center,
                  child: Text(
                    availableCount.toString(),
                    style: const TextStyle(
                      color: AppUI.secondaryColor,
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: Dimensions.padding8,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppUI.primaryColor),
                    borderRadius: Dimensions.borderRadius15,
                  ),
                  height: 48,
                  alignment: Alignment.center,
                  child: Text(
                    maxUsage.toString(),
                    style: const TextStyle(
                      color: AppUI.hintTextColor,
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

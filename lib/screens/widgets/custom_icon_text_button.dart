import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomIconTextButton extends StatelessWidget {
  final String text;
  final String? iconPath;
  final Widget? icon;
  final Function? function;

  const CustomIconTextButton({
    Key? key,
    required this.text,
    this.iconPath,
    this.icon,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (function != null) {
          function!();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: Dimensions.padding16),
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.padding16,
              vertical:iconPath!=null? Dimensions.padding4:Dimensions.padding8,
            ),
            decoration: BoxDecoration(
              color: AppUI.greyCardColor,
              borderRadius: Dimensions.borderRadius24,
            ),
            // padding: const EdgeInsets.all(2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: constraints.maxWidth -
                    (Dimensions.icon21 * 2 + Dimensions.padding24),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.padding8),
                child: iconPath != null
                    ? SvgPicture.asset(
                        iconPath!,
                        height: Dimensions.icon21,
                        fit: BoxFit.scaleDown,
                      )
                    : icon ?? const SizedBox(),
              ),
            ],
          ),
          );
        }
      ),
    );
  }
}

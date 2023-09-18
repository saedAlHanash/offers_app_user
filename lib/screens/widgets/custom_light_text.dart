import 'package:flutter/material.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomLightText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomLightText({
    Key? key,
    required this.text,
    this.fontSize = Dimensions.font16,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        color: AppUI.secondaryColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}

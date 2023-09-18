import 'package:flutter/material.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomTitleText extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;

   const CustomTitleText({
    Key? key,
    required this.title,
     this.fontSize= Dimensions.font16,
     this.fontWeight= FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight:fontWeight,
      ),
    );
  }
}

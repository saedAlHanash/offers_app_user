import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:offers_awards/utils/app_ui.dart';

class CustomOldPrice extends StatelessWidget {
  final double price;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? decorationColor;

  const CustomOldPrice({
    Key? key,
    required this.price,
    this.color = AppUI.hintTextColor,
    this.fontSize,
    this.decorationColor = AppUI.primaryColor,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          '${NumberFormat('#,###').format(price)} د.ع',
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: Divider(
            color: decorationColor,
            thickness: 1.25,
          ),
        ),
      ],
    );
  }
}

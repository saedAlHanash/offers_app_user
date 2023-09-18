import 'package:flutter/material.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomChip extends StatelessWidget {
  final Function onTap;
  final String text;

  const CustomChip({Key? key, required this.onTap, this.text = "اشتري العرض"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Chip(
        label: Text(
          text,
          style: const TextStyle(fontSize: Dimensions.font14),
        ),
        shape: RoundedRectangleBorder(borderRadius: Dimensions.borderRadius50),
        padding: EdgeInsets.all(Dimensions.padding4),
      ),
    );
  }
}

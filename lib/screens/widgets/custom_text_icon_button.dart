import 'package:flutter/material.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomTextIconButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;

  const CustomTextIconButton(
      {Key? key, required this.text, required this.icon, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.padding24,
      ),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(
                color: AppUI.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.padding8),
              child: Icon(
                icon,
                color: AppUI.primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}

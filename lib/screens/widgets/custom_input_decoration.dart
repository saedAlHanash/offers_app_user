import 'package:flutter/material.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomInputDecoration {
  static InputDecoration build(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: AppUI.greyCardColor,
      border: OutlineInputBorder(
        borderRadius: Dimensions.borderRadius24,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: Dimensions.borderRadius24,
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: Dimensions.borderRadius24,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.2),
        ),
        borderRadius: Dimensions.borderRadius24,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: Dimensions.padding8,
        horizontal: Dimensions.padding16,
      ),
    );
  }

  static InputDecoration search(String hintText, Function onPress) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      prefixIcon: IconButton(
        icon: const Icon(Icons.search, color: AppUI.textColor),
        onPressed: () {
          onPress();
        },
      ),
      fillColor: AppUI.greyCardColor,
      border: OutlineInputBorder(
        borderRadius: Dimensions.borderRadius24,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: Dimensions.borderRadius24,
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: Dimensions.borderRadius24,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.2),
        ),
        borderRadius: Dimensions.borderRadius24,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: Dimensions.padding8,
        horizontal: Dimensions.padding16,
      ),
    );
  }

  static InputDecoration buildPassword({
    required bool showPassword,
    required Function() togglePasswordVisibility,
    String hintText = '',
  }) {
    return InputDecoration(
      hintText: hintText.isNotEmpty ? hintText : 'كلمة المرور',
      filled: true,
      fillColor: AppUI.greyCardColor,
      border: OutlineInputBorder(
        borderRadius: Dimensions.borderRadius24,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: Dimensions.borderRadius24,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: !showPassword
              ? Colors.grey.withOpacity(0.2)
              : AppUI.greenBorderColor,
        ),
        borderRadius: Dimensions.borderRadius24,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: Dimensions.padding8,
        horizontal: Dimensions.padding16,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          showPassword ? Icons.visibility : Icons.visibility_off,
          color: !showPassword ? AppUI.iconColor1 : AppUI.greenBorderColor,
        ),
        onPressed: togglePasswordVisibility,
      ),
    );
  }
}

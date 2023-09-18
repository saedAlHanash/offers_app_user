import 'package:flutter/material.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinCode extends StatefulWidget {
  final Function(String value) onChanged;
  final bool Function(String? text) beforeTextPaste;
  const CustomPinCode({Key? key, required this.onChanged, required this.beforeTextPaste}) : super(key: key);

  @override
  State<CustomPinCode> createState() => _CustomPinCodeState();
}

class _CustomPinCodeState extends State<CustomPinCode> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: PinCodeTextField(
          appContext: context,
          mainAxisAlignment: MainAxisAlignment.center,
          textStyle: const TextStyle(color: AppUI.textColor),
          pastedTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          length: FormValidator.pinLength,
          hintCharacter: "-",
          hintStyle: const TextStyle(
            color: AppUI.hintTextColor,
            fontWeight: FontWeight.bold,
          ),
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            fieldOuterPadding: const EdgeInsets.all(4),
            // fieldHeight: 70,
            // fieldWidth: 70,
            activeFillColor: AppUI.lightCardColor,
            inactiveFillColor: AppUI.lightCardColor,
            selectedFillColor: AppUI.lightCardColor,
            activeColor: AppUI.lightCardColor,
            selectedColor: AppUI.lightCardColor,
            inactiveColor: AppUI.lightCardColor,
            borderRadius: Dimensions.borderRadius15,
            errorBorderColor: AppUI.errorTextColor,
          ),
          animationType: AnimationType.slide,
          // errorAnimationController: errorController,
          // cursorColor: AppColors.primary,
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          keyboardType: TextInputType.number,
          onCompleted: widget.onChanged,
          onChanged: widget.onChanged,
          beforeTextPaste: widget.beforeTextPaste,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomThemData {
  static ThemeData themeData = ThemeData(
    fontFamily: 'Droid Arabic Kufi',
    useMaterial3: false,
    primarySwatch: AppUI.redMap,
    primaryColor: AppUI.primaryColor,
    unselectedWidgetColor: AppUI.secondaryColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppUI.secondaryColor,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: Dimensions.font18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Droid Arabic Kufi',
      ),
      iconTheme: IconThemeData(
        color: AppUI.textColor,
      ),
    ),
    buttonTheme: const ButtonThemeData(buttonColor: AppUI.buttonColor1),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          AppUI.buttonColor1,
        ),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: Dimensions.borderRadius10,
          ),
        ),
        padding: MaterialStateProperty.all(
           EdgeInsets.all(Dimensions.padding8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          AppUI.buttonColor1,
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: Dimensions.font14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Droid Arabic Kufi',
          ),
        ),
      ),
    ),
    scaffoldBackgroundColor: AppUI.backgroundColor,
    floatingActionButtonTheme:  FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: Dimensions.borderRadius10,
      ),
      backgroundColor: AppUI.buttonColor3,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: Dimensions.font20,
        color: AppUI.textColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'Droid Arabic Kufi',
      ),
      bodyLarge: TextStyle(
        fontSize: Dimensions.font16,
        color: AppUI.textColor,
        fontFamily: 'Droid Arabic Kufi',
      ),
    ),
  );
}

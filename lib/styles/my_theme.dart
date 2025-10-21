import 'package:rawaa_app/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:rawaa_app/styles/my_color.dart';

abstract class MyTheme {
  static ThemeData customTheme() {
    return ThemeData(
      primaryColor: Constants.primaryColor,
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardThemeData(
        surfaceTintColor: Colors.white,
        color: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Poppins'),
        displayMedium: TextStyle(fontFamily: 'Poppins'),
        displaySmall: TextStyle(fontFamily: 'Poppins'),
        headlineLarge: TextStyle(fontFamily: 'Poppins'),
        headlineMedium: TextStyle(fontFamily: 'Poppins'),
        headlineSmall: TextStyle(fontFamily: 'Poppins'),
        titleLarge: TextStyle(fontFamily: 'Poppins'),
        titleMedium: TextStyle(fontFamily: 'Poppins'),
        titleSmall: TextStyle(fontFamily: 'Poppins'),
        bodyLarge: TextStyle(fontFamily: 'Poppins'),
        bodyMedium: TextStyle(fontFamily: 'Poppins'),
        bodySmall: TextStyle(fontFamily: 'Poppins'),
        labelLarge: TextStyle(fontFamily: 'Poppins'),
        labelMedium: TextStyle(fontFamily: 'Poppins'),
        labelSmall: TextStyle(fontFamily: 'Poppins'),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(Colors.white),
        splashRadius: 35,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        fillColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return Constants.primaryColor; // Color when checked
          }
          return Colors.white; // Color when unchecked
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        // contentPadding: EdgeInsets.only(left: 5),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 0.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          gapPadding: 15,
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: MyColor.primaryColor, width: 0.7),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
    );
  }
}

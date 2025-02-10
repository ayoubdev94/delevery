import 'package:flutter/material.dart';

class AppTheme {
  // Define primary color and other related colors
  static const Color primaryColor = Colors.blue; // Main app color
  static const Color secondaryColor = Colors.orange; // For accents
  static const Color backgroundColor = Colors.white; // Background color
  static const Color surfaceColor = Colors.white; // Card/background surfaces
  static const Color textPrimaryColor = Colors.black; // Main text color
  static const Color textSecondaryColor = Colors.grey; // Secondary text color

  // Optional: Define different themes for light/dark modes
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      titleTextStyle: TextStyle(color: Colors.white),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textPrimaryColor, fontSize: 24, fontWeight: FontWeight.bold), // equivalent to headline6
      bodyLarge: TextStyle(color: textPrimaryColor), // equivalent to bodyText1
      bodyMedium: TextStyle(color: textSecondaryColor), // equivalent to bodyText2
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: primaryColor,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textPrimaryColor, fontSize: 24, fontWeight: FontWeight.bold), // equivalent to headline6
      bodyLarge: TextStyle(color: textPrimaryColor), // equivalent to bodyText1
    ),  
  );
}

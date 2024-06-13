import 'package:flutter/material.dart';
import 'package:tobetoapp/theme/light/light_text.dart';

class AppColors {
  static const Color tobetoMoru = Colors.deepPurple;
  //Color.fromARGB(255, 163, 77, 233);
}

final ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.tobetoMoru,
  colorScheme: const ColorScheme.light(
      primary: AppColors.tobetoMoru, secondary: Colors.deepPurple),
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 248, 248),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: AppColors.tobetoMoru),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.white,
    textTheme: ButtonTextTheme.primary,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.tobetoMoru,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.tobetoMoru),
    ),
    labelStyle: TextStyle(color: AppColors.tobetoMoru),
  ),
  cardTheme: CardTheme(
    color: Colors.grey[800],
    shadowColor: Colors.black45,
    elevation: 4,
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.tobetoMoru,
    //color: Colors.black,
    thickness: 1.0,
  ),
  textTheme: textLight,
);

import 'package:flutter/material.dart';
import 'package:tobetoapp/theme/dark/dark_text.dart';
import 'package:tobetoapp/theme/light/light_theme.dart';

final ThemeData darkTheme = ThemeData(
  primaryColor: Colors.deepPurple,
  colorScheme: const ColorScheme.dark(
      primary: Colors.deepPurple, secondary: AppColors.tobetoMoru),
  scaffoldBackgroundColor: Colors.white24,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black54,
    iconTheme: IconThemeData(color: AppColors.tobetoMoru),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  //drawerTheme:const DrawerThemeData(backgroundColor: Color.fromARGB(255, 0, 0, 0)),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColors.tobetoMoru,
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
  cardTheme: const CardTheme(
    //color: Colors.grey[800],
    shadowColor: Colors.black45,
    elevation: 4,
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.tobetoMoru,
    //color: Colors.white,
    thickness: 1.0,
  ),
  textTheme: textDark,
);

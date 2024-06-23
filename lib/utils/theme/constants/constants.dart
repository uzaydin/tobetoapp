import 'package:flutter/material.dart';

class AppConstants {
  static late double screenWidth;
  static late double screenHeight;

  static late double paddingSmall;
  static late double paddingMedium;
  static late double paddingLarge;
  static late double paddingXLarge;

  static late double verticalPaddingSmall;
  static late double verticalPaddingMedium;
  static late double verticalPaddingLarge;
  static late double verticalPaddingXLarge;

  static late double sizedBoxHeightSmall;
  static late double sizedBoxHeightMedium;
  static late double sizedBoxHeightLarge;
  static late double sizedBoxHeightXLarge;
  static late double sizedBoxHeightXXLarge;

  static late double sizedBoxWidthSmall;
  static late double sizedBoxWidthMedium;
  static late double sizedBoxWidthLarge;
  static late double sizedBoxWidthXLarge;
  static late double sizedBoxWidthXXLarge;

  static late double profileImageSize;
  static late double br8;
  static late double br10;
  static late double br16;
  static late double br20;
  static late double br30;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    // Horizontal Padding and Margin
    paddingSmall = screenWidth * 0.025; // %2.5 of screen width
    paddingMedium = screenWidth * 0.04; // %4 of screen width
    paddingLarge = screenWidth * 0.075; // %7.5 of screen width
    paddingXLarge = screenWidth * 0.2; // %20 of screen width

    // Vertical Padding and Margin
    verticalPaddingSmall = screenHeight * 0.025; // %2.5 of screen height
    verticalPaddingMedium = screenHeight * 0.04; // %4 of screen height
    verticalPaddingLarge = screenHeight * 0.075; // %7.5 of screen height
    verticalPaddingXLarge = screenHeight * 0.2; // %20 of screen height

    profileImageSize = screenWidth * 0.2; // %20 of screen width

    // SizedBox Heights
    sizedBoxHeightSmall = screenHeight * 0.02; // %2 of screen height
    sizedBoxHeightMedium = screenHeight * 0.03; // %3 of screen height
    sizedBoxHeightLarge = screenHeight * 0.04; // %4 of screen height
    sizedBoxHeightXLarge = screenHeight * 0.05; // %5 of screen height
    sizedBoxHeightXXLarge = screenHeight * 0.06; // %6 of screen height

    // SizedBox Widths
    sizedBoxWidthSmall = screenWidth * 0.025; // %2.5 of screen width
    sizedBoxWidthMedium = screenWidth * 0.05; // %5 of screen width
    sizedBoxWidthLarge = screenWidth * 0.075; // %7.5 of screen width
    sizedBoxWidthXLarge = screenWidth * 0.1; // %10 of screen width
    sizedBoxWidthXXLarge = screenWidth * 0.2; // %20 of screen width

    // Border Radius
    br8 = screenWidth * 0.02; // %2 of screen width
    br10 = screenWidth * 0.025; // %2.5 of screen width
    br16 = screenWidth * 0.04; // %4 of screen width
    br20 = screenWidth * 0.05; // %5 of screen width
    br30 = screenWidth * 0.075; // %7.5 of screen width
  }
}

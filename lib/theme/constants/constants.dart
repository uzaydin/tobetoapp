import 'package:flutter/material.dart';

class AppConstants {
  static late double screenWidth;
  static late double screenHeight;

  static late double paddingSmall;
  static late double paddingMedium;
  static late double paddingLarge;
  static late double paddingXLarge;

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

    // Padding and Margin
    paddingSmall = screenWidth * 0.025;
    paddingMedium = screenWidth * 0.04;
    paddingLarge = screenWidth * 0.075;
    paddingXLarge = screenWidth * 0.2;

    profileImageSize = screenWidth * 0.2;

    sizedBoxHeightSmall = screenHeight * 0.02;
    sizedBoxHeightMedium = screenHeight * 0.03;
    sizedBoxHeightLarge = screenHeight * 0.04;
    sizedBoxHeightXLarge = screenHeight * 0.05;
    sizedBoxHeightXXLarge = screenHeight * 0.06;

    sizedBoxWidthSmall = screenWidth * 0.025;
    sizedBoxWidthMedium = screenWidth * 0.05;
    sizedBoxWidthLarge = screenWidth * 0.075;
    sizedBoxWidthXLarge = screenWidth * 0.1;
    sizedBoxWidthXXLarge = screenWidth * 0.2;

    // Border Radius
    br8 = screenWidth * 0.02;
    br10 = screenWidth * 0.025;
    br16 = screenWidth * 0.04;
    br20 = screenWidth * 0.05;
    br30 = screenWidth * 0.075;
  }
}

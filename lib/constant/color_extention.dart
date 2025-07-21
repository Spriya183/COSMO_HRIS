import 'package:attendance_system/constant/app_color.dart';
import 'package:flutter/material.dart';

extension MaterialColorExtensions on BuildContext {
  //color
  Color applyAppColor({required MaterialColor palette, int swatch = 500}) =>
      palette[swatch] ?? AppColor.appThemeColor;

  /// Creates a TextStyle with a color from the specified palette and swatch value.
  TextStyle textStyle({required MaterialColor palette, int swatch = 500}) =>
      TextStyle(color: applyAppColor(palette: palette, swatch: swatch));
  TextStyle textBlackStyle() => const TextStyle(color: AppColor.blackColor);
  TextStyle textStyleWithColor(Color color) => TextStyle(color: color);
}

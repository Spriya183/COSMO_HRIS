import 'package:attendance_system/constant/app_font_size.dart';
import 'package:attendance_system/constant/app_font_weight.dart';
import 'package:flutter/material.dart';

extension AppTextStyleExtension on TextStyle {
  //font weight
  TextStyle get xbold => copyWith(fontWeight: AppFontWeight.bold);
  TextStyle get bold => copyWith(fontWeight: AppFontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: AppFontWeight.semiBold);
  TextStyle get regular => copyWith(fontWeight: AppFontWeight.regular);
  TextStyle get light => copyWith(fontWeight: AppFontWeight.light);

  //font size
  TextStyle get header1 =>
      copyWith(fontSize: FontSize.header1, fontWeight: AppFontWeight.bold);
  TextStyle get header2 =>
      copyWith(fontSize: FontSize.header2, fontWeight: AppFontWeight.bold);
  TextStyle get header3 =>
      copyWith(fontSize: FontSize.header3, fontWeight: AppFontWeight.bold);
  TextStyle get header4 =>
      copyWith(fontSize: FontSize.header4, fontWeight: AppFontWeight.bold);
  TextStyle get header5 =>
      copyWith(fontSize: FontSize.header5, fontWeight: AppFontWeight.bold);
  TextStyle get header6 =>
      copyWith(fontSize: FontSize.header6, fontWeight: AppFontWeight.bold);
  //body text
  TextStyle get xlarge => copyWith(fontSize: FontSize.xlarge);
  TextStyle get large => copyWith(fontSize: FontSize.large);
  TextStyle get medium => copyWith(fontSize: FontSize.medium);
  TextStyle get small => copyWith(fontSize: FontSize.small);
  TextStyle get xsmall => copyWith(fontSize: FontSize.xsmall);
}

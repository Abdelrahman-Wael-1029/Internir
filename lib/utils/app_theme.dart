import 'package:flutter/material.dart';
import 'app_color.dart';

ThemeData themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColor.mainBlue,
  ),
  scaffoldBackgroundColor: AppColor.background,
  primaryColor: AppColor.mainBlue,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColor.background,
  ),
);

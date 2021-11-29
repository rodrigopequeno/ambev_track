import 'package:flutter/material.dart';

import 'colors.dart';
import 'fonts.dart';

mixin ThemeSystem {
  static ThemeData get get {
    return ThemeData.dark().copyWith(
      primaryColor: ColorSystem.primaryYellow,
      colorScheme: ColorScheme.fromSwatch(
        accentColor: ColorSystem.primaryYellow,
        brightness: Brightness.dark,
        cardColor: ColorSystem.primaryYellow,
        primarySwatch: Colors.grey,
      ),
      scaffoldBackgroundColor: ColorSystem.primaryDark,
      textTheme: Fonts.textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        titleTextStyle: Fonts.textTheme.headline6?.copyWith(
          color: ColorSystem.primaryDark,
        ),
      ),
    );
  }
}

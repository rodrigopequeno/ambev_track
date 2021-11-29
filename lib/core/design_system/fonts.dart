import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin Fonts {
  static TextTheme get textTheme => const TextTheme(
        headline1: TextStyle(
          fontSize: 107,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.5,
        ),
        headline2: TextStyle(
          fontSize: 67,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
        ),
        headline3: TextStyle(
          fontSize: 54,
          fontWeight: FontWeight.w400,
        ),
        headline4: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        headline5: TextStyle(
          fontSize: 27,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w400,
        ),
        headline6: TextStyle(
          fontSize: 22,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        subtitle1: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        ),
        subtitle2: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyText1: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyText2: TextStyle(
          fontSize: 16,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        button: TextStyle(
          fontSize: 16,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
        caption: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        overline: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
        ),
      );
}

import 'package:flutter/material.dart';
import '../utility/constant/constant.dart' as constant;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: const Color(0xffEFF2F5),
    primary: constant.primaryColor,
    secondary: Colors.grey.shade300,
    onBackground: Colors.white,
    onPrimaryContainer: Colors.white,
    surface: Colors.grey.shade200,
    onSecondaryContainer: constant.kIconColor,
  ),
  iconTheme: IconThemeData(
    color: constant.primaryColor,
    // color: Colors.purple,

  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: constant.textColor),
  ),
  shadowColor: Colors.black12,
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.white54,
  )

);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color(0xff1f1f1f),
    primary: Color(0xff2D3247),
    secondary: Color(0xff382039),
    onBackground: Color(0xff261C2C),
    onPrimaryContainer: Color(0xff454545),
    surface: Colors.black45,
    onSecondaryContainer: Colors.black54,
  ),
  iconTheme: const IconThemeData(
    // color:  Color(0xffECDBBA),
    color:  Color(0xff40F1D1),
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Color(0xffE2DFD0)),
    bodyLarge: TextStyle(color: Colors.white70),
  ),
  shadowColor: Colors.white54,
  bottomAppBarTheme: BottomAppBarTheme(
    color: const Color(0xff02092C).withAlpha(255),
  )
);

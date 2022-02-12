import 'package:flutter/material.dart';

class MyContant {
  static String appName = "SU libary";

  static Color primary = const Color(0xff81E9A8);
  static Color dark = const Color(0xffB87878);
  static Color light = const Color(0xffCFF9DD);

  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  BoxDecoration primaryBox() => BoxDecoration(color: primary.withOpacity(0.75));

  TextStyle h1Style() => TextStyle(
        color: dark,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      );

  TextStyle h2Style() => TextStyle(
        color: dark,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  TextStyle h3Style() => TextStyle(
        color: dark,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );
}

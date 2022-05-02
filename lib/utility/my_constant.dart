import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sulib/binding/auth_binding.dart';
import 'package:sulib/binding/basket_binding.dart';
import 'package:sulib/binding/my_service_binding.dart';
import 'package:sulib/binding/user_binding.dart';
import 'package:sulib/main.dart';
import 'package:sulib/mdels/address.dart';
import 'package:sulib/states/address_form.dart';
import 'package:sulib/states/address_list.dart';
import 'package:sulib/states/authen.dart';
import 'package:sulib/states/basket_summary.dart';
import 'package:sulib/states/create_account.dart';
import 'package:sulib/states/my_service.dart';
import 'package:sulib/states/splash.dart';

class MyContant {
  static String appName = "SU libary";

  static Color primary = const Color(0xff81E9A8);
  static Color dark = const Color(0xffB87878);
  static Color light = const Color(0xffCFF9DD);
  static Color black = const Color.fromARGB(255, 3, 3, 3);

  static String routeSplash = '/splash';
  static String routeMain = '/main';
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeMyService = '/myService';
  static String routeBasket = '/basket';
  static String routeAddressForm = '/addressForm';
  static String routeAddressList = '/addressList';
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
  TextStyle h4Style() => TextStyle(
        color: black,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  static Address addressLibrary = Address(
    firstName: 'หอสมุดพระราชวังสนามจันทร์',
    lastName: 'สำนักหอสมุดกลางมหาวิทยาลัยศิลปากร',
    phone: '034-255092',
    building: 'อาคารหอสมุดพระราชวังสนามจันทร์',
    addressNumber: '6',
    street: 'ราชมรรคาใน',
    district: 'เมือง',
    subDistrict: 'สนามจันทร์',
    province: 'นครปฐม',
    zipCode: '73000'
  );

}

class Collection {
  static String user = 'user';
  static String book = 'book';
  static String borrow = 'borrow';
  static String reserve = 'reserve';
}

class RoutesClass {
  static String main = MyContant.routeMain;

  static String getHomeRoute()=> main;

  static List<GetPage> routes = [
    GetPage(name: MyContant.routeMain, page: ()=> MainApp(), bindings: [AuthenBinding(), UserBinding()]),
    GetPage(name: MyContant.routeSplash, page:()=> const SplashApp(), binding: UserBinding(), transition: Transition.fade),
    GetPage(name: MyContant.routeMyService, page: ()=> const MyService(), bindings: [MyServiceBinding(), BasketBindings()], transition: Transition.fade),
    GetPage(name: MyContant.routeBasket, page: ()=> const BasketSummary(),bindings: [UserBinding(), BasketBindings()] , transition: Transition.rightToLeft),
    GetPage(name: MyContant.routeAddressList, page: ()=> const AddressList(), transition: Transition.rightToLeft),
    GetPage(name: MyContant.routeAddressForm, page: ()=> const AddressForm(), transition: Transition.rightToLeft),
    GetPage(name: MyContant.routeAuthen, page: ()=> const Authen()),
    GetPage(name: MyContant.routeCreateAccount, page: ()=> const CreateAccount()),
  ];

}

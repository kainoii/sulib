
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sulib/binding/auth_binding.dart';
import 'package:sulib/controller/auth_controller.dart';
import 'package:sulib/controller/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sulib/states/authen.dart';
import 'package:sulib/states/basket_summary.dart';
import 'package:sulib/states/create_account.dart';
import 'package:sulib/states/my_service.dart';
import 'package:sulib/utility/my_constant.dart';

Map<String, WidgetBuilder> map = {
  MyContant.routeAuthen: (BuildContext context) => const Authen(),
  MyContant.routeCreateAccount: (BuildContext context) => const CreateAccount(),
  MyContant.routeMyService: (context) => const MyService(),
  MyContant.routeBasket: (context) => const BasketSummary(),
};

String? firstState;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp().then((value) async {
  //   await FirebaseAuth.instance.authStateChanges().listen((event) {
  //     if (event == null) {
  //       firstState = MyContant.routeAuthen;
  //
  //     } else {
  //       firstState = MyContant.routeMyService;
  //       runApp(const MyApp());
  //     }
  //   });
  // });
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}

// final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      // navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: MainApp(),
      initialBinding: AuthenBinding(),
      getPages: RoutesClass.routes,
      title: MyContant.appName,
      // initialRoute: MyContant.routeMain,
    );
  }
}


class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Colors.redAccent,),
      ),
    );
  }
}



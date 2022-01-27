import 'package:flutter/material.dart';
import 'package:sulib/states/authen.dart';
import 'package:sulib/states/create_account.dart';
import 'package:sulib/utility/my_constant.dart';

Map<String, WidgetBuilder> map = {
  MyContant.routeAuthen:(BuildContext context)=> const Authen(),
  MyContant.routeCreateAccount:(BuildContext context)=> const CreateAccount(), 
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     routes: map,
     title: MyContant.appName,
     initialRoute: MyContant.routeAuthen,
    );
  }
}

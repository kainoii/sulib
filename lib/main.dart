import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sulib/states/authen.dart';
import 'package:sulib/states/create_account.dart';
import 'package:sulib/utility/my_constant.dart';

Map<String, WidgetBuilder> map = {
  MyContant.routeAuthen: (BuildContext context) => const Authen(),
  MyContant.routeCreateAccount: (BuildContext context) => const CreateAccount(),
};

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    runApp(const MyApp());
  });
  
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

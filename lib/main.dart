import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sulib/states/authen.dart';
import 'package:sulib/states/create_account.dart';
import 'package:sulib/states/my_service.dart';
import 'package:sulib/utility/my_constant.dart';

Map<String, WidgetBuilder> map = {
  MyContant.routeAuthen: (BuildContext context) => const Authen(),
  MyContant.routeCreateAccount: (BuildContext context) => const CreateAccount(),
  MyContant.routeMyService: (context) => const MyService(),
};

String? firstState;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) async {
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        firstState = MyContant.routeAuthen;
        runApp(const MyApp());
      } else {
        firstState = MyContant.routeMyService;
        runApp(const MyApp());
      }
    });
  });
}

class MyApp extends StatelessWidget {
  
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: map,
      title: MyContant.appName,
      initialRoute: firstState,
    );
  }
}

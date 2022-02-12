// ignore_for_file: invalid_return_type_for_catch_error

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sulib/states/my_service.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/utility/my_dialog.dart';
import 'package:sulib/widgets/show_button.dart';
import 'package:sulib/widgets/show_form.dart';
import 'package:sulib/widgets/show_logo.dart';
import 'package:sulib/widgets/show_text.dart';

class Authen extends StatefulWidget {
  const Authen({
    Key? key,
  }) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: MyContant().primaryBox(),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  newLogo(),
                  newappname(),
                  newUserName(),
                  newPassWord(),
                  newLogin(),
                  newRegister(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ShowButton newRegister(BuildContext context) => ShowButton(
        pressFunc: () =>
            Navigator.pushNamed(context, MyContant.routeCreateAccount),
        label: 'Register',
      );

  ShowButton newLogin() => ShowButton(
        label: 'Login',
        pressFunc: () async {
          if ((email?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
            MyDialog(context: context)
                .normalDialog('Have Space', 'Please Fill Every Blank');
          } else {
            await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email!, password: password!)
                .then((value) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyService(),
                    ),
                    (route) => false))
                .catchError((onError) => MyDialog(context: context)
                    .normalDialog(onError.code, onError.message));
          }
        },
      );

  ShowForm newUserName() {
    return ShowForm(
      label: 'Username :',
      changeFunc: (String value) => email = value.trim(),
    );
  }

  ShowForm newPassWord() {
    return ShowForm(
      label: 'Password :',
      changeFunc: (String value) => password = value.trim(),
    );
  }

  ShowText newappname() {
    return ShowText(
      text: MyContant.appName,
      textStyle: MyContant().h1Style(),
    );
  }

  SizedBox newLogo() {
    return const SizedBox(
      width: 300,
      child: Showlogo(),
    );
  }
}

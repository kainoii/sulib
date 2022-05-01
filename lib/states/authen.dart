// ignore_for_file: invalid_return_type_for_catch_error

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sulib/controller/auth_controller.dart';
import 'package:sulib/main.dart';
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
  bool isPasswordVisible = false;

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
            // await FirebaseAuth.instance
            //     .signInWithEmailAndPassword(email: email!, password: password!)
            //     .then((value) => Navigator.pushAndRemoveUntil(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => MyService(),
            //         ),
            //         (route) => false))
            //     .catchError((onError) => MyDialog(context: context)
            //         .normalDialog(onError.code, onError.message));

            await AuthController.instance.login(email!, password!);

            // try {
            //   await FirebaseAuth.instance
            //       .signInWithEmailAndPassword(
            //       email: email!,
            //       password: password!
            //   );
            // } on FirebaseAuthException catch (e) {
            //   print(e);
            // }

          }
        },
      );

  Widget newUserName() =>(
    Container(
      margin: const EdgeInsets.only(top: 16),
      width: 250,
      height: 40,
      child: TextFormField(
        onChanged: (String value) => email = value.trim(),
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.mail),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            fillColor: Colors.white.withOpacity(0.5),
            filled: true,
            label: const ShowText(text: "E_mail :"),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyContant.dark),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyContant.light),
              borderRadius: BorderRadius.circular(20),
            ),
            ),
            
      ),
    )
  );

  // Container newPassWord() {
  //   return Container( margin: const EdgeInsets.only(top: 16),
  //     width:  250,
  //     height: 40,
  //     child: TextFormField(),

  //     );
  // }
  // ShowForm newPassWord() {
  //   return ShowForm(
  //     label: 'Password :',
  //     changeFunc: (String value) => password = value.trim(),
  //   );
  // }
  Widget newPassWord() => (
     Container(
      margin: const EdgeInsets.only(top: 16),
      width: 250,
      height: 40,
      child: TextFormField(
        onChanged: (String value) => password = value.trim(),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
                icon: isPasswordVisible 
                ? const Icon(Icons.visibility_off,) 
                : const Icon(Icons.visibility), 
                onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            fillColor: Colors.white.withOpacity(0.5),
            filled: true,
            label: const ShowText(text: "Password :"),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyContant.dark),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyContant.light),
              borderRadius: BorderRadius.circular(20),
            ),
            ),
             obscureText: !isPasswordVisible,
      ),
    )
  );

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

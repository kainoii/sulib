import 'package:flutter/material.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/widgets/show_button.dart';
import 'package:sulib/widgets/show_form.dart';
import 'package:sulib/widgets/show_logo.dart';
import 'package:sulib/widgets/show_text.dart';

class Authen extends StatelessWidget {
  const Authen({
    Key? key,
  }) : super(key: key);

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
        pressFunc: () => Navigator.pushNamed(context, MyContant.routeCreateAccount),
        label: 'Register',
      );

  ShowButton newLogin() => ShowButton(
        label: 'Login',
        pressFunc: () {},
      );

  ShowForm newUserName() {
    return ShowForm(
      label: 'Username :', changeFunc: (String value) {  },
    );
  }

  ShowForm newPassWord() {
    return ShowForm(
      label: 'Password :', changeFunc: (String value) {  },
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

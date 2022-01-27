// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/utility/my_dialog.dart';
import 'package:sulib/widgets/show_button.dart';
import 'package:sulib/widgets/show_form.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? name, email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyContant.primary,
        title: const Text('Create Account'),
      ),
      body: Container(
        decoration: MyContant().primaryBox(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: Column(
              children: [
                ShowForm(
                  label: 'Display Name :',
                  changeFunc: (String value) => name = value.trim(),
                ),
                ShowForm(
                  label: 'Email :',
                  changeFunc: (String value) => email = value.trim(),
                ),
                ShowForm(
                  label: 'Password :',
                  changeFunc: (String value) => password = value.trim(),
                ),
                ShowButton(
                  pressFunc: () {
                    print(
                        'name = $name , email = $email, password = $password');
                    if ((name?.isEmpty ?? true) ||
                        (email?.isEmpty ?? true) ||
                        (password?.isEmpty ?? true)) {
                      print('Have Space');
                      MyDialog(context: context).normalDialog(
                          'Have space ?', 'Please Fill Every Blank');
                    } else {
                      print('no space');
                    }
                  },
                  label: 'Create New Account',
                  width: 250,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

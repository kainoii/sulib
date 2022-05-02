// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sulib/controller/auth_controller.dart';
import 'package:sulib/mdels/user_model.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/utility/my_dialog.dart';
import 'package:sulib/widgets/show_button.dart';
import 'package:sulib/widgets/show_form.dart';
import 'package:sulib/widgets/show_text.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? name, email, password, confrimpassword;

  var isPasswordVisible1 = false;
  var isPasswordVisible2 = false;

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
                newUserName(),
                // ShowForm(
                //   label: 'Display Name :',
                //   changeFunc: (String value) => name = value.trim(),
                // ),
                // ShowForm(
                //   label: 'Email :',
                //   changeFunc: (String value) => email = value.trim(),
                // ),
                // ShowForm(
                //   label: 'Password :',
                //   changeFunc: (String value) => password = value.trim(),
                // ),
                ceateEmail(),
                newPassWord(),
                confrimPassWord(),
                // ShowForm(
                //   label: 'Confrim Password :',
                //   changeFunc: (String value) => confrimpassword = value.trim(),
                // ),
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
                    }
                    print(confrimpassword);
                    if (password != confrimpassword) {
                      MyDialog(context: context).normalDialog(
                          'Passwords do not match!',
                          'Please check your password again.');
                    } else {
                      print('no space');
                      processCreateAccount();
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

  Widget newPassWord() => (Container(
        margin: const EdgeInsets.only(top: 16),
        width: 250,
        height: 40,
        child: TextFormField(
          onChanged: (String value) => password = value.trim(),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: isPasswordVisible1
                  ? const Icon(
                      Icons.visibility_off,
                    )
                  : const Icon(Icons.visibility),
              onPressed: () =>
                  setState(() => isPasswordVisible1 = !isPasswordVisible1),
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
          obscureText: !isPasswordVisible1,
        ),
      ));
  Widget confrimPassWord() => (Container(
        margin: const EdgeInsets.only(top: 16),
        width: 250,
        height: 40,
        child: TextFormField(
          onChanged: (String value) => confrimpassword = value.trim(),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: isPasswordVisible2
                  ? const Icon(
                      Icons.visibility_off,
                    )
                  : const Icon(Icons.visibility),
              onPressed: () =>
                  setState(() => isPasswordVisible2 = !isPasswordVisible2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            fillColor: Colors.white.withOpacity(0.5),
            filled: true,
            label: const ShowText(text: "Confrim Password :"),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyContant.dark),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyContant.light),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          obscureText: !isPasswordVisible2,
        ),
      ));
  Widget ceateEmail() => (Container(
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
      ));
  Widget newUserName() => (Container(
        margin: const EdgeInsets.only(top: 16),
        width: 250,
        height: 40,
        child: TextFormField(
          onChanged: (String value) => name = value.trim(),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            fillColor: Colors.white.withOpacity(0.5),
            filled: true,
            label: const ShowText(text: "User Name"),
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
      ));
  Future<void> processCreateAccount() async {
    final value = await AuthController.instance.register(email!, password!);

    String userId = value!.user!.uid;

    UserModel model =
        UserModel(name: name!, email: email!, password: password!);

    await FirebaseFirestore.instance
        .collection(Collection.user)
        .doc(userId)
        .set(model.toMap())
        // .then((value) => Navigator.pop(context))
        .catchError((onError) {
      MyDialog(context: context).normalDialog(onError.code, onError.message);
    });
    // Future<void> processCreateAcconut() async {
    //   await FirebaseAuth.instance
    //       .createUserWithEmailAndPassword(
    //     email: email!,
    //     password: password!,
    //   )
    //       .then((value) async {
    //     String uid = value.user!.uid;
    //     print('uid ==> $uid');

    //     UserModel model =
    //         UserModel(name: name!, email: email!, password: password!);

    //     await FirebaseFirestore.instance
    //         .collection('user')
    //         .doc(uid)
    //         .set(model.toMap())
    //         .then((value) => Navigator.pop(context));
    //   }).catchError((onError) {
    //     MyDialog(context: context).normalDialog(onError.code, onError.message);
    //   });
    // }
  }
}

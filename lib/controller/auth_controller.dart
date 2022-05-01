import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sulib/binding/auth_binding.dart';
import 'package:sulib/binding/user_binding.dart';
import 'package:sulib/main.dart';
import 'package:sulib/states/authen.dart';
import 'package:sulib/states/my_service.dart';
import 'package:sulib/states/splash.dart';
import 'package:sulib/utility/my_constant.dart';

class AuthController extends GetxController {

  static AuthController instance = Get.find();

  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  get user => _user;

  String getUserId() {
    return _user.value!.uid;
  }

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    //user is notify
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }



  _initialScreen(User? user) {
    if (_user.value != null) {
      print('Login uid: ${_user}');
      Get.offAll(SplashApp(), binding: AuthenBinding());
    } else {
      print('Login Page');
      Get.offAll(Authen());
    }
  }
  
  Future<UserCredential?> register(String email, password) async{
    try {
      final response = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return response;
    } catch(e) {
      Get.snackbar("About User", "User message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Account creation failed",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
              color: Colors.white
          ),
        )
      );
    }
    return null;
  }

  Future<void> login(String email, password) async{
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch(e) {
      Get.snackbar("About Login", "Login message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Login failed failed",
            style: TextStyle(
                color: Colors.white
            ),
          ),
          messageText: Text(
            e.toString(),
            style: const TextStyle(
                color: Colors.white
            ),
          )
      );
    }
  }

  Future<void> logout() async{
    await auth.signOut();
  }

}
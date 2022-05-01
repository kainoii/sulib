import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sulib/binding/my_service_binding.dart';
import 'package:sulib/controller/auth_controller.dart';
import 'package:sulib/controller/user_controller.dart';
import 'package:sulib/utility/my_constant.dart';

class SplashApp extends StatefulWidget {
  const SplashApp({Key? key}) : super(key: key);

  @override
  State<SplashApp> createState() => _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    String id = AuthController.instance.getUserId();
    await Future.value(await UserController.instance.getUserById(id)).then((value) {
      Get.toNamed(MyContant.routeMyService);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: MyContant.primary,
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/logo.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'กำลังดาวน์โหลดข้อมูล',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18
                      ),
                    ),
                    SizedBox(height: 16,),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(color: Colors.white,),
                    ),
                    SizedBox(height: 40,),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}

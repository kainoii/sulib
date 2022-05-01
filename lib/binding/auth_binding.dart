import 'package:get/get.dart';
import 'package:sulib/controller/auth_controller.dart';
import 'package:sulib/controller/basket_controller.dart';
import 'package:sulib/controller/my_service_controller.dart';
import 'package:sulib/controller/user_controller.dart';

class AuthenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(UserController());
    Get.put(BasketController());
    Get.put(MyServiceController());
  }
}
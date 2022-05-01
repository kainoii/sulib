import 'package:get/get.dart';
import 'package:sulib/controller/basket_controller.dart';
import 'package:sulib/controller/my_service_controller.dart';
import 'package:sulib/controller/user_controller.dart';

class UserBinding implements Bindings {

  @override
  void dependencies() {
    Get.put(UserController());
    // Get.put(BasketController());
    // Get.put(MyServiceController());
  }
}
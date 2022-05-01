import 'package:get/get.dart';
import 'package:sulib/controller/basket_controller.dart';
import 'package:sulib/controller/my_service_controller.dart';

class MyServiceBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(BasketController());
    Get.put(MyServiceController());
  }
}
import 'package:get/get.dart';
import 'package:sulib/controller/basket_controller.dart';

class BasketBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(BasketController());
  }
}
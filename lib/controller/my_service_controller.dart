
import 'package:get/get.dart';


class MyServiceController extends GetxController {

  static MyServiceController instance = Get.find<MyServiceController>();

  var _currentIndex = 0;

  @override
  void onInit() {
    _currentIndex = 0;
    super.onInit();
  }

  void setIndex(int index) {
    _currentIndex = index;
    update();
  }

  int get currentIndex => _currentIndex;

}
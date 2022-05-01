import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sulib/mdels/book-model.dart';

class BasketController extends GetxController {

  static BasketController instance = Get.find<BasketController>();

  var item = <BookModel>[].obs;

  var isProcessBasket = false.obs;

  @override
  void onInit() {
    super.onInit();
    item = <BookModel>[].obs;
    isProcessBasket.value = false;
  }

  void addBasket(BookModel bookModel) {
    item.add(bookModel);
  }

  void clearBasket() {
    item.clear();
  }

  void removeBasketByItem(BookModel bookModel) {
    item.remove(bookModel);
  }

  void changeIsLoading(bool value) {
    isProcessBasket.value = value;
    print('isProcessBasket:  ${isProcessBasket.value}');
  }

  List<BookModel> getItems() => item;

  bool getLoading() => isProcessBasket.value;

}
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sulib/controller/auth_controller.dart';
import 'package:sulib/controller/basket_controller.dart';
import 'package:sulib/controller/user_controller.dart';
import 'package:sulib/mdels/borrow_book_model.dart';
import 'package:sulib/mdels/user_model.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/services/user_service.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/utility/my_dialog.dart';
import 'package:sulib/widgets/dismissible_widget.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../mdels/borrow_user_model.dart';

class BasketSummary extends StatefulWidget {
  const BasketSummary({Key? key}) : super(key: key);

  @override
  State<BasketSummary> createState() => _BasketSummaryState();
}

class _BasketSummaryState extends State<BasketSummary> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('รายการยืมหนังสือ'),
          backgroundColor: MyContant.primary,
        ),
        body: Obx(
          () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: (BasketController.instance.item.isNotEmpty)
                  ? ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        buildTextAddress(),
                        buildSummaryBook(),
                        buildButtonBorrow()
                      ],
                    )
                  : buildEmptyBasket()),
        ));
  }

  Widget buildTextAddress() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ที่อยู่จัดส่ง',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: MyContant.black),
              ),
              GetBuilder<UserController>(
                  builder: (controller) => (controller.user.address!.isNotEmpty)
                      ? TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(MyContant.routeAddressList),
                          child: Text(
                            'เลือกที่อยู่ใหม่',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: MyContant.dark,
                                decoration: TextDecoration.underline),
                          ))
                      : Container())
            ],
          ),
          const Divider(),
          GetBuilder<UserController>(
              builder: (controller) => (controller.user.address!.isNotEmpty)
                  ? UserAddressWidget(
                      name: controller.selectAddress.getName(),
                      phone: controller.selectAddress.phone,
                      address: controller.selectAddress.getAddressSummary())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                            child: Text(
                          'ไม่มีที่อยู่จัดส่ง กรุณากด \"เพิ่มที่อยู่\"',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        )),
                        TextButton(
                          onPressed: () {
                            controller.isSetDefaultAddressForm =
                                (controller.user.address!.isEmpty);
                            Navigator.of(context)
                                .pushNamed(MyContant.routeAddressForm);
                          },
                          child: Text(
                            'เพิ่มที่อยู่',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: MyContant.dark),
                          ),
                        )
                      ],
                    )),
          const Divider(),
        ],
      ),
    );
  }

  Widget buildSummaryBook() {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            'สรุปรายการยืมหนังสือ',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: MyContant.black),
          ),
          const Divider(),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: BasketController.instance.item.length,
            itemBuilder: (context, index) {
              BookModel bookModel = BasketController.instance.item[index];
              return DismissibleWidget(
                item: bookModel,
                child: buildBookItemWidget(bookModel),
                onDismissed: (direction) =>
                    dismissItem(context, bookModel, direction),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildEmptyBasket() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MyContant.dark, width: 5)),
              child: Icon(
                Icons.remove_shopping_cart,
                color: MyContant.dark,
                size: 70,
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            'ไม่มีรายการหนังสือที่คุณต้องการยืม',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MyContant.dark),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  void dismissItem(
      BuildContext context, BookModel bookModel, DismissDirection direction) {
    BasketController.instance.removeBasketByItem(bookModel);
  }

  Widget buildBookItemWidget(BookModel bookModel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        child: CachedNetworkImage(
          imageUrl: bookModel.cover,
          width: 40,
          height: 120,
          fit: BoxFit.contain,
        ),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: const Offset(0, 3),
              blurRadius: 5,
              spreadRadius: 1,
              color: Colors.grey.withOpacity(0.5))
        ]),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          bookModel.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Text(
        'ISBN: ${bookModel.isbnNumber}',
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget buildButtonBorrow() {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Obx(
          () {
            return (BasketController.instance.isProcessBasket.value)
              ? CircularProgressIndicator()
              : ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: MyContant.dark,
                  onPrimary: Colors.white,
                  elevation: 2,
                  shadowColor: Colors.grey.shade600,
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                //Todo Check verify
                showDialogConfirm();
              },
              child: const Text(
                'ยืมหนังสือ',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            );
          }
        ),
        const SizedBox(
          height: 32,
        )
      ],
    );
  }

  Future<List<String>> findAllDocumentBook(List<BookModel> books) async {
    List<String> documentBookList = [];
    for (var item in books) {
      final response = await FirebaseFirestore.instance
          .collection(Collection.book)
          .where("ISBN number", isEqualTo: item.isbnNumber)
          .get();
      if (response.docs.isNotEmpty) {
        documentBookList.add(response.docs.first.id);
      }
    }
    return documentBookList;
  }

  Future<List<BorrowBookModel>> verifyBookBorrowed(
      List<String> allBookId) async {
    List<BorrowBookModel> borrowBookModels = [];

    for (var docBook in allBookId) {
      final response = await FirebaseFirestore.instance
          .collection(Collection.book)
          .doc(docBook)
          .collection(Collection.borrow)
          .where("status", isEqualTo: true)
          .get();
      if (response.docs.isNotEmpty) {
        BorrowBookModel borrowBookModel =
            BorrowBookModel.fromMap(response.docs.first.data());
        borrowBookModels.add(borrowBookModel);
      }
    }
    return borrowBookModels;
  }

  Future showDialogConfirm() async {
    List<BookModel> books = BasketController.instance.item;
    List<String> allBookId =
        await DatabaseService().getDocumentBookByList(books);
    List<BookModel> allBookIsBorrowed = [];
    for (int i=0; i < books.length; i++) {
      final borrowBookModels = await DatabaseService().getBookIsBorrowedByBookId(allBookId[i]);
      if (borrowBookModels.isNotEmpty) {
        allBookIsBorrowed.add(books[i]);
      }
    }
    // List<int> borrowBookModels =
    //     await DatabaseService().verifyBookBorrowedByDocumentList(allBookId);

    if (allBookIsBorrowed.isEmpty) {
      DateTime currentDateTime = DateTime.now();
      DateTime endDateTime = currentDateTime.add(const Duration(days: 7));

      MyDialog(context: context).confirmBorrowDialog(
          startDate: showDate(currentDateTime),
          endDate: showDate(endDateTime),
          bookModels: BasketController.instance.item,
          okFunc: () async {
            Navigator.of(context).pop();
            processBorrowBook(allBookId, books).then((value) {
              Get.back();
            });
          });
    } else {
      // List<BookModel> allBookIsBorrowed = [];
      // for (var index in borrowBookModels) {
      //   allBookIsBorrowed.add(books[index]);
      // }
      MyDialog(context: context)
          .errorBorrowDialog(bookModels: allBookIsBorrowed);
    }
  }

  Future<void> processBorrowBook(List<String> documentBooks, List<BookModel> bookModels) async {
    BasketController.instance.changeIsLoading(true);
    DateTime currentDateTime = DateTime.now();
    DateTime endDateTime = currentDateTime.add(const Duration(days: 7));

    String userId = AuthController.instance.getUserId();
    String uniqueId = const Uuid().v1();

    for (var docBook in documentBooks) {
      BorrowBookModel borrowBookModel = BorrowBookModel(
          docUser: userId,
          startDate: Timestamp.fromDate(currentDateTime),
          endDate: Timestamp.fromDate(endDateTime),
          status: true);
      await DatabaseService().borrowBookByBook(docBook, borrowBookModel);
      print('borrowBookModel Book Success ===>> ${borrowBookModel.toMap()}');

      BorrowUserModel borrowUserModel = BorrowUserModel(
        startDate: Timestamp.fromDate(currentDateTime),
        endDate: Timestamp.fromDate(endDateTime),
        status: true,
        docBook: docBook,
        borrowId: uniqueId,
        review: null,
      );
      await DatabaseService().borrowBookByUser(userId, borrowUserModel);
      print('borrowUserModel User Success ===>> ${borrowUserModel.toMap()}');
    }

    await sendEmail(bookModels).then((value) {
      BasketController.instance.clearBasket();
      BasketController.instance.changeIsLoading(false);
    });
  }

  Future sendEmail(List<BookModel> books) async {
    final serviceId = 'service_697yyoo';
    final templateId = 'template_lq94msz';
    final userId = '1nvoZ0x2hkYsJR-06';

    UserModel user = UserController.instance.user;

    DateTime currentDateTime = DateTime.now();
    DateTime endDateTime = currentDateTime.add(const Duration(days: 7));

    final String user_name = user.name;
    final String user_email = user.email;
    final String user_address =
        "${UserController.instance.selectAddress.getName()}\n${UserController.instance.selectAddress.phone}\n${UserController.instance.selectAddress.getAddressSummary()}";
    String end_borrow_date = showDate(endDateTime);
    String start_borrow_date = showDate(currentDateTime);
    String book_title = "";

    for (int i=0; i < books.length; i++) {
      if (i != (books.length - 1)) {
        book_title = book_title + "(ISBN : ${books[i].isbnNumber}) => หนังสือเรื่อง : ${books[i].title} / ";
      } else {
        book_title = book_title + "(ISBN : ${books[i].isbnNumber}) => หนังสือเรื่อง : ${books[i].title} ";
      }
    }

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_name': user_name,
            'user_email': user_email,
            'book_title': book_title,
            'start_borrow_date' : start_borrow_date,
            'end_borrow_date': end_borrow_date,
            'user_address': user_address
          }
        }));
    print(response.body);
  }

  String showDate(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy');
    String result = dateFormat.format(dateTime);
    return result;
  }
}

class UserAddressWidget extends StatelessWidget {
  final String name;
  final String phone;
  final String? building;
  final String address;

  const UserAddressWidget(
      {Key? key,
      required this.name,
      required this.phone,
      this.building,
      required this.address})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          Text(
            'โทร ${phone}',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          (building != null)
              ? Text(
                  '${building}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                )
              : Container(),
          Text(
            address,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

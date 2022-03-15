// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/mdels/borrow_book_model.dart';
import 'package:sulib/mdels/borrow_user_model.dart';
import 'package:sulib/mdels/reserve_model.dart';
import 'package:sulib/states/show_list_recive_book.dart';
import 'package:sulib/states/show_progress.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/utility/my_dialog.dart';
import 'package:sulib/widgets/show_button.dart';
import 'package:sulib/widgets/show_text.dart';


class BorrowBook extends StatefulWidget {
  final BookModel bookModel;
  final String docBook;
  const BorrowBook({
    Key? key,
    required this.bookModel,
    required this.docBook,
  }) : super(key: key);

  @override
  _BorrowBookState createState() => _BorrowBookState();
}

class _BorrowBookState extends State<BorrowBook> {
  BookModel? bookModel;
  DateTime currentDateTime = DateTime.now();
  DateTime? endDateTime;
  String? docUser, docBook;

  @override
  void initState() {
   
    super.initState();
    bookModel = widget.bookModel;
    docBook = widget.docBook;
    endDateTime = currentDateTime.add(const Duration(days: 7));
    findUserLogin();
  }

  Future<void> findUserLogin() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      docUser = event!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyContant.primary,
        title: const Text('ยืม จอง หนังสือ'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              newCover(),
              ShowText(
                text: bookModel!.title,
                textStyle: MyContant().h2Style(),
              ),
              const SizedBox(
                height: 16,
              ),
              newDetail(title: 'ผู้เขียน :', detail: bookModel!.author),
              newDetail(title: 'Publisher :', detail: bookModel!.publisher),
              newDetail(title: 'Category :', detail: bookModel!.bookCatetory),
              newDetail(title: 'Code :', detail: bookModel!.bookCode),
              newDetail(title: 'จำนวนหน้า :', detail: bookModel!.numberOfPage),
              newDetail(title: 'Detail :', detail: bookModel!.detail),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ShowButton(
                    label: 'ยืม',
                    pressFunc: () {
                      processCheck();
                    },
                  ),
                  ShowButton(
                    label: 'จอง',
                    pressFunc: () {
                      checkReserve();
                    },
                    primaryColor: Colors.red.shade200,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String showDate(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy');
    String resutl = dateFormat.format(dateTime);
    return resutl;
  }

  Widget newDetail({required String title, required String detail}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShowText(text: title),
          SizedBox(
            width: 300,
            child: ShowText(text: detail),
          ),
        ],
      ),
    );
  }

  Widget newCover() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32),
      width: 120,
      height: 150,
      child: CachedNetworkImage(
        imageUrl: bookModel!.cover,
        placeholder: (context, string) => const ShowProgress(),
      ),
    );
  }

  Future<void> processCheck() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(docUser)
        .collection('borrow')
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        MyDialog(context: context).confirmAction(
            title: bookModel!.title,
            message:
                'เริ่ม ${showDate(currentDateTime)} \n คืน ${showDate(endDateTime!)}',
            urlBook: bookModel!.cover,
            okFunc: () {
              Navigator.pop(context);
              processBorrowBook();
            });
      } else {
        bool status = false;
        for (var item in value.docs) {
          BorrowUserModel borrowUserModel =
              BorrowUserModel.fromMap(item.data());
          if (borrowUserModel.status) {
            status = true;
          }
        }

        if (status) {
          MyDialog(context: context)
              .normalDialog('ไม่สามามารถยืมได้', 'มี หนังสือค้างส่งอยู่');
        } else {
          await FirebaseFirestore.instance
              .collection('book')
              .doc(docBook)
              .collection('borrow')
              .get()
              .then((value) {
            bool statusBook = true; // true ==> หนังสือว่าง ยืมได้

            for (var item in value.docs) {
              BorrowBookModel borrowBookModel =
                  BorrowBookModel.fromMap(item.data());
              if (borrowBookModel.status) {
                statusBook = false;
              }
            }

            if (statusBook) {
              MyDialog(context: context).confirmAction(
                  title: bookModel!.title,
                  message:
                      'เริ่ม ${showDate(currentDateTime)} \n คืน ${showDate(endDateTime!)}',
                  urlBook: bookModel!.cover,
                  okFunc: () {
                    Navigator.pop(context);
                    processBorrowBook();
                  });
            } else {
              MyDialog(context: context).normalDialog(
                  'หนังสือไม่ว่าง', 'กรุณาจองไว้ หรือ ไปเลือกเล่มอืนแทน');
            }
          });
        }
      }
    });
  }

  Future<void> processBorrowBook() async {
    BorrowUserModel borrowUserModel = BorrowUserModel(
        docBook: docBook!,
        startDate: Timestamp.fromDate(currentDateTime),
        endDate: Timestamp.fromDate(endDateTime!),
        status: true);

    print('borrowUserModel ===>> ${borrowUserModel.toMap()}');

    BorrowBookModel borrowBookModel = BorrowBookModel(
        docUser: docUser!,
        startDate: Timestamp.fromDate(currentDateTime),
        endDate: Timestamp.fromDate(endDateTime!),
        status: true);

    print('borrowBookModel ===>> ${borrowBookModel.toMap()}');

    await FirebaseFirestore.instance
        .collection('user')
        .doc(docUser)
        .collection('borrow')
        .doc()
        .set(borrowUserModel.toMap())
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('book')
          .doc(docBook)
          .collection('borrow')
          .doc()
          .set(borrowBookModel.toMap())
          .then((value) {
       
        Navigator.pop(context);
      });
    });
  }

  Future<void> checkReserve() async {
    await FirebaseFirestore.instance
        .collection('book')
        .doc(docBook)
        .collection('borrow')
        .where('status', isEqualTo: true)
        .get()
        .then((value) {
      print('value ==>> ${value.docs}');
      if (value.docs.isEmpty) {
        MyDialog(context: context)
            .normalDialog('หนังสือว่าง ?', 'สามารถยืมได้เลยไม่ต้อง จอง คะ');
      } else {
        for (var item in value.docs) {
          BorrowBookModel borrowBookModel =
              BorrowBookModel.fromMap(item.data());
          MyDialog(context: context).confirmAction(
              contentStr:
                  'ได้หลังจากวันที่ ${showDate(borrowBookModel.endDate.toDate())}',
              title: 'Confirm Reserve Book',
              message: 'คุณต้องการจอง ${bookModel!.title} ',
              urlBook: bookModel!.cover,
              okFunc: () async {
                Navigator.pop(context);

                ReserveModel reserveModel = ReserveModel(
                    cover: bookModel!.cover,
                    docBook: docBook!,
                    endDate: borrowBookModel.endDate,
                    nameBook: bookModel!.title,
                    status: true);

                await FirebaseFirestore.instance
                    .collection('user')
                    .doc(docUser)
                    .collection('reserve')
                    .doc()
                    .set(reserveModel.toMap())
                    .then((value) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShowListReceiveBook(),
                      ));
                });
              });
        }
      }
    });
  }
}
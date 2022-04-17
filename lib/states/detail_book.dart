// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/mdels/borrow_book_model.dart';
import 'package:sulib/mdels/borrow_user_model.dart';
import 'package:sulib/mdels/reserve_model.dart';
import 'package:sulib/mdels/review-model.dart';
import 'package:sulib/mdels/user_model.dart';
import 'package:sulib/states/borrow_book.dart';
import 'package:sulib/states/review.dart';
import 'package:sulib/states/show_list_recive_book.dart';
import 'package:sulib/states/show_progress.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/utility/my_dialog.dart';
import 'package:sulib/widgets/show_button.dart';
import 'package:sulib/widgets/show_text.dart';


class DetailBook extends StatefulWidget {
  final BookModel bookModel;
  final String docBook;
  const DetailBook({
    Key? key,
    required this.bookModel,
    required this.docBook,
  }) : super(key: key);

  @override
  _DetailBookState createState() => _DetailBookState();
}

class _DetailBookState extends State<DetailBook> {

  final bookForReviewList = <BorrowBookModel>[];
  final userReviewList = <UserModel>[];


  Future<List<BorrowBookModel>> getReviewFromThisBook () async {
    List<BorrowBookModel> books = [];
    bookForReviewList.clear();
    final value = await FirebaseFirestore.instance
        .collection('book')
        .doc(docBook)
        .collection('borrow')
        .where('review', isNull: false)
        .get();
    if (value.docs.isNotEmpty) {
      for(var item in value.docs) {
        BorrowBookModel booksReviewByUser = BorrowBookModel.fromMap(item.data());
        if (booksReviewByUser.review!.rate != 0 || booksReviewByUser.review!.description! != "") {
          print('book review : ${ booksReviewByUser.review!.rate } and description = ${ booksReviewByUser.review!.description! }');
          bookForReviewList.add(booksReviewByUser);
          books.add(booksReviewByUser);
        }
        print("userId ====> ${ booksReviewByUser.docUser }");
      }
    }
    bookForReviewList.forEach((element) {
      print("UserIdReview =====> ${ element.docUser }");
    });
    return books;
  }

  Future<List<UserModel>> getUserData(List<BorrowBookModel> docUserId) async {
    userReviewList.clear();
    for (var item in docUserId) {
      String userId = item.docUser;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .get()
          .then((value) {
        UserModel user = UserModel.fromMap(value.data()!);
        userReviewList.add(user);
      });

    }
    return userReviewList;
  }

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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                newCover(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ShowText(
                    text: bookModel!.title,
                    textStyle: MyContant().h2Style(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                newDetail(title: 'ผู้เขียน :', detail: bookModel!.author),
                newDetail(title: 'สำนักพิม :', detail: bookModel!.publisher),
                newDetail(title: 'หมวดหมู่ :', detail: bookModel!.bookCatetory),
                newDetail(title: 'Code :', detail: bookModel!.bookCode),
                newDetail(title: 'จำนวนหน้า :', detail: bookModel!.numberOfPage),
                newDetail(title: 'Detail :', detail: bookModel!.detail),
                buildReviewWidget()

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 32),
            child: Row(
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
          ),
        ],
      ),
    );
  }

  Widget buildReviewWidget() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'คะแนนและรีวิว',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MyContant.black,
              ),
            ),
            const SizedBox(width: 16,),
            FutureBuilder(
                future: getReviewFromThisBook(),
                builder: (BuildContext context,AsyncSnapshot<List<BorrowBookModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return Text(
                        '( กำลังดาวน์โหลด.... )',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        )
                    );
                  }

                  return Text(
                      '(ทั้งหมด ${ snapshot.data!.length } รายการ)',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      )
                  );
                }
            )
          ],
        ),
        const SizedBox(height: 8,),
        FutureBuilder(
          future: getReviewFromThisBook(),
          builder: (BuildContext context,AsyncSnapshot<List<BorrowBookModel>> snapshotReViewByUser) {
            if (!snapshotReViewByUser.hasData) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(color: Colors.teal,),
              );
            }
            List<BorrowBookModel> reviewByUsers = snapshotReViewByUser.data!;
            return FutureBuilder(
              future: getUserData(reviewByUsers),
              builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshotUser) {
                if (!snapshotUser.hasData) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CircularProgressIndicator(color: Colors.teal,),
                  );
                }
                List<UserModel> userList = snapshotUser.data!;
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  primary: false,
                  itemCount: reviewByUsers.length,
                  itemBuilder: (context, index) {

                    BorrowBookModel reviewByUser = reviewByUsers[index];
                    UserModel user = userList[index];

                    return buildReviewItems(reviewByUser, user);
                  },
                );
              },
            );
          },
        )

      ],
    ),
  );

  Widget buildReviewItems(BorrowBookModel reviewByUser, UserModel user) {
    DateTime reviewDate = reviewByUser.review!.date!.toDate();
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            user.name,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: MyContant.black
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8,),
            child: Row(
              children: [
                RatingBarIndicator(
                  rating: reviewByUser.review!.rate!,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 20,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 16,),
                Text(
                  '${ reviewDate.day }/${ reviewDate.month }/${ reviewDate.year }',
                  style: TextStyle(
                      fontSize: 17,
                      color: MyContant.black,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16,),
          Text(
            reviewByUser.review!.description!,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: MyContant.black
            ),
          )
        ],
      ),
    );
  }

  String showDate(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy');
    String result = dateFormat.format(dateTime);
    return result;
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

  Future<bool> isBookBorrowed() async {
    final response = await FirebaseFirestore.instance
        .collection('book')
        .doc(docBook)
        .collection("borrow")
        .orderBy("startDate", descending: true)
        .get();
    if (response.docs.isNotEmpty) {
      var item = response.docs.first;
      BorrowBookModel borrowBookModel = BorrowBookModel.fromMap(item.data());
      return borrowBookModel.status;
    }
    return false;
  }

  Future<void> processCheck() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(docUser)
        .collection("borrow")
        .orderBy("startDate", descending: true)
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        bool isBookBorrow = await isBookBorrowed();
        if (!isBookBorrow) {
          final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => BorrowBook(bookModel: bookModel!, docUser: docUser!, docBook: docBook!))
          );
          if (result != null) {
            Navigator.of(context).pop();
          }
        } else {
          MyDialog(context: context).normalDialog(
              'หนังสือไม่ว่าง', 'ท่านสามารถจองไว้ก่อนได้เลย');
        }

      } else {
        // bool status = false;

        var userItem = value.docs.first;
        BorrowUserModel borrowUserModel = BorrowUserModel.fromMap(userItem.data());
        bool isUserBorrow = borrowUserModel.status;
        // for (var item in value.docs) {
        //   BorrowUserModel borrowUserModel =
        //   BorrowUserModel.fromMap(item.data());
        //   if (borrowUserModel.status) {
        //     status = true;
        //   }
        // }

        if (isUserBorrow) {
          MyDialog(context: context)
              .normalDialog('ไม่สามามารถยืมได้', 'กรุณาคืนหนังสือที่ยืมอยู่ก่อน');
        } else {

          bool isBookBorrow = await isBookBorrowed();

          if (!isBookBorrow) {
            final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BorrowBook(bookModel: bookModel!, docUser: docUser!, docBook: docBook!))
            );
            if (result != null) {
              Navigator.of(context).pop();
            }
          } else {
            MyDialog(context: context).normalDialog(
                'หนังสือไม่ว่าง', 'ท่านสามารถจองไว้ก่อนได้เลย');
          }

          // final values = await FirebaseFirestore.instance
          //     .collection('book')
          //     .doc(docBook)
          //     .collection("borrow")
          //     .orderBy("startDate", descending: true)
          //     .get();

          // if (values != null) {
          //   bool statusBook = true; // true ==> หนังสือว่าง ยืมได้
          //   for (var item in value.docs) {
          //     BorrowBookModel borrowBookModel =
          //     BorrowBookModel.fromMap(item.data());
          //     if (borrowBookModel.status) {
          //       statusBook = false;
          //     }
          //   }
          //
          //   if (statusBook) {
          //     final result = await Navigator.of(context).push(
          //         MaterialPageRoute(builder: (context) => BorrowBook(bookModel: bookModel!, docUser: docUser!, docBook: docBook!))
          //     );
          //     if (result != null) {
          //       Navigator.of(context).pop();
          //     }
          //   } else {
          //     MyDialog(context: context).normalDialog(
          //         'หนังสือไม่ว่าง', 'ท่านสามารถจองไว้ก่อนได้เลย');
          //   }
          // }
        }
      }
    });
  }

  Future<void> processBorrowBook() async {
    BorrowUserModel borrowUserModel = BorrowUserModel(
      docBook: docBook!,
      startDate: Timestamp.fromDate(currentDateTime),
      endDate: Timestamp.fromDate(endDateTime!),
      status: true,
    );

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
            .normalDialog('หนังสือว่าง ?', 'สามารถยืมได้เลย!!!');
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
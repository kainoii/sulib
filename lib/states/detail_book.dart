
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sulib/controller/auth_controller.dart';
import 'package:sulib/controller/basket_controller.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/mdels/borrow_book_model.dart';
import 'package:sulib/mdels/borrow_user_model.dart';
import 'package:sulib/mdels/reserve_model.dart';

import 'package:sulib/mdels/user_model.dart';
import 'package:sulib/services/user_service.dart';
import 'package:sulib/states/show_list_recive_book.dart';
import 'package:sulib/states/show_progress.dart';
import 'package:sulib/states/show_title.dart';
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
  _DetailBookState createState() => _DetailBookState(bookModel: bookModel, docBook: docBook);
}

class _DetailBookState extends State<DetailBook> {

  final bookForReviewList = <BorrowBookModel>[];
  final userReviewList = <UserModel>[];



  // BookModel? bookModel;
  DateTime currentDateTime = DateTime.now();
  DateTime? endDateTime;
  // String? docUser, docBook;
  final BookModel bookModel;
  final String docBook;
  late String docUser;

  _DetailBookState({required this.bookModel, required this.docBook});

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

  @override
  void initState() {

    super.initState();
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
                    text: bookModel.title,
                    textStyle: MyContant().h2Style(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                newDetail(title: 'ผู้เขียน :', detail: bookModel.author),
                newDetail(title: 'สำนักพิม :', detail: bookModel.publisher),
                newDetail(title: 'หมวดหมู่ :', detail: bookModel.bookCatetory),
                newDetail(title: 'Code :', detail: bookModel.bookCode),
                newDetail(title: 'จำนวนหน้า :', detail: bookModel.numberOfPage),
                newDetail(title: 'Detail :', detail: bookModel.detail),
                buildReviewWidget(),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 32, left: 16, right: 16),
            child: Obx(
                () {
                return (BasketController.instance.isProcessBasket.value)
                  ? SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(color: MyContant.primary,),
                  )
                  : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    (BasketController.instance.item.contains(bookModel))
                        ? Container(
                        alignment: Alignment.center,
                        child: const ShowTitle(title: 'หนังสืออยู่ในตะกร้า',)
                    )
                        : ShowButton(
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
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReviewWidget() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    child: FutureBuilder(
        future: getReviewFromThisBook(),
        builder: (BuildContext context,AsyncSnapshot<List<BorrowBookModel>> snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text(
                'ไม่มีข้อมูลการรีวิว',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500]
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error is Occurred: ${snapshot.hasError}'),
              );
            }
            else {
              List<BorrowBookModel> reviewBookBorrowByUsers = snapshot.data!;
              if (reviewBookBorrowByUsers.isEmpty) {
                return Center(
                  child: Text(
                    'ไม่มีข้อมูลการรีวิว',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500]
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'คะแนนและรีวิว',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: MyContant.black,
                      ),
                      children: [
                        TextSpan(
                            text: '\t\t(ทั้งหมด ${ reviewBookBorrowByUsers.length } รายการ)',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            )
                        )
                      ]
                    ),
                  ),
                  buildMeanReviewWidget(reviewBookBorrowByUsers),
                  const SizedBox(height: 8,),
                  FutureBuilder(
                    future: getUserData(reviewBookBorrowByUsers),
                    builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshotUser) {
                      if (!snapshotUser.hasData) {
                        return const Center(child: CircularProgressIndicator(color: Colors.teal,),);
                      }
                      List<UserModel> userList = snapshotUser.data!;
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        itemCount: reviewBookBorrowByUsers.length,
                        itemBuilder: (context, index) {

                          BorrowBookModel reviewByUser = reviewBookBorrowByUsers[index];
                          UserModel user = userList[index];

                          return buildReviewItems(reviewByUser, user);
                        },
                      );
                    },
                  ),
                ],
              );
            }
          }
        }
    ),
  );

  Widget buildMeanReviewWidget(List<BorrowBookModel> borrowBookModels)  {
    var average = (borrowBookModels.map((e) => e.review!.rate).reduce((a, b) => a! + b!)!/ borrowBookModels.length);
    List<int> countRating = [0, 0, 0, 0, 0];
    for(var borrowBook in borrowBookModels) {
      int ratingBook = borrowBook.review!.rate!.round();
      countRating[ratingBook-1]++;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          const SizedBox(height: 16,),
          Container(
            height: 150,
            width: 150,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: MyContant.primary, width: 3)
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "คะแนนทั้งหมด",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                        ),
                      ),
                      Text(
                        average.toStringAsFixed(1),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 70
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: MyContant.primary, width: 3)
                        ),
                        child: RatingBarIndicator(
                          rating: average,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemSize: 16,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16,),
          Container(
            height: 130,
            child: ListView.builder(
              itemCount: countRating.length,
              shrinkWrap: true,
              primary: false,
              reverse: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return LinearRatingSummary(text: (index + 1).toString(), valueOnPercent: countRating[index]/borrowBookModels.length);
              },
            ),
          )
        ],
      ),
    );
  }

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
        imageUrl: bookModel.cover,
        placeholder: (context, string) => const ShowProgress(),
      ),
    );
  }

  Future<void> processCheck() async {
    BasketController.instance.changeIsLoading(true);
    List<BorrowBookModel> bookBorrowed = await DatabaseService().getBookIsBorrowedByBookId(docBook);
    bool isBookBorrowed = bookBorrowed.isEmpty; //This empty that can borrow
    String userId = AuthController.instance.getUserId();
    if (isBookBorrowed) {
      List<BorrowUserModel> borrowByUser = await DatabaseService().getAllBookBorrowByUser(userId);
      bool isFirstBorrowByUser = borrowByUser.isEmpty;
      if (isFirstBorrowByUser) {
        BasketController.instance.changeIsLoading(false);
        BasketController.instance.addBasket(bookModel);
        print('add Book to Basket! ${bookModel.title} \n ISBN: ${bookModel.isbnNumber}');
      } else {
        BasketController.instance.changeIsLoading(false);
        bool isUserBorrow = borrowByUser.first.status;
        if (isUserBorrow) {
          MyDialog(context: context)
              .normalDialog('ไม่สามามารถยืมได้', 'กรุณาคืนหนังสือที่ยืมอยู่ก่อน');
        } else {
          BasketController.instance.addBasket(bookModel);
          print('add Book to Basket! ${bookModel.title} \n ISBN: ${bookModel.isbnNumber}');
        }
      }
    } else {
      BasketController.instance.changeIsLoading(false);
      MyDialog(context: context).normalDialog(
          'หนังสือไม่ว่าง', 'ท่านสามารถจองไว้ก่อนได้เลย');
    }
    //
    // await FirebaseFirestore.instance
    //     .collection('user')
    //     .doc(docUser)
    //     .collection("borrow")
    //     .orderBy("startDate", descending: true)
    //     .get()
    //     .then((value) async {
    //   if (value.docs.isEmpty) {
    //     bool isBookBorrow = await isBookBorrowed();
    //     if (!isBookBorrow) {
    //       context.read<BasketProvider>().addItem(bookModel!);
    //       print('add Book ! ${bookModel!.title} \n ISBN: ${bookModel!.isbnNumber}');
    //       // final result = await Navigator.of(context).push(
    //       //     MaterialPageRoute(builder: (context) => BorrowBook(bookModel: bookModel!, docUser: docUser!, docBook: docBook!))
    //       // );
    //       // if (result != null) {
    //       //   Navigator.of(context).pop();
    //       // }
    //     } else {
    //       MyDialog(context: context).normalDialog(
    //           'หนังสือไม่ว่าง', 'ท่านสามารถจองไว้ก่อนได้เลย');
    //     }
    //
    //   } else {
    //     // bool status = false;
    //
    //     var userItem = value.docs.first;
    //     BorrowUserModel borrowUserModel = BorrowUserModel.fromMap(userItem.data());
    //     bool isUserBorrow = borrowUserModel.status;
    //     // for (var item in value.docs) {
    //     //   BorrowUserModel borrowUserModel =
    //     //   BorrowUserModel.fromMap(item.data());
    //     //   if (borrowUserModel.status) {
    //     //     status = true;
    //     //   }
    //     // }
    //
    //     if (isUserBorrow) {
    //       MyDialog(context: context)
    //           .normalDialog('ไม่สามามารถยืมได้', 'กรุณาคืนหนังสือที่ยืมอยู่ก่อน');
    //     } else {
    //
    //       bool isBookBorrow = await isBookBorrowed();
    //
    //       if (!isBookBorrow) {
    //         context.read<BasketProvider>().addItem(bookModel!);
    //         print('add Book ! ${bookModel!.title} \n ISBN: ${bookModel!.isbnNumber}');
    //         // final result = await Navigator.of(context).push(
    //         //     MaterialPageRoute(builder: (context) => BorrowBook(bookModel: bookModel!, docUser: docUser!, docBook: docBook!))
    //         // );
    //         // if (result != null) {
    //         //   Navigator.of(context).pop();
    //         // }
    //       } else {
    //         MyDialog(context: context).normalDialog(
    //             'หนังสือไม่ว่าง', 'ท่านสามารถจองไว้ก่อนได้เลย');
    //       }
    //
    //       // final values = await FirebaseFirestore.instance
    //       //     .collection('book')
    //       //     .doc(docBook)
    //       //     .collection("borrow")
    //       //     .orderBy("startDate", descending: true)
    //       //     .get();
    //
    //       // if (values != null) {
    //       //   bool statusBook = true; // true ==> หนังสือว่าง ยืมได้
    //       //   for (var item in value.docs) {
    //       //     BorrowBookModel borrowBookModel =
    //       //     BorrowBookModel.fromMap(item.data());
    //       //     if (borrowBookModel.status) {
    //       //       statusBook = false;
    //       //     }
    //       //   }
    //       //
    //       //   if (statusBook) {
    //       //     final result = await Navigator.of(context).push(
    //       //         MaterialPageRoute(builder: (context) => BorrowBook(bookModel: bookModel!, docUser: docUser!, docBook: docBook!))
    //       //     );
    //       //     if (result != null) {
    //       //       Navigator.of(context).pop();
    //       //     }
    //       //   } else {
    //       //     MyDialog(context: context).normalDialog(
    //       //         'หนังสือไม่ว่าง', 'ท่านสามารถจองไว้ก่อนได้เลย');
    //       //   }
    //       // }
    //     }
    //   }
    // });
  }

  Future<void> checkReserve() async {

    List<BorrowBookModel> bookBorrowed = await DatabaseService().getBookIsBorrowedByBookId(docBook);
    bool isBookBorrowed = bookBorrowed.isEmpty;
    if (isBookBorrowed) {
      MyDialog(context: context)
          .normalDialog('หนังสือว่าง ?', 'สามารถยืมได้เลย!!!');
    } else {
      BorrowBookModel borrowBookModel = bookBorrowed.first;
      MyDialog(context: context).confirmAction(
          contentStr:
          'ได้หลังจากวันที่ ${showDate(borrowBookModel.endDate.toDate())}',
          title: 'Confirm Reserve Book',
          message: 'คุณต้องการจอง ${bookModel.title} ',
          urlBook: bookModel.cover,
          okFunc: () async {
            Navigator.pop(context);

            ReserveModel reserveModel = ReserveModel(
                cover: bookModel.cover,
                docBook: docBook,
                endDate: borrowBookModel.endDate,
                nameBook: bookModel.title,
                status: true);
            String userId = AuthController.instance.getUserId();
            await DatabaseService().reserveBook(userId, reserveModel.toMap()).then((value) {
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
}

class LinearRatingSummary extends StatelessWidget {

  final String text;
  final double valueOnPercent;

  const LinearRatingSummary({Key? key, required this.text, required this.valueOnPercent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: LinearPercentIndicator(
        leading: Text(
          text,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500
          ),
        ),
        barRadius: const Radius.circular(100),
        animation: true,
        animationDuration: 1500,
        lineHeight: 18,
        percent: valueOnPercent,
        progressColor: Colors.green,
        backgroundColor: Colors.green.shade100.withOpacity(0.5),
      ),
    );
  }
}

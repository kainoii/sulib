import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/mdels/borrow_book_model.dart';
import 'package:sulib/mdels/borrow_user_model.dart';
import 'package:sulib/states/show_list_recive_book.dart';
import 'package:sulib/states/show_progress.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/widgets/show_button.dart';
import 'package:sulib/widgets/show_text.dart';


class History extends StatefulWidget {
  const History({
    Key? key,
  }) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String? docUser;
  bool load = true;
  bool? haveData;

  var borrowUserModels = <BorrowUserModel>[];
  var bookModels = <BookModel>[];
  var docBorrowUsers = <String>[];

  String? docIdBookWhereTrue;

  @override
  void initState() {
    super.initState();
    findUserAndReadBook();
  }

  Future<void> findUserAndReadBook() async {
    borrowUserModels.clear();
    bookModels.clear();
    docBorrowUsers.clear();

    FirebaseAuth.instance.authStateChanges().listen((event) async {
      docUser = event!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(docUser)
          .collection('borrow')
          .orderBy('startDate', descending: true)
          .get()
          .then((value) async {
        if (value.docs.isEmpty) {
          haveData = false;
        } else {
          haveData = true;

          for (var item in value.docs) {
            String docBorrow = item.id;
            docBorrowUsers.add(docBorrow);

            BorrowUserModel borrowUserModel =
                BorrowUserModel.fromMap(item.data());
            borrowUserModels.add(borrowUserModel);

            await FirebaseFirestore.instance
                .collection('book')
                .doc(borrowUserModel.docBook)
                .get()
                .then((value) {
              BookModel bookModel = BookModel.fromMap(value.data()!);
              bookModels.add(bookModel);
            });

  
          }
        }

        setState(() {
          load = false;
        });
      });

      // otheo thread
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? const Center(child: ShowProgress())
          : haveData!
              ? LayoutBuilder(builder: (context, constrained) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ShowButton(
                            width: constrained.maxWidth,
                            label: 'รายการจองหนังสือ',
                            pressFunc: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ShowListReceiveBook(),
                                ))),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: borrowUserModels.length,
                          itemBuilder: (context, index) => Card(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 112,
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CachedNetworkImage(
                                        imageUrl: bookModels[index].cover),
                                  ),
                                ),
                                SizedBox(
                                  width: constrained.maxWidth - 120,
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ShowText(
                                          text: bookModels[index].title,
                                          textStyle: MyContant().h2Style(),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ShowText(
                                              text: showBorrow(
                                                  borrowUserModels[index]
                                                      .status),
                                            ),
                                            borrowUserModels[index].status
                                                ? ShowButton(
                                                    label: 'คืนหนังสือ',
                                                    pressFunc: () async {
                                                      Map<String, dynamic>
                                                          data1 = {};
                                                      data1['status'] = false;

                                                      print(
                                                          '#### docIdBorrowUser ${docBorrowUsers[index]}');

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('book')
                                                          .doc(borrowUserModels[
                                                                  index]
                                                              .docBook)
                                                          .collection('borrow')
                                                          .get()
                                                          .then((value) {
                                                        print(
                                                            '#### docIdBook ${borrowUserModels[index].docBook}');

                                                        print(
                                                            value.docs.length);

                                                        for (var item
                                                            in value.docs) {
                                                          BorrowBookModel
                                                              borrowBookModel =
                                                              BorrowBookModel
                                                                  .fromMap(item
                                                                      .data());
                                                          print(
                                                              '#### status ${item.id} ===>> ${borrowBookModel.status}');

                                                          if (borrowBookModel
                                                              .status) {
                                                            docIdBookWhereTrue =
                                                                item.id;
                                                          }
                                                        }
                                                      });

                                                      print(
                                                          '#### docIdBorrowBookTrue ===== $docIdBookWhereTrue');

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(docUser)
                                                          .collection('borrow')
                                                          .doc(docBorrowUsers[
                                                              index])
                                                          .update(data1)
                                                          .then((value) async {

                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('book')
                                                            .doc(
                                                                borrowUserModels[
                                                                        index]
                                                                    .docBook)
                                                            .collection(
                                                                'borrow')
                                                            .doc(
                                                                docIdBookWhereTrue)
                                                            .update(data1)
                                                            .then((value) =>
                                                                findUserAndReadBook());
                                                      });
                                                    })
                                                : const SizedBox(),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
              : Center(
                  child: ShowText(
                    text: 'No History',
                    textStyle: MyContant().h1Style(),
                  ),
                ),
    );
  }

  String showBorrow(bool status) {
    String result = 'คืนแล้ว';
    if (status) {
      result = 'กำลังยืมอยู่';
    }
    return result;
  }
}
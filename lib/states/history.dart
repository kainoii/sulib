import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sulib/controller/auth_controller.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/mdels/borrow_user_model.dart';
import 'package:sulib/mdels/refund_model.dart';
import 'package:sulib/services/user_service.dart';
import 'package:sulib/states/show_list_recive_book.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/utility/my_dialog.dart';


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
    // findUserAndReadBook();
  }

  Future<List<BookModel>> getAllBookData(List<String> allBooksIds) async {
    List<BookModel> bookModels = [];
    for(var bookId in allBooksIds) {
      BookModel bookModel = await DatabaseService().getBookById(bookId);
      bookModels.add(bookModel);
    }
    return bookModels;
  }

  Future<Map<String,List<RefundModel>>> findBookRefund() async {
    String userId = AuthController.instance.getUserId();
    List<BorrowUserModel> borrowUserModels = await DatabaseService().getAllBookBorrowByUser(userId);
    List<String> allDocBookId = borrowUserModels.map((userBorrow) => userBorrow.docBook).toList();
    List<BookModel> bookModels = await getAllBookData(allDocBookId);
    List<RefundModel> refundList = [];
    for(int i=0; i < borrowUserModels.length; i++) {
      RefundModel refundModel = RefundModel(bookModel: bookModels[i], borrowUserModel: borrowUserModels[i]);
      refundList.add(refundModel);
    }
    final groupsByRefund = groupBy(refundList, (RefundModel refund) => refund.borrowUserModel.borrowId);
    return groupsByRefund;
  }

  Future<List<String>> findDocumentBookBorrowByBookId(List<String> documentBookIds) async {
    List<String> documentBookBorrows = [];
    for (var docBook in documentBookIds) {
      String documentBookBorrow = await DatabaseService().getDocumentBookBorrowById(docBook);
      documentBookBorrows.add(documentBookBorrow);
    }
    return documentBookBorrows;
  }

  Future<List<String>> findDocumentUserBorrowByUserId(String userId) async {

    List<String> docUserBorrows = await DatabaseService().getDocumentUserBorrowByUserId(userId);
    return docUserBorrows;
  }

  Future updateBookBorrow(String bookId, String docBookBorrow, Map<String, dynamic> data) async {
    await DatabaseService().updateBookBorrow(bookId, docBookBorrow, data);
  }

  Future updateUserBorrow(String userId, String docUserBorrow, Map<String, dynamic> data) async {
    await DatabaseService().updateUserBorrow(userId, docUserBorrow, data);
  }

  Future refundAllBook(List<RefundModel> refundModels) async{
    String userId = AuthController.instance.getUserId();
    List<String> bookIds = refundModels.map((refund) => refund.borrowUserModel.docBook).toList();
    List<String> documentBookBorrow = await findDocumentBookBorrowByBookId(bookIds);
    List<String> documentUserBorrow = await findDocumentUserBorrowByUserId(userId);
    Map<String, dynamic> data = {
      'status' : false
    };
    for(int i=0; i < documentBookBorrow.length; i++) {
      String bookId = refundModels[i].borrowUserModel.docBook;
      String docBookBorrow = documentBookBorrow[i];
      String docUserBorrow = documentUserBorrow[i];
      await updateBookBorrow(bookId, docBookBorrow, data).then((value) => print('Update docBook: ${docBookBorrow[i]}'));
      await updateUserBorrow(userId, docUserBorrow, data).then((value) => print('Update docUser: ${docUserBorrow[i]}'));
    }
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

            // await FirebaseFirestore.instance
            //     .collection('book')
            //     .doc(borrowUserModel.docBook)
            //     .get()
            //     .then((value) {
            //   BookModel bookModel = BookModel.fromMap(value.data()!);
            //   bookModels.add(bookModel);
            // });

  
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
    // return Scaffold(
    //   body: load
    //       ? const Center(child: ShowProgress())
    //       : haveData!
    //           ? LayoutBuilder(builder: (context, constrained) {
    //               return SingleChildScrollView(
    //                 child: Column(
    //                   children: [
    //                     ShowButton(
    //                         width: constrained.maxWidth,
    //                         label: 'รายการจองหนังสือ',
    //                         pressFunc: () => Navigator.push(
    //                             context,
    //                             MaterialPageRoute(
    //                               builder: (context) =>
    //                                   const ShowListReceiveBook(),
    //                             ))),
    //                     ListView.builder(
    //                       shrinkWrap: true,
    //                       physics: const ScrollPhysics(),
    //                       itemCount: borrowUserModels.length,
    //                       itemBuilder: (context, index) => Card(
    //                         child: Row(
    //                           children: [
    //                             SizedBox(
    //                               width: 112,
    //                               height: 200,
    //                               child: Padding(
    //                                 padding: const EdgeInsets.all(8.0),
    //                                 child: CachedNetworkImage(
    //                                     imageUrl: bookModels[index].cover),
    //                               ),
    //                             ),
    //                             SizedBox(
    //                               width: constrained.maxWidth - 120,
    //                               height: 200,
    //                               child: Padding(
    //                                 padding: const EdgeInsets.all(8.0),
    //                                 child: Column(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.end,
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.spaceBetween,
    //                                   children: [
    //                                     ShowText(
    //                                       text: bookModels[index].title,
    //                                       textStyle: MyContant().h2Style(),
    //                                     ),
    //                                     Row(
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.spaceBetween,
    //                                       children: [
    //                                         ShowText(
    //                                           text: showBorrow(
    //                                               borrowUserModels[index]
    //                                                   .status),
    //                                         ),
    //                                         borrowUserModels[index].status
    //                                             ? ShowButton(
    //                                                 label: 'คืนหนังสือ',
    //                                                 pressFunc: () async {
    //                                                   Map<String, dynamic>
    //                                                       data1 = {};
    //                                                   data1['status'] = false;
    //
    //                                                   print(
    //                                                       '#### docIdBorrowUser ${docBorrowUsers[index]}');
    //
    //                                                   await FirebaseFirestore
    //                                                       .instance
    //                                                       .collection('book')
    //                                                       .doc(borrowUserModels[
    //                                                               index]
    //                                                           .docBook)
    //                                                       .collection('borrow')
    //                                                       .get()
    //                                                       .then((value) {
    //                                                     print(
    //                                                         '#### docIdBook ${borrowUserModels[index].docBook}');
    //
    //                                                     print(
    //                                                         value.docs.length);
    //
    //                                                     for (var item
    //                                                         in value.docs) {
    //                                                       BorrowBookModel
    //                                                           borrowBookModel =
    //                                                           BorrowBookModel
    //                                                               .fromMap(item
    //                                                                   .data());
    //                                                       print(
    //                                                           '#### status ${item.id} ===>> ${borrowBookModel.status}');
    //
    //                                                       if (borrowBookModel
    //                                                           .status) {
    //                                                         docIdBookWhereTrue =
    //                                                             item.id;
    //                                                       }
    //                                                     }
    //                                                   });
    //
    //                                                   print(
    //                                                       '#### docIdBorrowBookTrue ===== $docIdBookWhereTrue');
    //
    //                                                   await FirebaseFirestore
    //                                                       .instance
    //                                                       .collection('user')
    //                                                       .doc(docUser)
    //                                                       .collection('borrow')
    //                                                       .doc(docBorrowUsers[
    //                                                           index])
    //                                                       .update(data1)
    //                                                       .then((value) async {
    //
    //                                                     await FirebaseFirestore
    //                                                         .instance
    //                                                         .collection('book')
    //                                                         .doc(
    //                                                             borrowUserModels[
    //                                                                     index]
    //                                                                 .docBook)
    //                                                         .collection(
    //                                                             'borrow')
    //                                                         .doc(
    //                                                             docIdBookWhereTrue)
    //                                                         .update(data1)
    //                                                         .then((value) =>
    //                                                             findUserAndReadBook());
    //                                                   });
    //                                                 })
    //                                             : const SizedBox(),
    //                                       ],
    //                                     )
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               );
    //             })
    //           : Center(
    //               child: ShowText(
    //                 text: 'No History',
    //                 textStyle: MyContant().h1Style(),
    //               ),
    //             ),
    // );

    return buildRefundList();
  }

  String showBorrow(bool status) {
    String result = 'คืนแล้ว';
    if (status) {
      result = 'กำลังยืมอยู่';
    }
    return result;
  }

  Widget buildRefundList() {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 16,),
          buildBorrowButtonWidget(),
          const SizedBox(height: 4,),
          buildReserveButtonWidget(),
          buildBorrowListWidget(),
          const SizedBox(height: 24,),
        ],
      ),
    );
  }

  Widget buildBorrowButtonWidget() => ButtonHistoryWidget(
    title: 'แสดงที่อยู่สำหรับคืนหนังสือ',
    onPressed: ()=> showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40)
          )
        ),
        builder: (context) => buildBottomSheet(),
      ),
  );

  Widget buildReserveButtonWidget() => ButtonHistoryWidget(
    title: 'แสดงรายการหนังสือที่จอง',
    onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ShowListReceiveBook()))
  );
  
  Widget buildBorrowListWidget() {
    return FutureBuilder<Map<String,List<RefundModel>>>(
      future: findBookRefund(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }
        else if (snapshot.connectionState == ConnectionState.none) {
          return const Center(child: Text("ไม่มีรายการหนังสือที่ยืม"));
        } else {
          if (snapshot.hasError) {
            //show Error
            return Center(
              child: RichText(
                text: TextSpan(
                  text: 'some error is occurred:\n',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16
                  ),
                  children: [
                    TextSpan(
                      text: '${snapshot.error}',
                      style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                      )
                    )
                  ]
                ),
              )
            );
          }
          else {
            final mapRefund = snapshot.data!;
            List<List<RefundModel>> listRefundFromMap = [];
            mapRefund.forEach((key, value) => listRefundFromMap.add(value));
            return ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: listRefundFromMap.length,
              itemBuilder: (context, index) {
                List<RefundModel> refundModel = listRefundFromMap[index];
                return RefundBookItemWidget(
                  refundModels: refundModel,
                  onPressed: () async{
                    dialogConfirmRefund(refundModel);
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8,),
            );
          }
        }
      }
    );
  }

  Widget buildBottomSheet() {

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: ()=> Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close,
                size: 40,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16,),
          const Text(
            'ที่อยู่สำหรับจัดส่ง',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24
            ),
          ),
          const SizedBox(height: 8,),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        MyContant.addressLibrary.building!,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18
                        ),
                      ),
                      Text(
                        'เบอร์โทร ${MyContant.addressLibrary.phone}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18
                        ),
                      ),
                      Text(
                        MyContant.addressLibrary.getAddressSummary(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        ),
                      )
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  FlutterClipboard.copy(MyContant.addressLibrary.copyAddressSummary()).then((value) => print('Copied!'));
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("คัดลอกเรียบร้อยแล้ว"), duration: Duration(seconds: 1),));
                },
                icon: const Icon(
                  Icons.file_copy,
                  color: Colors.grey,
                  size: 30,
                ),
                tooltip: 'Copied!',
              ),
            ],
          )
        ],
      ),
    );
  }

  dialogConfirmRefund(List<RefundModel> refundModels) {
    return MyDialog(context: context)
      .warningDialog(
        title: "คุณต้องการคืนหนังสือใช่ไหม",
        okFunc: () async{
          Navigator.of(context).pop();
          await refundAllBook(refundModels).then((value) {
            setState(() {});
          });
        }
    );
  }
}

class RefundBookItemWidget extends StatefulWidget {

  final List<RefundModel> refundModels;
  final Function() onPressed;

  const RefundBookItemWidget({
    Key? key,
    required this.refundModels,
    required this.onPressed
  }) : super(key: key);

  @override
  State<RefundBookItemWidget> createState() => _RefundBookItemWidgetState(refundModels: refundModels, onPressed: onPressed);
}

class _RefundBookItemWidgetState extends State<RefundBookItemWidget> {

  final List<RefundModel> refundModels;
  final Function() onPressed;

  _RefundBookItemWidgetState({required this.refundModels, required this.onPressed});

  bool isLoading = false;

  toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateTime startDate = refundModels.first.borrowUserModel.startDate.toDate();
    DateTime endDate = refundModels.first.borrowUserModel.endDate.toDate();
    final diffDate = endDate.difference(currentDate);
    return Opacity(
      opacity: (refundModels.first.borrowUserModel.status) ? 1 : 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                    offset: Offset(1, 3),
                    blurRadius: 5,
                    spreadRadius: 1,
                    color: Colors.grey
                ),
                BoxShadow(
                    offset: Offset(-1, -3),
                    blurRadius: 5,
                    spreadRadius: 1,
                    color: Colors.white
                ),
              ]
          ),
          child: Column(
            children: [
              //build title in one list
              (refundModels.first.borrowUserModel.status)
              ? Padding(
                padding: const EdgeInsets.all(8),
                child: buildTextCountdownWidget(diffDate.inDays)
              )
              : const SizedBox(height: 16,),

              buildBookDetailItemWidget(refundModels),

              const SizedBox(height: 12,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        'ยืมเมื่อวันที่ ${startDate.day}-${startDate.month}-${startDate.year}',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    ),
                    (refundModels.first.borrowUserModel.status) ?
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                            colors: [Colors.green.shade500, Colors.green.shade700],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight
                        ),
                      ),
                      child: (isLoading)
                        ? const CircularProgressIndicator(color: Colors.green,)
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              padding:const EdgeInsets.symmetric(horizontal: 24, vertical: 4)
                          ),
                          onPressed: onPressed,
                          child: const Text(
                            'คืนหนังสือ',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                    )
                    : Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextCountdownWidget(int diffDate) {
    if (diffDate < 0) {
      return Text(
        'เกินเวลาคืน ${-diffDate} วัน',
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: MyContant.dark
        ),
      );
    }
    if (diffDate == 0) {
      return Text(
        'วันนี้วันสุดท้าย',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: MyContant.dark
        ),
      );
    } else {
      return RichText(
          text: TextSpan(
              text: 'เหลือเวลาอีก ',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black
              ),
              children: [
                TextSpan(
                    text: '${diffDate}',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: MyContant.dark
                    )
                ),
                const TextSpan(
                  text: ' วัน',
                ),
              ]
          )
      );
    }
  }

  Widget buildBookDetailItemWidget(List<RefundModel> refundModel) {
    if (refundModel.length > 3) {
      return buildBookItemVertical(refundModel);
    }
    return buildBookItemHorizontal(refundModel);
  }

  Widget buildBookItemHorizontal(List<RefundModel> refundModels) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          for (int i=0; i < refundModels.length; i++)
            Container(
              height: 100,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                    child: CachedNetworkImage(
                      imageUrl: refundModels[i].bookModel.cover,
                      fit: BoxFit.contain,
                    ),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(-1,-3),
                              blurRadius: 3,
                              spreadRadius: 1,
                              color: Colors.white
                          ),
                          BoxShadow(
                              offset: Offset(1,3),
                              blurRadius: 3,
                              spreadRadius: 1,
                              color: Colors.grey.shade300
                          )
                        ]
                    ),
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                refundModels[i].bookModel.title,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Text(
                            'ISBN ${refundModels[i].bookModel.isbnNumber}',
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 16
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildBookItemVertical(List<RefundModel> refundModels) {
    return Container(
      height: 200,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: refundModels.length,
        physics: (refundModels.first.borrowUserModel.status) ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            height: 200,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(1,3),
                              blurRadius: 3,
                              spreadRadius: 1,
                              color: Colors.grey
                          ),
                          BoxShadow(
                              offset: Offset(-1,-3),
                              blurRadius: 3,
                              spreadRadius: 1,
                              color: Colors.white
                          )
                        ]
                    ),
                    child: CachedNetworkImage(
                      imageUrl: refundModels[index].bookModel.cover,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    refundModels[index].bookModel.title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8,),
      ),
    );
  }


}

  class ButtonHistoryWidget extends StatelessWidget {
    
    final String title;
    final Function() onPressed;

    const ButtonHistoryWidget({ Key? key, required this.title, required this.onPressed }) : super(key: key);
  
    @override
    Widget build(BuildContext context) {
      return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: MyContant.primary,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          minimumSize: const Size.fromHeight(50)
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700
        ),
      ),
    ),
  );
    }
  }

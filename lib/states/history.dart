import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/mdels/borrow_book_model.dart';
import 'package:sulib/mdels/borrow_user_model.dart';
import 'package:sulib/mdels/mock_borrow_user_model.dart';
import 'package:sulib/states/show_list_recive_book.dart';
import 'package:sulib/states/show_progress.dart';
import 'package:sulib/states/show_title.dart';
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

  final List<MockBorrowUserModel> userBorrow = [
    MockBorrowUserModel(
      docBooks: [
        'sdlfjepofow',
        'sdlfjepofow',
        'sdlfjepofow',
        'sdlfjepofow',
        'sdlfjepofow',
      ],
      startDate: Timestamp.now(),
      endDate: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 4)),
      status: true,
    ),
    MockBorrowUserModel(
      docBooks: [
        'sdlfjepofow',
      ],
      startDate: Timestamp.now(),
      endDate: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 4)),
      status: true,
    ),
    MockBorrowUserModel(
      docBooks: [
        'sdlfjepofow',
        'sdkfjewoifjewopf'
      ],
      startDate: Timestamp.now(),
      endDate: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7)),
      status: false,
    ),
    MockBorrowUserModel(
      docBooks: [
        'sdlfjepofow',
        'sdkfjewoifjewopf',
        'soifjewoifjeofj'
      ],
      startDate: Timestamp.now(),
      endDate: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7)),
      status: false,
    ),
  ];

  final List<BookModel> booksList = [
    BookModel(
        cover: 'https://firebasestorage.googleapis.com/v0/b/sulibary.appspot.com/o/cover%2Fkm06.jpg?alt=media&token=1c86a9fd-217d-44fe-9d7c-f9bbbe3f52ec',
        isbnNumber: '9786163810823',
        publisher: 'บริษัทอินส์พัล',
        author: 'บุญร่วม เทียมจันทร์ และ ศรัญญา วิชชาธรรม',
        bookCatetory: 'กฎหมาย',
        bookCode: '02007510',
        detail: 'อัพเดตรัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 ทั้ง 279 มาตรา พร้อมรวบรวมหัวข้อเรื่องทุกมาตรา จับประเด็นง่ายและชัดเจน!',
        numberOfPage: '258',
        title: 'รัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 พร้อมหัวข้อเรื่องทุกมาตรา ฉบับสมบูรณ์',
        yearOfImport: '2018-04-10'
    ),
    BookModel(
        cover: 'https://firebasestorage.googleapis.com/v0/b/sulibary.appspot.com/o/cover%2Fkm08.jpg?alt=media&token=aeaefc78-2eb7-4cd1-aa01-d45469c3757f',
        isbnNumber: '9786163810823',
        publisher: 'บริษัทอินส์พัล',
        author: 'บุญร่วม เทียมจันทร์ และ ศรัญญา วิชชาธรรม',
        bookCatetory: 'กฎหมาย',
        bookCode: '02007510',
        detail: 'อัพเดตรัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 ทั้ง 279 มาตรา พร้อมรวบรวมหัวข้อเรื่องทุกมาตรา จับประเด็นง่ายและชัดเจน!',
        numberOfPage: '258',
        title: 'รัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 พร้อมหัวข้อเรื่องทุกมาตรา ฉบับสมบูรณ์',
        yearOfImport: '2018-04-10'
    ),
    BookModel(
        cover: 'https://firebasestorage.googleapis.com/v0/b/sulibary.appspot.com/o/cover%2Ftr01.jpg?alt=media&token=9534e0c4-90b0-4200-aa5e-a33e9e81c083',
        isbnNumber: '9786163810823',
        publisher: 'บริษัทอินส์พัล',
        author: 'บุญร่วม เทียมจันทร์ และ ศรัญญา วิชชาธรรม',
        bookCatetory: 'กฎหมาย',
        bookCode: '02007510',
        detail: 'อัพเดตรัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 ทั้ง 279 มาตรา พร้อมรวบรวมหัวข้อเรื่องทุกมาตรา จับประเด็นง่ายและชัดเจน!',
        numberOfPage: '258',
        title: 'รัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 พร้อมหัวข้อเรื่องทุกมาตรา ฉบับสมบูรณ์',
        yearOfImport: '2018-04-10'
    ),
    BookModel(
        cover: 'https://firebasestorage.googleapis.com/v0/b/sulibary.appspot.com/o/cover%2Fkm09.jpg?alt=media&token=7b24e14e-eeeb-4dcf-b11d-1c85d6321000',
        isbnNumber: '9786163810823',
        publisher: 'บริษัทอินส์พัล',
        author: 'บุญร่วม เทียมจันทร์ และ ศรัญญา วิชชาธรรม',
        bookCatetory: 'กฎหมาย',
        bookCode: '02007510',
        detail: 'อัพเดตรัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 ทั้ง 279 มาตรา พร้อมรวบรวมหัวข้อเรื่องทุกมาตรา จับประเด็นง่ายและชัดเจน!',
        numberOfPage: '258',
        title: 'รัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 พร้อมหัวข้อเรื่องทุกมาตรา ฉบับสมบูรณ์',
        yearOfImport: '2018-04-10'
    ),
    BookModel(
        cover: 'https://firebasestorage.googleapis.com/v0/b/sulibary.appspot.com/o/cover%2Ftr02.jpg?alt=media&token=e61bbc9b-262f-4d6d-b106-2c7706a12e41',
        isbnNumber: '9786163810823',
        publisher: 'บริษัทอินส์พัล',
        author: 'บุญร่วม เทียมจันทร์ และ ศรัญญา วิชชาธรรม',
        bookCatetory: 'กฎหมาย',
        bookCode: '02007510',
        detail: 'อัพเดตรัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 ทั้ง 279 มาตรา พร้อมรวบรวมหัวข้อเรื่องทุกมาตรา จับประเด็นง่ายและชัดเจน!',
        numberOfPage: '258',
        title: 'รัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 พร้อมหัวข้อเรื่องทุกมาตรา ฉบับสมบูรณ์',
        yearOfImport: '2018-04-10'
    ),
  ];


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

    return buildMockDataWidget();
  }

  String showBorrow(bool status) {
    String result = 'คืนแล้ว';
    if (status) {
      result = 'กำลังยืมอยู่';
    }
    return result;
  }

  Widget buildMockDataWidget() {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 16,),
          buildBorrowButtonWidget(),
          buildBorrowListWidget(),
          const SizedBox(height: 24,),
        ],
      ),
    );
  }
  
  Widget buildBorrowButtonWidget() => Padding(
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
      child: const Text(
        'แสดงที่อยู่สำหรับคืนหนังสือ',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700
        ),
      ),
    ),
  );
  
  Widget buildBorrowListWidget() {
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: userBorrow.length,
      itemBuilder: (context, index) {
        MockBorrowUserModel borrow = userBorrow[index];
        return buildBorrowItemWidget(borrow);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8,),
    );
  }
  
  Widget buildBorrowItemWidget(MockBorrowUserModel borrow) {

    DateTime currentDate = DateTime.now();
    DateTime endDate = borrow.endDate.toDate();
    int diffDate = endDate.difference(currentDate).inDays;

    return Opacity(
      opacity: (borrow.status) ? 1 : 0.5,
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

              borrow.status
              ? Padding(
                padding: const EdgeInsets.all(8),
                child: RichText(
                  text: TextSpan(
                    text: 'เหลือเวลาอีก ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black
                    ),
                    children: [
                      TextSpan(
                        text: '$diffDate',
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
                ),
              )
              : const SizedBox(height: 16,),

              buildBookDetailItemWidget(borrow.docBooks!),

              const SizedBox(height: 12,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        'ยืมเมื่อวันที่ ${endDate.day}-${endDate.month}-${endDate.year}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                        ),
                      ),
                    ),
                    borrow.status ?
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            onPrimary: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)
                            ),
                            padding:const EdgeInsets.symmetric(horizontal: 24, vertical: 4)
                        ),
                        onPressed: () {},
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

  Widget buildBookDetailItemWidget(List<String> docBooks) {
    if (docBooks.length > 3) {
      return buildBookItemVertical(docBooks);
    }
    return buildBookItemHorizontal(docBooks);
  }

  Widget buildBookItemHorizontal(List<String> docBooks) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          for (int i=0; i < docBooks.length; i++)
            Container(
              height: 100,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                    child: CachedNetworkImage(
                      imageUrl: booksList[i].cover,
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
                          Text(
                            booksList[i].title,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'ISBN ${booksList[i].isbnNumber}',
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

  Widget buildBookItemVertical(List<String> docBooks) {
    return Container(
      height: 200,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: docBooks.length,
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
                      imageUrl: booksList[index].cover,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    booksList[index].title,
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

  Widget buildBottomSheet() => Container(
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
                      'อาคาร ห้องสมุดแห่งหนึ่ง',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18
                      ),
                    ),
                    Text(
                      'เบอร์โทร 012-3456789',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18
                      ),
                    ),
                    Text(
                      '12/345 ถนนพงพัน ตำบลเพรียบพร้อม อำเภอตากน้อย จังหวัดพัทลุง 83456',
                      style: TextStyle(
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
              onPressed: (){},
              icon: const Icon(
                Icons.copy,
                size: 30,
                color: Colors.grey,
              ),
              tooltip: 'Copied!',

            ),
          ],
        )
      ],
    ),
  );
}
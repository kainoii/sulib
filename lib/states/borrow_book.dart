import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sulib/mdels/address.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/mdels/borrow_book_model.dart';
import 'package:sulib/mdels/borrow_user_model.dart';
import 'package:sulib/mdels/user_model.dart';
import 'package:sulib/states/show_title.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/utility/my_dialog.dart';
import 'package:sulib/widgets/show_text.dart';
import 'package:http/http.dart' as http;

class BorrowBook extends StatefulWidget {
  final BookModel bookModel;
  final String docUser;
  final String docBook;
  const BorrowBook(
      {Key? key,
      required this.bookModel,
      required this.docUser,
      required this.docBook})
      : super(key: key);

  @override
  State<BorrowBook> createState() => _BorrowBookState(
      bookModel: bookModel, docUser: docUser, docBook: docBook);
}

class _BorrowBookState extends State<BorrowBook> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerBuilding = TextEditingController();
  TextEditingController controllerAddressNumber = TextEditingController();
  TextEditingController controllerMoo = TextEditingController();
  TextEditingController controllerSoi = TextEditingController();
  TextEditingController controllerStreet = TextEditingController();
  TextEditingController controllerSubDistrict = TextEditingController();
  TextEditingController controllerDistrict = TextEditingController();
  TextEditingController controllerProvince = TextEditingController();
  TextEditingController controllerZipCode = TextEditingController();

  List<FocusNode> focusNode = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];

  bool isLoading = false;

  late Address addressUser;

  bool isSuccessFormAddress = false;

  final String docUser;
  final String docBook;
  final BookModel bookModel;

  _BorrowBookState(
      {required this.docUser, required this.docBook, required this.bookModel});

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

  Future<void> processBorrowBook() async {
    setState(() {
      isLoading = true;
    });

    DateTime currentDateTime = DateTime.now();
    DateTime endDateTime = DateTime(
        currentDateTime.year, currentDateTime.month, currentDateTime.day + 7);

    // BorrowUserModel borrowUserModel = BorrowUserModel(
    //   docBook: docBook,
    //   startDate: Timestamp.fromDate(currentDateTime),
    //   endDate: Timestamp.fromDate(endDateTime),
    //   status: true,
    // );

    // print('borrowUserModel ===>> ${borrowUserModel.toMap()}');

    BorrowBookModel borrowBookModel = BorrowBookModel(
        docUser: docUser,
        startDate: Timestamp.fromDate(currentDateTime),
        endDate: Timestamp.fromDate(endDateTime),
        status: true);

    print('borrowBookModel ===>> ${borrowBookModel.toMap()}');

    bool isBookBorrow = await isBookBorrowed();

    // await FirebaseFirestore.instance
    //     .collection('user')
    //     .doc(docUser)
    //     .collection('borrow')
    //     .doc()
    //     .set(borrowUserModel.toMap())
    //     .then((value) async {
    //
    //   await FirebaseFirestore.instance
    //       .collection('book')
    //       .doc(docBook)
    //       .collection('borrow')
    //       .doc()
    //       .set(borrowBookModel.toMap())
    //       .then((value) {
    //     sendEmail().then((value) {
    //       setState(() {
    //         isLoading = false;
    //       });
    //       Navigator.pop(context, true);
    //     });
    //
    //   });
    //
    // });
  }

  Future sendEmail() async {
    final serviceId = 'service_697yyoo';
    final templateId = 'template_lq94msz';
    final userId = '1nvoZ0x2hkYsJR-06';

    UserModel user = await getUserData();

    DateTime currentDateTime = DateTime.now();
    DateTime endDateTime = DateTime(
        currentDateTime.year, currentDateTime.month, currentDateTime.day + 7);

    final String user_name = user.name;
    final String user_email = user.email;
    final String book_title = bookModel.title;
    final String user_address = getAddressSummary();
    String start_borrow_date;
    String end_borrow_date;
    if (currentDateTime.month < 10) {
      start_borrow_date =
          "${currentDateTime.day}/0${currentDateTime.month}/${currentDateTime.year + 543}";
      end_borrow_date =
          "${endDateTime.day}/0${endDateTime.month}/${endDateTime.year + 543}";
    } else {
      start_borrow_date =
          "${currentDateTime.day}/${currentDateTime.month}/${currentDateTime.year + 543}";
      end_borrow_date =
          "${endDateTime.day}/${endDateTime.month}/${endDateTime.year + 543}";
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
            'start_borrow_date': start_borrow_date,
            'end_borrow_date': end_borrow_date,
            'user_address': user_address
          }
        }));
    print(response.body);
  }

  Future<UserModel> getUserData() async {
    final response =
        await FirebaseFirestore.instance.collection('user').doc(docUser).get();

    return UserModel.fromMap(response.data()!);
  }

  @override
  void initState() {
    for (int i = 0; i < focusNode.length; i++) {
      focusNode[i].addListener(() {
        print("focus ${i} : ${focusNode[i].hasFocus}");
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    controllerAddressNumber.dispose();
    controllerBuilding.dispose();
    controllerMoo.dispose();
    controllerSoi.dispose();
    controllerStreet.dispose();
    controllerSubDistrict.dispose();
    controllerDistrict.dispose();
    controllerProvince.dispose();
    controllerZipCode.dispose();
    for (var focus in focusNode) {
      focus.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildBorrowBookAppBar(), body: buildBorrowBookBody());
  }

  AppBar buildBorrowBookAppBar() => AppBar(
        title: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: const Text(
            "?????????????????????????????????????????????????????????",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: MyContant.primary,
      );

  Widget buildBorrowBookBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 32,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: bookModel.cover,
              width: 100,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            bookModel.title,
            style: MyContant().h2Style(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 32,
          ),
          // buildForm()

          AnimatedContainer(
            duration: const Duration(seconds: 3),
            curve: Curves.easeInOut,
            child: isSuccessFormAddress
                ? buildSummaryAddress()
                : buildFormAddress(),
          )
        ],
      ),
    );
  }

  Widget buildFormAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const Text(
              '???????????????????????????????????????????????????',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                child: TextFormField(
                    controller: controllerBuilding,
                    focusNode: focusNode[0],
                    onTap: () =>
                        FocusScope.of(context).requestFocus(focusNode[0]),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: Color(0xffB87878), width: 2),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: '??????????????? / ???????????????????????? :',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        hintText: "??????????????????????????? ???????????????.... ???????????? ????????????????????????....",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        )),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (String str) {
                      FocusScope.of(context).requestFocus(focusNode[1]);
                    }),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerAddressNumber,
                      focusNode: focusNode[1],
                      onTap: () =>
                          FocusScope.of(context).requestFocus(focusNode[1]),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Color(0xffB87878), width: 2),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          labelText: '?????????????????????????????? :',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          hintText: "??????????????????????????????",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "* ?????????????????????????????????????????????????????????";
                        }
                        return null;
                      },
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (String str) {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).requestFocus(focusNode[2]);
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerSoi,
                      focusNode: focusNode[2],
                      onTap: () =>
                          FocusScope.of(context).requestFocus(focusNode[2]),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: Color(0xffB87878), width: 2),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: "????????? :",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        hintText: "?????????",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (String str) {
                        FocusScope.of(context).requestFocus(focusNode[3]);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerMoo,
                      focusNode: focusNode[3],
                      onTap: () =>
                          FocusScope.of(context).requestFocus(focusNode[3]),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Color(0xffB87878), width: 2),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          labelText: '????????????????????? :',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          hintText: "?????????????????????",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          )),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (String str) {
                        FocusScope.of(context).requestFocus(focusNode[4]);
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerStreet,
                      focusNode: focusNode[4],
                      onTap: () =>
                          FocusScope.of(context).requestFocus(focusNode[4]),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: Color(0xffB87878), width: 2),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: "????????? :",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        hintText: "?????????",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (String str) {
                        FocusScope.of(context).requestFocus(focusNode[5]);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  controller: controllerSubDistrict,
                  focusNode: focusNode[5],
                  onTap: () =>
                      FocusScope.of(context).requestFocus(focusNode[5]),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: Color(0xffB87878), width: 2),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: '????????????/???????????? :',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      hintText: "????????????/????????????",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* ??????????????????????????? ????????????/????????????";
                    }
                    return null;
                  },
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (String str) {
                    FocusScope.of(context).requestFocus(focusNode[6]);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  controller: controllerDistrict,
                  focusNode: focusNode[6],
                  onTap: () =>
                      FocusScope.of(context).requestFocus(focusNode[6]),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: Color(0xffB87878), width: 2),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: '???????????????/????????? :',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      hintText: "???????????????/?????????",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* ??????????????????????????? ???????????????/?????????";
                    }
                    return null;
                  },
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (String str) {
                    FocusScope.of(context).requestFocus(focusNode[7]);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  controller: controllerProvince,
                  focusNode: focusNode[7],
                  onTap: () =>
                      FocusScope.of(context).requestFocus(focusNode[7]),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: Color(0xffB87878), width: 2),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: '????????????????????? :',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      hintText: "?????????????????????",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* ??????????????????????????? ?????????????????????";
                    }
                    return null;
                  },
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (String str) {
                    FocusScope.of(context).requestFocus(focusNode[8]);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  controller: controllerZipCode,
                  focusNode: focusNode[8],
                  onTap: () =>
                      FocusScope.of(context).requestFocus(focusNode[8]),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: Color(0xffB87878), width: 2),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: '???????????????????????????????????? :',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      hintText: "????????????????????????????????????",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* ??????????????????????????? ???????????????????????????????????? ??????????????????????????????";
                    }
                    return null;
                  },
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done),
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  primary: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: StadiumBorder(
                      side: BorderSide(width: 2, color: MyContant.dark)),
                  elevation: 2),
              icon: Icon(
                Icons.home_rounded,
                color: MyContant.dark,
                size: 24,
              ),
              label: Text(
                "?????????????????????????????????????????????????????????",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: MyContant.dark),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setAddressUser();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void setAddressUser() {
    Address address = Address(
        firstName: '???????????????',
        lastName: '?????????????????????????????????????????????',
        phone: '0874487856',
        addressNumber: controllerAddressNumber.text.toString(),
        building: controllerBuilding.text.isNotEmpty
            ? controllerBuilding.text.toString()
            : null,
        moo: controllerMoo.text.isNotEmpty
            ? controllerMoo.text.toString()
            : null,
        soi: controllerSoi.text.isNotEmpty
            ? controllerSoi.text.toString()
            : null,
        street: controllerStreet.text.isNotEmpty
            ? controllerStreet.text.toString()
            : null,
        district: controllerDistrict.text.toString(),
        subDistrict: controllerSubDistrict.text.toString(),
        province: controllerProvince.text.toString(),
        zipCode: controllerZipCode.text.toString(),
        isDefault: false);
    setState(() {
      addressUser = address;
      isSuccessFormAddress = true;
    });
  }

  Widget buildSummaryAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: (addressUser != null)
          ? Column(
              children: [
                const Text(
                  '???????????????????????????????????????',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 16,
                ),
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() => isSuccessFormAddress = false),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MyContant.dark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              (addressUser != null)
                                  ? getAddressSummary()
                                  : 'test',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              onTap: () =>
                                  setState(() => isSuccessFormAddress = false),
                              child: const Icon(
                                Icons.navigate_next_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    primary: MyContant.dark,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: (addressUser == null)
                      ? null
                      : isLoading
                          ? null
                          : () async {
                              showDialogConfirm();
                            },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "????????????????????????????????????",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                )
              ],
            )
          : const Center(
              child: Text('????????????????????????????????????????????????????????????????????????'),
            ),
    );
  }

  String getAddressSummary() {
    String address = "";
    if (addressUser.building != null) {
      address = address + addressUser.building! + "\n";
    }
    address = address + addressUser.addressNumber;
    if (addressUser.moo != null) {
      address = address + " ?????????????????????" + addressUser.moo!;
    }
    if (addressUser.soi != null) {
      address = address + " ?????????" + addressUser.soi! + "\n";
    }
    if (addressUser.street != null) {
      address = address + " ?????????" + addressUser.street! + "\n";
    }
    address = address + " ????????????" + addressUser.subDistrict;
    address = address + " ???????????????" + addressUser.district + "\n";
    address = address + " ?????????????????????" + addressUser.province;
    address = address + " " + addressUser.zipCode;

    return address;
  }

  Future showDialogConfirm() async {
    setState(() {
      isLoading = true;
    });

    bool isBookBorrow = await isBookBorrowed();

    setState(() {
      isLoading = false;
    });

    if (!isBookBorrow) {
      DateTime currentDateTime = DateTime.now();
      DateTime endDateTime = DateTime(
          currentDateTime.year, currentDateTime.month, currentDateTime.day + 7);
      MyDialog(context: context).confirmAction(
          title: bookModel.title,
          message:
              '??????????????? ${showDate(currentDateTime)} \n ????????? ${showDate(endDateTime)}',
          urlBook: bookModel.cover,
          okFunc: () {
            Navigator.pop(context);
            processBorrowBook();
          });
    } else {
      setState(() {
        isLoading = false;
      });
      MyDialog(context: context).normalDialog(
          '??????????????????????????????????????????', '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????');
    }
  }

  String showDate(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy');
    String result = dateFormat.format(dateTime);
    return result;
  }
}

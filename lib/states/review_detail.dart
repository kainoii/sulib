

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/mdels/borrow_user_model.dart';
import 'package:sulib/mdels/review-model.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/widgets/show_text.dart';

class ReviewDetail extends StatefulWidget {
  final String docBorrowId;
  final String docUser;
  final BorrowUserModel borrowUserModel;
  final BookModel bookModel;

  const ReviewDetail({ 
    Key? key, 
    required this.docBorrowId,
    required this.docUser, 
    required this.borrowUserModel, 
    required this.bookModel 
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<ReviewDetail> createState() => _ReviewDetailState(
    docBorrowId: docBorrowId,
    docUser: docUser,
    borrowUserModel: borrowUserModel,
    bookModel: bookModel
  );
}

class _ReviewDetailState extends State<ReviewDetail> {

  final String docBorrowId;
  final String docUser;
  final BorrowUserModel borrowUserModel;
  final BookModel bookModel;

  _ReviewDetailState({
    required this.docBorrowId,
    required this.docUser, 
    required this.borrowUserModel, 
    required this.bookModel
  });

  TextEditingController controllerReview = TextEditingController();

  double rate = 0;

  bool isLoading = false;

  bool isReviewSuccess = false;

  bool isSuccessdocUser = false;
  bool isSuccessdocBook = false;

  @override
  void dispose() {
    controllerReview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title:const Text('Review'),
              backgroundColor: MyContant.primary,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: (isLoading)
                ? pageProcessWidget()
                : (isReviewSuccess) 
                ? pageProcessWidget()
                : pageStartWidget()
              ),
            ),
          ),
        ),
      );
  }

  Future<bool> onWillPop() async {
    if(controllerReview.text.isEmpty) {
      return true;
    } 
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ออกจากหน้านี้หรือไม่ ?', style: TextStyle(color: MyContant.dark),),
        content: const Text('ข้อมูลทั้งหมดจะไม่ถูกบันทึก'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: MyContant.dark
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: MyContant.dark
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('ยืนยัน'),
          ),
        ],
      )
    );

    return shouldPop ?? false;

  }

  Widget pageStartWidget() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildBookImage(),
      buildBookTitle(),
      buildRatingStar(),
      buildTextFieldDescription(),
      buildButton(),
    ],
  );

  Widget pageProcessWidget() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    // ignore: prefer_const_literals_to_create_immutables
    children: [
      buildLoadingImage(),
      const SizedBox(
        height: 100,
      ),
      buildTextLoading(isLoading ? "กำลังดำเนินการส่ง" : "ดำเนินการรีวิวเรียบร้อย"),
      (isLoading) ?
      Container()
      : buildBackButton()
    ],
  );

  Widget buildBookImage() => CachedNetworkImage(
      imageUrl: bookModel.cover,
      fit: BoxFit.contain,
      width: 100,
      height: 180,
    );

  Widget buildBookTitle() => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: ShowText(
      text: bookModel.title,
      textStyle: TextStyle(
        color: MyContant.dark,
        fontWeight: FontWeight.w700,
        fontSize: 18
      ),
    )
  );

  Widget buildRatingStar() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: RatingBar.builder(
      initialRating: 0,
      minRating: 0,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 8),
      itemSize: 40,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      glowColor: Colors.white,
      onRatingUpdate: (rating) {
        setState(() {
          rate = rating;
        });
      },
    ),
  );

  Widget buildTextFieldDescription() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: TextField(
      controller: controllerReview,
      decoration: InputDecoration(
          fillColor: (controllerReview.text != "") ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Colors.grey, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Colors.grey, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          hintText: 'เพิ่มข้อคิดเห็นกับหนังสือ มาแชร์กันได้ที่นี่',
          hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey
          )
      ),
      cursorColor: MyContant.black,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: MyContant.black
      ),
      maxLines: 6,
    )
  );


  Widget buildButton() => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 32),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: MyContant.dark,
                shape: const StadiumBorder()
              ),
              onPressed: () async{
                FocusScope.of(context).unfocus();
                setState(() {
                  isLoading = true;
                });
                    ReviewModel review = ReviewModel(
                      rate: rate, 
                      description: controllerReview.text.toString(), 
                      date: Timestamp.fromDate(DateTime.now())
                    );

                    Map<String, dynamic> data = {
                      'review' : review.toMapReview()
                    };
                await updateUserReview(data);
                await updateBookReview(data);
                if (isSuccessdocUser && isSuccessdocBook) {
                  setState(() {
                    isLoading = false;
                    isReviewSuccess = true;
                    controllerReview.clear();
                  });
                }
              },
              child: const Text(
                'ยืนยัน',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white
                ),
              ),
            ),
          ),

          const SizedBox(width: 16,),

          Expanded(
            flex: 1,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: MyContant.dark, width: 1),
                shape: StadiumBorder()
              ),
              onPressed: (){
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
              child: Text(
                'กลับสู่หน้าหลัก',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: MyContant.dark
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );

  Future updateUserReview(Map<String, dynamic> data) async{

    FirebaseFirestore.instance
      .collection('user')
      .doc(docUser)
      .collection('borrow')
      .doc(docBorrowId)
      .update(data).then((value) {
        setState(() {
          isSuccessdocUser = true;
        });
      });
    
  }

  Future updateBookReview(Map<String, dynamic> data) async{

    List<String> docBookBorrowUserList = await getdocBookBorrowUserId();

    String docBookBorrowUser = docBookBorrowUserList.first;

    final response = await FirebaseFirestore.instance
                      .collection('book')
                      .doc(borrowUserModel.docBook)
                      .collection('borrow')
                      .doc(docBookBorrowUser)
                      .update(data)
                      .then((value) {
                        isSuccessdocBook = true;
                      });
  }

  Future<List<String>> getdocBookBorrowUserId() async{
    List<String> result = [];
    final value = await FirebaseFirestore.instance
                      .collection('book')
                      .doc(borrowUserModel.docBook)
                      .collection('borrow')
                      .where('docUser', isEqualTo: docUser)
                      .where('startDate', isEqualTo: borrowUserModel.startDate)
                      .where('endDate', isEqualTo: borrowUserModel.endDate)
                      .where('status', isEqualTo: false)
                      .get();
    if (value.docs.isNotEmpty) {
      for (var item in value.docs) {
          result.add(item.id);
          print("========= id BookBorrowUser = ${ item.id }");
        }
    }
    return result;
  }

  Widget buildLoadingImage() => SizedBox(
    width: 100,
    height: 100,
    child: (isLoading)
    ? const CircularProgressIndicator(color: Colors.teal)
    : Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.teal,
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 50,
      ),
    )
  );

  Widget buildTextLoading(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: ShowText(
      text: text,
      textStyle: TextStyle(
        color: MyContant.black,
        fontWeight: FontWeight.w700,
        fontSize: 24
      ),
    ),
  );

  Widget buildBackButton() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: MyContant.dark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        elevation: 2,
      ),
      onPressed: () {
        Navigator.of(context).pop({'isReview' : true});
      },
      icon: const Icon(
        Icons.arrow_back_ios,
        size: 24,
        color: Colors.white,
      ),
      label: const ShowText(
        text: "กลับสู่หน้าหลัก",
        textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 24
        ),
      ),
    ),
  );
}
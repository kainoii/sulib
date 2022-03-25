

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/widgets/show_text.dart';

class ReviewDetail extends StatefulWidget {
  const ReviewDetail({ Key? key }) : super(key: key);

  @override
  State<ReviewDetail> createState() => _ReviewDetailState();
}

class _ReviewDetailState extends State<ReviewDetail> {

  TextEditingController controllerReview = TextEditingController();

  double rate = 0;

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildBookImage(),
                    buildBookTitle(),
                    buildRatingStar(),
                    buildTextFieldDescription(),
                    buildButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    // return GestureDetector(
    //   onTap: () => FocusScope.of(context).unfocus(),
    //   child: 
    // );
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

  Widget buildBookImage() => const SizedBox(
    width: 100,
    height: 180,
    child: FittedBox(
      fit: BoxFit.contain,
      child: Icon(
        Icons.image,
        color: Colors.grey,
      ),
    ),
  );

  Widget buildBookTitle() => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: ShowText(
      text:'ชื่อเรื่อง',
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
      itemPadding: EdgeInsets.symmetric(horizontal: 8),
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
                shape: StadiumBorder()
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
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
}
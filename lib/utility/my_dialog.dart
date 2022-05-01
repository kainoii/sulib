import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/widgets/show_logo.dart';
import 'package:sulib/widgets/show_text.dart';

class MyDialog {
  final BuildContext context;
  MyDialog({
    required this.context,
  });
  Future<void> confirmAction({
    required String title,
    required String message,
    required String urlBook,
    required Function() okFunc,
    String? contentStr,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: ListTile(
          leading: CachedNetworkImage(imageUrl: urlBook),
          title: ShowText(
            text: title,
            textStyle: MyContant().h2Style(),
          ),
          subtitle: ShowText(text: message),
        ),
        content:
             ShowText(text: contentStr ?? "คุณต้องการ ยืมหนังสือ เล่มนี่ ใช่หรือไม่"),
        actions: [
          TextButton(
            onPressed: okFunc,

            child: const Text("OK"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Future<void> normalDialog(String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: const Showlogo(),
          title: ShowText(
            text: title,
            textStyle: MyContant().h2Style(),
          ),
          subtitle: ShowText(text: message),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  Future<void> warningDialog({
    required String title,
    String? subTitle,
    required Function() okFunc,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Lottie.asset(
                    'assets/icon_animate/warning-lotto.json',
                  )
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subTitle != null
                ? Text(
                  subTitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )
                : Container(),

                const SizedBox(height: 16,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white,
                        ),
                        onPressed: ()=> Navigator.of(context).pop(),
                        child: const Text(
                          'ยกเลิก',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16,),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                        ),
                        onPressed: okFunc,
                        child: const Text(
                          'ยืนยัน',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }

  Future<void> confirmBorrowDialog({
    required String startDate,
    required String endDate,
    required List<BookModel> bookModels,
    required Function() okFunc,
  }) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16,),
                    Text(
                      "คุณต้องการยืมหนังสือหรือไม่",
                      style: TextStyle(
                        color: MyContant.dark,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12,),
                    const Text(
                      "รายการหนังสือ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6,),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                            height: (bookModels.length > 2) ? 250 : bookModels.length * 100,
                            child: ListView.builder(
                              itemCount: bookModels.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                BookModel bookModel = bookModels[index];
                                return Container(
                                  height: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: CachedNetworkImage(
                                            imageUrl: bookModel.cover,
                                            fit: BoxFit.contain,
                                          ),
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(1,3),
                                                    blurRadius: 3,
                                                    spreadRadius: 1,
                                                    color: Colors.grey.shade300
                                                ),
                                                const BoxShadow(
                                                    offset: Offset(-1,-3),
                                                    blurRadius: 3,
                                                    spreadRadius: 1,
                                                    color: Colors.white
                                                )
                                              ]
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16,),
                                      Expanded(
                                          flex: 4,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  child: Text(
                                                    bookModel.title,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 16
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ),
                                              const SizedBox(height: 8,),
                                              Text(
                                                'ISBN ${bookModel.isbnNumber}',
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
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Text(
                      'คืนภายในวันที่ $endDate',
                      style: TextStyle(
                          color: MyContant.dark,
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.green,
                              shape: const StadiumBorder()
                            ),
                            onPressed: ()=> Navigator.of(context).pop(),
                            child: const Text(
                              'ยกเลิก',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16,),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Colors.white,
                              shape: const StadiumBorder()
                            ),
                            onPressed: okFunc,
                            child: const Text(
                              'ยืนยัน',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
    );
  }

  Future<void> errorBorrowDialog({
    required List<BookModel> bookModels
  }) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "หนังสือถูกยืมไปแล้ว",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Container(
                      height: (bookModels.length > 2) ? 250 : bookModels.length * 100,
                      child: ListView.builder(
                        itemCount: bookModels.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          BookModel bookModel = bookModels[index];
                          return Container(
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: CachedNetworkImage(
                                      imageUrl: bookModel.cover,
                                      fit: BoxFit.contain,
                                    ),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1,3),
                                              blurRadius: 3,
                                              spreadRadius: 1,
                                              color: Colors.grey.shade300
                                          ),
                                          const BoxShadow(
                                              offset: Offset(-1,-3),
                                              blurRadius: 3,
                                              spreadRadius: 1,
                                              color: Colors.white
                                          )
                                        ]
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16,),
                                Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            child: Text(
                                              bookModel.title,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ),
                                        Text(
                                          'ISBN ${bookModel.isbnNumber}',
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
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16,),
                    const Text(
                      'กรุณานำหนังสือเหล่านี้ออกจากตะกร้า',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 16,),
                        Expanded(
                          child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              primary: MyContant.dark,
                              onPrimary: Colors.white,
                              shape:  StadiumBorder(
                                side: BorderSide(width: 2, color: MyContant.dark)
                              ),
                            ),
                            onPressed: ()=> Navigator.of(context).pop(),
                            child: const Text(
                              'ปิด',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
}

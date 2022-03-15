import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
}

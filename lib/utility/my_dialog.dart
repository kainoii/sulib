import 'package:flutter/material.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/widgets/show_logo.dart';
import 'package:sulib/widgets/show_text.dart';

class MyDialog {
  final BuildContext context;
  MyDialog({
    required this.context,
  });

  Future<void> normalDialog(String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: Showlogo(),
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

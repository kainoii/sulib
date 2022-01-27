import 'package:flutter/material.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/widgets/show_text.dart';

class ShowButton extends StatelessWidget {
  final String label;
  final Function() pressFunc;
  final Color? primaryColor;
  final double? width;
  const ShowButton({
    Key? key,
    required this.pressFunc,
    required this.label,
    this.primaryColor,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      width: width ?? 150,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: primaryColor ?? MyContant.light,
            shape: RoundedRectangleBorder(side: BorderSide(color: MyContant.dark),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: pressFunc,
          child: ShowText(
            text: label,
            textStyle: MyContant().h2Style(),
          )),
    );
  }
}

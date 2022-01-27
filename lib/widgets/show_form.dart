import 'package:flutter/material.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/widgets/show_text.dart';

class ShowForm extends StatelessWidget {
  final String label;
  final Function(String) changeFunc;
  const ShowForm({
    Key? key,
    required this.label,
    required this.changeFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: 250,
      height: 40,
      child: TextFormField(
        onChanged: changeFunc,
        decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
            fillColor: Colors.white.withOpacity(0.5),
            filled: true,
            label: ShowText(text: label),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyContant.dark),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyContant.light),
              borderRadius: BorderRadius.circular(20),
            )),
      ),
    );
  }
}

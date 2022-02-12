import 'package:flutter/material.dart';

import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/widgets/show_text.dart';

class ShowTitle extends StatelessWidget {
  final String title;
  const ShowTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShowText(
            text: title,
            textStyle: MyContant().h2Style(),
          ),
        ),
      ],
    );
  }
}

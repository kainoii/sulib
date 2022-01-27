import 'package:flutter/material.dart';

class Showlogo extends StatelessWidget {
  const Showlogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset('images/logo.png');
  }
}

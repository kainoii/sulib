import 'package:flutter/material.dart';

class Showlogo extends StatelessWidget {
  final String? path;
  const Showlogo({
    Key? key,
    this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(path ?? 'images/logo.png');
  }
}

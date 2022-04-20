import 'package:flutter/material.dart';

class DismissibleWidget<T> extends StatelessWidget {

  final T item;
  final Widget child;
  final DismissDirectionCallback onDismissed;

  const DismissibleWidget({
    Key? key,
    required this.item,
    required this.child,
    required this.onDismissed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Dismissible(
    direction: DismissDirection.endToStart,
    key: ObjectKey(item),
    background: Container(),
    secondaryBackground: buildSwipeActionRight(),
    child: child,
    onDismissed: onDismissed,
  );

  Widget buildSwipeActionRight() => Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    color: Colors.red,
    child: const Icon(Icons.delete_forever, color: Colors.white, size: 32,),
  );
}

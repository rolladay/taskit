
import 'package:flutter/material.dart';

class MyBtnContainer extends StatelessWidget {
  const MyBtnContainer({
    super.key, required this.color, this.child
  });

  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(width: 1, color: Colors.black87),
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      height: 50.0,
      child: child,
    );
  }
}
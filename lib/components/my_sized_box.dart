import 'package:flutter/material.dart';


class MySizedBox extends StatelessWidget {
  const MySizedBox({
    super.key, required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
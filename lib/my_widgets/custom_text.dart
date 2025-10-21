import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key,
      required this.text,
      required this.size,
      required this.weight,
      required this.coul,
      this.maxligne});
  final String text;
  final double size;
  final FontWeight weight;
  final Color coul;
  final int? maxligne;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: coul,
        fontWeight: weight,
      ),
      maxLines: maxligne ?? 1,
    );
  }
}
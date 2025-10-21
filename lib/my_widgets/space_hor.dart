import 'package:flutter/material.dart';

class SpaceH extends StatelessWidget {
  const SpaceH({super.key, required this.w});
  final double w;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
    );
  }
}

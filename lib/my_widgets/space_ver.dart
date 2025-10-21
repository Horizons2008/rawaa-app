import 'package:flutter/material.dart';

class SpaceV extends StatelessWidget {
  const SpaceV({super.key, required this.h});
  final double h;


  @override
  Widget build(BuildContext context) {
    return  SizedBox(height: h,);
  }
}
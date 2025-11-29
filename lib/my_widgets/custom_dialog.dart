import 'package:flutter/material.dart';

class CustomDialog1 extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  const CustomDialog1({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions,
    );
  }
}

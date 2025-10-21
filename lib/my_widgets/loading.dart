import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WidgetLoading extends StatelessWidget {
  const WidgetLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blue),
          SizedBox(height: 10),
          Text("Chargement en cours "),
        ],
      ),
    );
  }
}

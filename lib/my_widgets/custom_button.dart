import 'package:flutter/material.dart';
import 'package:rawaa_app/styles/my_color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.titre,
    required this.onclick,
    this.corner,
  });
  final Widget titre;
  final VoidCallback? onclick;
  final double? corner;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onclick,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(corner ?? 10),
        ),
        disabledBackgroundColor: MyColor.grey,
        backgroundColor: MyColor.primaryColor,
      ),
      child: Container(height: 50, alignment: Alignment.center, child: titre),
    );
  }
}

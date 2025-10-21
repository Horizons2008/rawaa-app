import 'package:flutter/material.dart';
import 'package:rawaa_app/styles/my_color.dart';

class OutlinedEditS extends StatelessWidget {
  const OutlinedEditS({
    super.key,
    this.hint,
    this.onChange,
    this.controller,
    this.iconDroite,
    this.showPass,
    this.dataType,
    this.validation,
    this.label,
    this.errorText,
    this.onClick,
    this.readOnly,
    //th,
  });
  final String? hint;
  final ValueChanged<String>? onChange;
  final VoidCallback? onClick;
  final bool? readOnly;

  final String? Function(String?)? validation;

  final TextEditingController? controller;
  final TextInputType? dataType;
  final String? label;
  final String? errorText;

  final Widget? iconDroite;
  final bool? showPass;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextFormField(
        cursorColor: MyColor.primaryColor,
        scrollPadding: EdgeInsets.all(0),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        forceErrorText: errorText,
        readOnly: readOnly ?? false,
        onTap: onClick,
        keyboardType: dataType ?? TextInputType.text,
        obscureText: showPass ?? false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 5),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: MyColor.primaryColor,
              width: 0.7,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
          ),
          labelText: hint,
          suffixIcon: iconDroite,
        ),
        onChanged: onChange,
        controller: controller,
        validator: validation,
      ),
    );
  }
}
